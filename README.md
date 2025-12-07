# nanas_mobile

A new [Flutter](https://flutter.dev/) project bootstrapped with the `flutter create` command.

## Getting Started

### Prerequisites

Make sure you have the following installed:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Dart SDK](https://dart.dev/get-dart) (included with Flutter)
- Android Studio / VS Code (with Flutter & Dart extensions)
- For Android:
  - Android SDK & Emulator / Physical Android Device
- For iOS (macOS only):
  - Xcode
  - iOS Simulator / Physical iOS Device

You can verify your setup with:

```bash
flutter doctor
Installation
Clone this repository and install dependencies:

bash
Copy code
git clone <YOUR_REPO_URL>.git
cd nanas_mobile
flutter pub get
If you need a fresh build, you can clean first:

bash
Copy code
flutter clean
flutter pub get
Running the App
1. Run in Debug Mode (Default Device)
bash
Copy code
flutter run
Flutter will detect a connected device (emulator or physical).

2. Run on a Specific Device
List available devices:

bash
Copy code
flutter devices
Then run, for example:

bash
Copy code
# Android emulator / device
flutter run -d android

# iOS simulator (macOS only)
flutter run -d ios

# Web (Chrome)
flutter run -d chrome
Build for Release
Android (APK)
bash
Copy code
# Build a release APK
flutter build apk --release
The APK will be available at:

text
Copy code
build/app/outputs/flutter-apk/app-release.apk
Android (App Bundle – for Play Store)
bash
Copy code
flutter build appbundle --release
The AAB file will be available at:

text
Copy code
build/app/outputs/bundle/release/app-release.aab
iOS (macOS only)
bash
Copy code
flutter build ios --release
Then, open the iOS project in Xcode for signing and App Store deployment.

Project Structure
Basic Flutter project structure:

text
Copy code
nanas_mobile/
├── android/      # Native Android project
├── ios/          # Native iOS project
├── lib/          # Main Dart source code
├── test/         # Unit & widget tests
├── web/          # Web support (if enabled)
├── pubspec.yaml  # Dependencies & metadata
└── README.md     # Project documentation
Your main entry point is:

text
Copy code
lib/main.dart
Useful Commands
bash
Copy code
# Analyze code
flutter analyze

# Run tests
flutter test

# Format Dart code
dart format lib test
