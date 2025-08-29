# 🐾 Pawzy - Pet Management Solution

A complete full-stack pet management application built with **Flutter** (mobile) and **FastAPI** (backend). Pawzy helps pet owners easily manage and track their furry friends with an intuitive, cross-platform mobile experience.

## 🎯 Features

### 🔐 Authentication
- **User Registration** with email validation and secure password hashing
- **User Login** with JWT token-based authentication  
- **Persistent login** - stays logged in across app restarts
- **Secure logout** with token cleanup

### 🐕 Pet Management
- **Add new pets** with name, type, age, and optional notes
- **View pet list** with detailed information and responsive cards
- **Pet type selection** from predefined list or custom type
- **Input validation** and error handling throughout
- **Real-time updates** with pull-to-refresh functionality

### 📱 Mobile App (Pawzy)
- **Flutter** with **GetX** state management
- **Cross-platform**: Android & iOS support
- **Professional branding**: Custom app icon and "Pawzy" branding
- **Responsive design**: Adapts to all screen sizes
- **Platform-aware networking**: Automatic API endpoint detection
- **JWT Authentication** with secure token storage

## 🛠 Tech Stack

### Frontend (Mobile)
- **Flutter** 3.8.1+ - Cross-platform mobile framework
- **GetX** 4.6.6 - State management and navigation
- **HTTP** 1.1.0 - API communication
- **SharedPreferences** 2.2.2 - Local storage for tokens

### Backend (API)
- **FastAPI** 0.104.1 - Modern Python web framework
- **MongoDB** with Motor - NoSQL database with async driver
- **JWT Authentication** - Secure token-based auth
- **BCrypt** - Password hashing
- **Pydantic** - Data validation and serialization
- **Python-dotenv** - Environment variable management
- **Comprehensive logging** - Request/response logging

## ⚡ Installation & Setup

### Prerequisites
- **Flutter SDK** 3.8.1+
- **Python** 3.8+
- **MongoDB** (local installation or Atlas cloud)
- **Android Studio** with emulator (for mobile testing)

### 🔧 Backend Setup

1. **Navigate to backend directory**
   ```bash
   cd backend
   ```

2. **Create and activate virtual environment**
   ```bash
   python3 -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install Python dependencies**
   ```bash
   pip install -r requirements.txt
   ```

4. **Configure environment variables**
   ```bash
   # Copy the example environment file
   cp .env.example .env
   
   # Edit .env with your configuration
   # Required: MONGODB_URL and SECRET_KEY
   ```

5. **Start MongoDB**
   ```bash
   # On macOS with Homebrew
   brew services start mongodb/brew/mongodb-community
   
   # On Linux
   sudo systemctl start mongod
   
   # On Windows
   net start MongoDB
   ```

6. **Run the FastAPI server**
   ```bash
   python main.py
   ```

   The API will be available at: `http://localhost:8000`
   
   📚 **API Documentation**: `http://localhost:8000/docs`
   🏥 **Health Check**: `http://localhost:8000/health`

### 📱 Mobile Setup

1. **Navigate to mobile directory**
   ```bash
   cd mobile
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Start Android emulator or connect physical device**
   ```bash
   flutter devices  # Check available devices
   ```

4. **Run the Flutter app**
   ```bash
   flutter run
   ```

## 🔌 API Endpoints

### System
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/health` | Health check endpoint |

### Authentication
| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/auth/register` | Register new user |
| `POST` | `/auth/login` | Login user |

### Pets (Protected Routes)
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/pets` | Get all user's pets |
| `POST` | `/pets` | Add new pet |

### Example API Usage
```bash
# Health check
curl -X GET "http://localhost:8000/health"

# Register a new user
curl -X POST "http://localhost:8000/auth/register" \
  -H "Content-Type: application/json" \
  -d '{"email": "user@example.com", "password": "securepass123"}'

# Login
curl -X POST "http://localhost:8000/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email": "user@example.com", "password": "securepass123"}'

# Get pets (with token)
curl -X GET "http://localhost:8000/pets" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"

# Add a new pet (with token)
curl -X POST "http://localhost:8000/pets" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{"name": "Buddy", "type": "Dog", "age": 3, "notes": "Golden Retriever"}'
```

## 🎬 Demo & Screenshots

### User Flow
1. **App Launch** → Shows splash screen while checking auth status
2. **Login/Register** → User authentication with validation
3. **Pet List** → View all pets with pull-to-refresh
4. **Add Pet** → Form with validation and success feedback

### Key Improvements Made
- ✅ **No overflow errors** - All screens properly responsive
- ✅ **Keyboard handling** - Gesture detector dismisses keyboard
- ✅ **Field navigation** - Tab key moves through form fields  
- ✅ **Success feedback** - Clear confirmation when pet is added
- ✅ **Proper navigation** - Auto-return to list after adding pet
- ✅ **Error handling** - Comprehensive validation and API error handling
- ✅ **Loading states** - Visual feedback during API calls

### Testing Checklist
- [ ] Register new user with invalid email → Shows validation error
- [ ] Login with wrong password → Shows authentication error  
- [ ] Add pet with empty name → Shows required field error
- [ ] Add pet with negative age → Shows validation error
- [ ] Successfully add pet → Shows success message and returns to list
- [ ] Pull down on pet list → Refreshes the list
- [ ] Tap outside form fields → Dismisses keyboard
- [ ] Use Tab key in forms → Moves to next field

## 📁 Project Structure

```
pawzy-pet-management/
├── backend/                    # FastAPI backend
│   ├── main.py                # Main FastAPI application
│   ├── config.py              # Configuration and environment variables
│   ├── models.py              # Pydantic data models
│   ├── database.py            # MongoDB connection and setup
│   ├── auth.py                # Authentication utilities (JWT, bcrypt)
│   ├── requirements.txt       # Python dependencies
│   ├── .env                   # Environment variables (not in git)
│   └── .env.example          # Example environment configuration
├── mobile/                     # Flutter mobile app
│   ├── lib/
│   │   ├── main.dart         # App entry point
│   │   ├── controllers/      # GetX controllers (auth, pet)
│   │   ├── models/           # Data models (Pet)
│   │   ├── screens/          # UI screens (login, pet list, add pet)
│   │   └── services/         # API service layer
│   ├── assets/
│   │   └── icon/             # App icons
│   ├── pubspec.yaml          # Flutter dependencies
│   └── android/ios/          # Platform-specific configurations
└── README.md                 # Main project documentation
```

### Backend Architecture Highlights
- **Modular structure** - Separated concerns into distinct modules
- **Configuration management** - Centralized environment variable handling
- **Security first** - No hardcoded secrets, proper JWT handling
- **Comprehensive logging** - Request/response logging throughout
- **Production ready** - Proper error handling and status codes

## 🔒 Security Features

- **Environment-based configuration** - All secrets in .env files
- **JWT Tokens** with configurable expiration
- **BCrypt password hashing** with automatic salt generation
- **Input validation** on both client and server with Pydantic
- **CORS middleware** properly configured for cross-origin requests
- **Email format validation** using Pydantic EmailStr
- **Protected API routes** requiring Bearer token authentication
- **Comprehensive logging** - All auth attempts and errors logged
- **Error handling** - No sensitive information leaked in error responses

## 🚀 Deployment Ready

The application is architected for production deployment:

### Backend Deployment
- **Environment variables** - Secure configuration management
- **Docker ready** - Can be containerized easily
- **Health checks** - `/health` endpoint for load balancer monitoring
- **Logging** - Structured logging for production monitoring
- **Error handling** - Proper HTTP status codes and error responses

### Database Configuration
- **MongoDB Atlas** (recommended for production)
- **Local MongoDB** (development setup)
- **Connection pooling** - Handled by Motor driver

### Environment Variables
Create `.env` file in backend directory:
```env
# Database
MONGODB_URL=mongodb://localhost:27017

# Security
SECRET_KEY=your-super-secure-secret-key-here-make-it-long-and-random
ACCESS_TOKEN_EXPIRE_MINUTES=30

# Optional
LOG_LEVEL=INFO
```

### Production Checklist
- [ ] Set strong `SECRET_KEY` (use `openssl rand -hex 32`)
- [ ] Configure MongoDB Atlas or secure MongoDB instance
- [ ] Set up HTTPS/TLS certificates
- [ ] Configure proper CORS origins (not `*`)
- [ ] Set up monitoring and logging aggregation
- [ ] Configure backup strategies for database
- [ ] Set up CI/CD pipeline for automated deployments