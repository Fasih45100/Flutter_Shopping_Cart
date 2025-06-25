# 🛒 Shopping Cart Flutter App

A sleek and functional Flutter shopping cart app built for learning, testing, and showcasing e-commerce UI logic and functionality. The app supports cart management, product listing, state management, local database storage, and persistent data using `shared_preferences` and `sqflite`.

## ✨ Features

- 🛍️ Add to cart and remove items
- 🧮 Real-time cart badge updates
- 💾 Persistent storage with SQLite (`sqflite`)
- 💡 Local caching with `shared_preferences`
- 🔄 State management using `Provider`
- 📱 Responsive and user-friendly UI
- 🖼️ Asset management for product images

## 📸 Screenshots

| Home Page | Cart Page | Empty Cart |
|-----------|-----------|-------------|
| ![home](images/screenshots/home.png) | ![cart](images/screenshots/cart.png) | ![empty](images/empty_cart.jpg) |


## 🛠️ Tech Stack

Flutter – Cross-platform UI toolkit
Dart – Programming language for Flutter
Provider – Simple and efficient state management
SQLite (sqflite) – Local database for storing cart items
Shared Preferences – Lightweight key-value storage
Badges – To show cart item count in real-time

## 📦 Dependencies

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  shared_preferences: ^2.5.3
  path_provider: ^2.1.5
  sqflite: ^2.4.2
  badges: ^3.1.2
  provider: ^6.1.5

  ## 💡 Customization Tips
  
  Add Products: Modify or extend the product list in your model or data file.
Change UI Theme: Tweak colors and styles inside ThemeData in main.dart.
Persistent Cart: Customize the sqflite integration to suit your database schema.
App Branding: Update app icons and name using flutter_launcher_icons or manually via Android/iOS config files.

## 🙌 Acknowledgements

Thanks to the Flutter and Dart teams for amazing documentation and open-source support.
Icons and assets inspired by public domain and educational sources.

## 📄 License

This project is licensed under the MIT License.
See the LICENSE file for more information.

## 🚀 Getting Started

Follow these instructions to get a local copy of the app up and running
git clone https://github.com/your-username/shoping_cartf.git
cd shoping_cartf
flutter pub get
flutter run

## 💼 Created by Fasih

Contact me if you're looking for a Flutter developer or want to collaborate!
💬 Feel free to ⭐ this repo or fork it to build your own version!
