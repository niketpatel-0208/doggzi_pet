from fastapi import FastAPI, HTTPException, Depends, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager
from typing import List
from datetime import datetime, timedelta
from bson import ObjectId
import logging

from models import UserCreate, UserLogin, Token, PetCreate, Pet, ErrorResponse
from auth import verify_password, get_password_hash, create_access_token, verify_token
from database import connect_to_mongo, close_mongo_connection, get_database
from config import settings

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Security
security = HTTPBearer()

# Lifespan context manager
@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    await connect_to_mongo()
    yield
    # Shutdown
    await close_mongo_connection()

app = FastAPI(
    title="Pawzy Pet Management API", 
    version="1.0.0",
    description="Backend API for Pawzy pet management application",
    lifespan=lifespan
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["GET", "POST"],
    allow_headers=["*"],
)

# Dependency to get current user
async def get_current_user(credentials: HTTPAuthorizationCredentials = Depends(security)) -> dict:
    token = credentials.credentials
    return verify_token(token)

# Health check endpoint
@app.get("/health")
async def health_check():
    return {"status": "healthy", "service": "pawzy-api"}

# Auth endpoints
@app.post("/auth/register", response_model=Token, status_code=status.HTTP_201_CREATED)
async def register_user(user: UserCreate):
    try:
        db = get_database()
        
        # Check if user already exists
        existing_user = await db.users.find_one({"email": user.email})
        if existing_user:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Email already registered"
            )
        
        # Create new user
        hashed_password = get_password_hash(user.password)
        user_doc = {
            "email": user.email,
            "hashed_password": hashed_password,
            "created_at": datetime.utcnow()
        }
        
        result = await db.users.insert_one(user_doc)
        if not result.inserted_id:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="Failed to create user"
            )
        
        # Create access token
        access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
        access_token = create_access_token(
            data={"sub": user.email}, 
            expires_delta=access_token_expires
        )
        
        logger.info(f"User registered successfully: {user.email}")
        return {"access_token": access_token, "token_type": "bearer"}
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Registration error: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Internal server error"
        )

@app.post("/auth/login", response_model=Token)
async def login_user(user: UserLogin):
    try:
        db = get_database()
        
        # Find user by email
        db_user = await db.users.find_one({"email": user.email})
        if not db_user or not verify_password(user.password, db_user["hashed_password"]):
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Incorrect email or password"
            )
        
        # Create access token
        access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
        access_token = create_access_token(
            data={"sub": user.email}, 
            expires_delta=access_token_expires
        )
        
        logger.info(f"User logged in successfully: {user.email}")
        return {"access_token": access_token, "token_type": "bearer"}
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Login error: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Internal server error"
        )

# Pet endpoints
@app.get("/pets", response_model=List[Pet])
async def get_pets(current_user: dict = Depends(get_current_user)):
    try:
        db = get_database()
        
        pets_cursor = db.pets.find({"owner_email": current_user["email"]})
        pets = []
        
        async for pet in pets_cursor:
            pets.append({
                "id": str(pet["_id"]),
                "name": pet["name"],
                "type": pet["type"],
                "age": pet["age"],
                "notes": pet.get("notes"),
                "created_at": pet["created_at"]
            })
        
        logger.info(f"Retrieved {len(pets)} pets for user: {current_user['email']}")
        return pets
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Get pets error: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Internal server error"
        )

@app.post("/pets", response_model=Pet, status_code=status.HTTP_201_CREATED)
async def create_pet(pet: PetCreate, current_user: dict = Depends(get_current_user)):
    try:
        db = get_database()
        
        # Create pet document
        pet_doc = {
            "name": pet.name,
            "type": pet.type,
            "age": pet.age,
            "notes": pet.notes,
            "owner_email": current_user["email"],
            "created_at": datetime.utcnow()
        }
        
        result = await db.pets.insert_one(pet_doc)
        if not result.inserted_id:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="Failed to create pet"
            )
        
        # Return created pet
        created_pet = {
            "id": str(result.inserted_id),
            "name": pet.name,
            "type": pet.type,
            "age": pet.age,
            "notes": pet.notes,
            "created_at": pet_doc["created_at"]
        }
        
        logger.info(f"Pet created successfully: {pet.name} for user: {current_user['email']}")
        return created_pet
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Create pet error: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Internal server error"
        )

if __name__ == "__main__":
    import uvicorn
    import os
    port = int(os.environ.get("PORT", 8000))
    uvicorn.run(app, host="0.0.0.0", port=port)
