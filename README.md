# 🐾 Doggzi Pet Management App

A complete full-stack pet management application built with **Flutter** (mobile) and **FastAPI** (backend). Pawzy helps pet owners easily manage and track their furry friends with an intuitive, cross-platform mobile experience.

## 🎯 Features

### 🔐 Authentication
- **User Registration** with email validation and secure password hashing
- **User Login** with JWT token-based authentication  
- **Persistent login** - stays logged in across app restarts
- **Secure logout** with token cleanup

### � Pawzy - Full-Stack Pet Management Solution
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

## � Tech Stack

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

## � Installation & Setup

### Prerequisites
- **Flutter SDK** 3.8.1+
- **Python** 3.8+
- **MongoDB** (local installation)
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

4. **Start MongoDB**
   ```bash
   # On macOS with Homebrew
   brew services start mongodb/brew/mongodb-community
   
   # On Linux
   sudo systemctl start mongod
   
   # On Windows
   net start MongoDB
   ```

5. **Run the FastAPI server**
   ```bash
   python main.py
   ```

   The API will be available at: `http://localhost:8000`
   
   📚 **API Documentation**: `http://localhost:8000/docs`

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

## � API Endpoints

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
# Register a new user
curl -X POST "http://localhost:8000/auth/register" 
  -H "Content-Type: application/json" 
  -d '{"email": "user@example.com", "password": "securepass123"}'

# Login
curl -X POST "http://localhost:8000/auth/login" 
  -H "Content-Type: application/json" 
  -d '{"email": "user@example.com", "password": "securepass123"}'

# Get pets (with token)
curl -X GET "http://localhost:8000/pets" 
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
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
doggzi_assign/
├── backend/                    # FastAPI backend
│   ├── main.py                # Main application file
│   ├── requirements.txt       # Python dependencies
│   └── README.md             # Backend documentation
├── mobile/                     # Flutter mobile app
│   ├── lib/
│   │   ├── main.dart         # App entry point
│   │   ├── controllers/      # GetX controllers
│   │   ├── models/           # Data models
│   │   ├── screens/          # UI screens
│   │   └── services/         # API service
│   ├── pubspec.yaml          # Flutter dependencies
│   └── README.md             # Mobile app documentation
└── README.md                 # Main project documentation
```

## 🔒 Security Features

- **JWT Tokens** with expiration (30 minutes)
- **BCrypt password hashing** with salt
- **Input validation** on both client and server
- **CORS middleware** configured for security
- **Email format validation** using regex patterns
- **Protected API routes** requiring authentication

## 🚀 Deployment Ready

The application is structured for easy deployment:

### Backend Deployment Options
- **AWS Lambda** with Serverless Framework
- **Docker** containerization ready
- **Heroku** with Procfile
- **DigitalOcean** App Platform

### Database Options  
- **MongoDB Atlas** (cloud) - recommended for production
- **Local MongoDB** - current setup for development

### Environment Variables
Create `.env` files for production:
```env
# Backend
MONGODB_URL=mongodb+srv://user:pass@cluster.mongodb.net/doggzi_db
SECRET_KEY=your-super-secure-secret-key
ACCESS_TOKEN_EXPIRE_MINUTES=30
```