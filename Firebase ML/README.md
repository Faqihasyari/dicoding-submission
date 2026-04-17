# House Price Predictor App 🏡

A Flutter application for estimating house prices using Machine Learning. It dynamically downloads models via **Firebase ML** and performs real-time, on-device inference using **LiteRT (TensorFlow Lite)**.

This application was built to fulfill the submission criteria for the **Applied Machine Learning for Flutter** course at Dicoding.

---

## ✨ Key Features
- **Dynamic Model Downloading**: Securely fetches the latest model (`House-Price-Predictor`) directly from Firebase ML Custom Models.
- **On-Device Inference**: Processes input data locally on the device using `tflite_flutter` for zero-latency predictions without requiring a backend server.
- **Interactive UI**: Clean, minimalist interface featuring custom counter controls (for Floors, Bedrooms, Bathrooms) and free-text input (for Square Feet Lot).
- **Reactive State Management**: Uses the `provider` package with a clean separation of concerns, isolating UI components from ML services and business logic.
- **Automated Tensor Formatting**: Automatically reshapes user input into a `[1, 4, 1]` tensor format to match the model's expected input shape.

---

## 🚀 How to Run the Project

### 1. Prerequisites
- Flutter SDK (Latest stable version recommended).
- A Firebase project setup (with the Machine Learning feature enabled).
- A trained TensorFlow Lite (`.tflite`) model for house price prediction.

### 2. Firebase & Model Configuration (IMPORTANT)
This project requires Firebase configuration to run successfully. Follow these steps:

1. **Setup Firebase Native Files:**
   - **Android:** Download `google-services.json` from your Firebase console and place it inside `android/app/`.
   - **iOS:** Download `GoogleService-Info.plist` and place it inside `ios/Runner/` using Xcode.
2. **Upload Custom Model:**
   - Go to your Firebase Console -> Machine Learning -> Custom Models.
   - Upload your `.tflite` model and name it exactly: `House-Price-Predictor`. (The app strictly looks for this exact string).

### 3. Installation
1. Clone this repository.
2. Run `flutter pub get` to download all necessary dependencies.
3. Connect a physical device or start an Android/iOS emulator.
4. Run the app using `flutter run` or build the APK using `flutter build apk`.

---

## 🛠️ Tech Stack
- **State Management**: Provider (`ChangeNotifier`, `MultiProvider`)
- **Machine Learning**: Firebase ML Custom Model Downloader & LiteRT (`tflite_flutter`)
- **Formatting**: `intl` (For currency formatting)
- **UI Components**: Custom widgets (`FormFieldCounter`, `FormFieldFreeNumber`)

---

### 📝 Notes for Reviewer
- **First Load Requirement**: The application requires an active internet connection upon the first launch to successfully download the ML model from Firebase. Subsequent inferences run completely offline.
- **Tensor Shapes**: The `LiteRtService` is hardcoded to expect an input tensor shape of `[1, 4, 1]` (Floors, Bedrooms, Bathrooms, SqftLot) and an output tensor shape of `[1, 1]`. If evaluating with a newly trained model, please ensure the model architecture matches these dimensions.
- **Dependency Injection**: The app utilizes `MultiProvider` at the root of `HomePage` to cleanly inject both the ML Services and the UI State Controllers, adhering to clean architecture principles.

---

### 👨‍💻 Developer
Faqih Asyari | Universitas Muhammadiyah Cirebon (UMC)
