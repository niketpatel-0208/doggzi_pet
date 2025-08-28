# Backend - Doggzi Pet API

FastAPI backend service for the Doggzi Pet Management application.

## 🚀 Quick Start

1. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

2. **Start MongoDB:**
   ```bash
   brew services start mongodb/brew/mongodb-community
   ```

3. **Run the server:**
   ```bash
   python main.py
   ```

Server runs on: `http://localhost:8000`

## 📋 API Documentation

### Authentication

**POST /auth/register**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**POST /auth/login**
```json
{
  "email": "user@example.com", 
  "password": "password123"
}
```

### Pet Management

**GET /pets** (Requires Authentication)
- Headers: `Authorization: Bearer <token>`

**POST /pets** (Requires Authentication)
```json
{
  "name": "Buddy",
  "type": "Dog", 
  "age": 3,
  "notes": "Golden Retriever"
}
```

## 🔧 Configuration

- **Database**: MongoDB (localhost:27017)
- **JWT Secret**: Production-ready secret key
- **Token Expiry**: 30 minutes
- **CORS**: Enabled for all origins (configure for production)

## 📦 Dependencies

- fastapi==0.104.1
- uvicorn==0.24.0
- pymongo==4.6.0
- python-jose[cryptography]==3.3.0
- passlib[bcrypt]==1.7.4
- motor==3.3.2
- pydantic==2.5.0
- email-validator

## 🛡️ Security Features

- Password hashing with bcrypt
- JWT token authentication
- Email validation
- Input sanitization
- Comprehensive error handling

## 📊 Database Schema

### Users Collection
```json
{
  "_id": "ObjectId",
  "email": "string",
  "password": "hashed_string",
  "created_at": "datetime"
}
```

### Pets Collection
```json
{
  "_id": "ObjectId",
  "name": "string",
  "type": "string", 
  "age": "integer",
  "notes": "string",
  "owner_id": "string",
  "created_at": "datetime"
}
```
