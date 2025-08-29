from pydantic import BaseModel, EmailStr, Field
from typing import Optional
from datetime import datetime

class UserCreate(BaseModel):
    email: EmailStr
    password: str = Field(..., min_length=6)

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"

class PetCreate(BaseModel):
    name: str = Field(..., min_length=1, max_length=50)
    type: str = Field(..., min_length=1, max_length=30)
    age: int = Field(..., ge=0, le=50)
    notes: Optional[str] = Field(None, max_length=500)

class Pet(BaseModel):
    id: str
    name: str
    type: str
    age: int
    notes: Optional[str] = None
    created_at: datetime

class ErrorResponse(BaseModel):
    detail: str
    error_code: Optional[str] = None
