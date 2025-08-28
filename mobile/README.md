# doggzi_assignment

# 📱 Doggzi Mobile App

A Flutter mobile application for pet management with GetX state management and JWT authentication.

## 🎯 Features

- **User Authentication** (Login/Register)
- **Pet Management** (Add, List, View pets)
- **Responsive Design** - Works on all screen sizes
- **Keyboard Navigation** - Tab through form fields
- **Gesture Support** - Tap to dismiss keyboard
- **Real-time Validation** - Form validation with user feedback
- **Success/Error Handling** - Clear feedback for all actions
- **Token Persistence** - Stay logged in across app restarts

## 🛠 Tech Stack

- **Flutter** 3.8.1+
- **GetX** 4.6.6 - State management & navigation
- **HTTP** 1.1.0 - API communication
- **SharedPreferences** 2.2.2 - Local storage

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.8.1 or higher
- Android Studio with Android SDK
- Android Emulator or physical device

### Installation

1. **Install dependencies**
   ```bash
   flutter pub get
   ```

2. **Verify Flutter installation**
   ```bash
   flutter doctor
   ```

3. **Start Android emulator or connect device**
   ```bash
   flutter devices
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 📱 App Structure

```
lib/
├── main.dart                   # App entry point & routing
├── controllers/
│   ├── auth_controller.dart    # Authentication state management
│   └── pet_controller.dart     # Pet management state
├── models/
│   ├── user.dart              # User data model
│   └── pet.dart               # Pet data model  
├── screens/
│   ├── login_screen.dart      # Login/Register UI
│   ├── pet_list_screen.dart   # Pet list with refresh
│   └── add_pet_screen.dart    # Add new pet form
└── services/
    └── api_service.dart       # HTTP API client
```

## 🔌 API Integration

The app communicates with the FastAPI backend running on:
- **Development**: `http://10.0.2.2:8000` (Android emulator)
- **Local Testing**: `http://localhost:8000`

### API Endpoints Used
- `POST /auth/register` - User registration
- `POST /auth/login` - User authentication
- `GET /pets` - Fetch user's pets
- `POST /pets` - Add new pet

## 🎨 UI/UX Features

### Responsive Design
- Adapts to different screen sizes using `MediaQuery`
- Flexible layouts with percentage-based sizing
- Keyboard-aware scrolling and padding

### User Experience
- **Loading States**: Visual feedback during API calls
- **Error Handling**: User-friendly error messages
- **Success Feedback**: Confirmation for successful actions
- **Form Validation**: Real-time input validation
- **Navigation**: Smooth transitions between screens

### Accessibility
- Proper focus management for keyboard navigation
- Screen reader friendly with semantic widgets
- High contrast colors and readable fonts

## 🔧 Configuration

### Network Configuration
Update the base URL in `lib/services/api_service.dart`:
```dart
static const String baseUrl = 'http://10.0.2.2:8000'; // For Android emulator
// static const String baseUrl = 'http://localhost:8000'; // For iOS simulator
```

### Android Permissions
The app requires internet permission (already configured in `android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.INTERNET" />
```

## 🧪 Testing

### Manual Testing Checklist
- [ ] Register new user with validation
- [ ] Login with correct/incorrect credentials
- [ ] Add pet with all field validations
- [ ] View pet list with pull-to-refresh
- [ ] Test keyboard navigation in forms
- [ ] Test responsive design on different screen sizes
- [ ] Verify offline error handling

### Running Tests
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/
```

## 📱 Build & Release

### Debug Build
```bash
flutter run --debug
```

### Release Build
```bash
flutter build apk --release
# APK will be in: build/app/outputs/flutter-apk/app-release.apk
```

### App Bundle (for Google Play)
```bash
flutter build appbundle --release
```

## 🔒 Security Features

- JWT token storage using SharedPreferences
- Automatic token cleanup on logout
- Input validation to prevent injection attacks
- Secure API communication over HTTPS (in production)

## 📝 State Management with GetX

### Controllers
- **AuthController**: Manages authentication state, login/logout
- **PetController**: Handles pet CRUD operations and state

### Reactive Programming
```dart
// Example of reactive state updates
Obx(() => _controller.isLoading.value 
    ? CircularProgressIndicator() 
    : SubmitButton())
```

## 🐛 Common Issues & Solutions

### Issue: Network Error on Android Emulator
**Solution**: Use `10.0.2.2` instead of `localhost` for API calls

### Issue: Keyboard Overflow
**Solution**: Wrap forms in `SingleChildScrollView` with keyboard padding

### Issue: State Not Updating
**Solution**: Ensure controllers are properly initialized with `Get.put()`


---

Built with Flutter 💙 and GetX for optimal performance
