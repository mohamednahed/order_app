# 📦 Order Manager

A modern Flutter application for managing customer orders with Firebase integration, user authentication, and a clean responsive UI.

---

## 📱 Overview

**Order Manager** is a cross-platform mobile application developed using **Flutter**. It enables users to register, log in, browse products, manage shopping carts, place orders, and track order history.

The application follows clean coding practices and uses **Provider** for state management along with **Firebase** services for authentication and cloud database management.

---

# ✨ Features

- 🔐 User Authentication
  - Register
  - Login
  - Forgot Password
  - Remember Me

- 👤 User Profile

- 🛒 Shopping Cart Management

- 📦 Place Orders

- 📜 Order History

- ❤️ Clean & Responsive UI

- 🚀 Splash Screen

- 👋 Onboarding Screens

- ☁️ Firebase Integration

- 💾 Local Storage using SharedPreferences

---

# 🛠️ Technologies Used

| Technology | Purpose |
|------------|---------|
| Flutter | Cross-platform app development |
| Dart | Programming language |
| Firebase Authentication | User authentication |
| Cloud Firestore | Cloud database |
| Provider | State Management |
| SharedPreferences | Local Storage |
| Material Design | UI Components |

---

# 📂 Project Structure

```
lib/
│
├── models/
│   ├── user.dart
│   ├── product.dart
│   └── order.dart
│
├── providers/
│   ├── auth_provider.dart
│   ├── cart_provider.dart
│   ├── orders_provider.dart
│   └── product_provider.dart
│
├── screens/
│   ├── splash_screen.dart
│   ├── onboarding_screen.dart
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── forget_password.dart
│   ├── home_screen.dart
│   └── orders_screen.dart
│
├── services/
│
├── widgets/
│
├── utils/
│
├── firebase_options.dart
│
└── main.dart
```

---

# 📸 Screens

- Splash Screen
- Onboarding
- Login
- Register
- Home
- Product List
- Shopping Cart
- Orders
- Profile

---

# 🚀 Getting Started

## Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio / VS Code
- Firebase Project

---

## Installation

Clone the repository

```bash
git clone https://github.com/your-username/order-manager.git
```

Go to project folder

```bash
cd order-manager
```

Install dependencies

```bash
flutter pub get
```

Run the application

```bash
flutter run
```

---

# 🔥 Firebase Setup

1. Create a Firebase project.
2. Enable **Authentication**.
3. Enable **Cloud Firestore**.
4. Download the Firebase configuration files.
5. Run:

```bash
flutterfire configure
```

---

# 📦 Packages

```yaml
provider
firebase_core
firebase_auth
cloud_firestore
shared_preferences
```

---

# 🧠 State Management

This project uses **Provider** to manage application state.

Main providers include:

- AuthProvider
- ProductProvider
- CartProvider
- OrdersProvider

---

# 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- ✅ Web (Optional)

---

# 🔒 Authentication Flow

```
Splash Screen
      │
      ▼
Onboarding
      │
      ▼
Login / Register
      │
      ▼
Home Screen
      │
      ├── Products
      ├── Cart
      ├── Orders
      └── Profile
```

---

# 📖 Application Workflow

1. User opens the application.
2. Splash screen is displayed.
3. First-time users see the onboarding pages.
4. User registers or logs in.
5. Products are displayed.
6. User adds items to the cart.
7. User places an order.
8. Orders are stored in Firebase.
9. User can review previous orders.

---

# 🏗️ Architecture

The application follows a simple layered architecture:

```
Presentation Layer
        │
        ▼
Provider Layer
        │
        ▼
Firebase Services
        │
        ▼
Cloud Firestore
```

---

# 🎯 Future Improvements

- Payment Gateway
- Push Notifications
- Order Tracking
- Dark Mode
- Product Search
- Wishlist
- Admin Dashboard
- Product Categories
- Reviews & Ratings

---

# 👨‍💻 Developed With

- Flutter
- Firebase
- Provider
- Material Design

---

# 📄 License

This project is developed for educational purposes and university coursework.

---

# ⭐ If you like this project

Give it a ⭐ on GitHub!

---

## 📧 Contact

For questions or suggestions, feel free to open an issue or submit a pull request.

---

**Made with ❤️ using Flutter**
