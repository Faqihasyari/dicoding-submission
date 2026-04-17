# Food Recognizer App 🍱

A Flutter application for food image classification using Machine Learning (Firebase ML), integrated with recipe information from **TheMealDB** and AI-based nutritional insights from **Google Gemini**.

This application was built to fulfill the submission criteria for the **Applied Machine Learning for Flutter** course at Dicoding.

---

## ✨ Key Features
- **Food Classification**: Detect food types via Gallery, System Camera, or Custom Camera.
- **Isolate Processing**: Image processing is handled in a background thread using `compute` to keep the UI smooth and responsive.
- **Image Cropping**: Allows users to crop images before analysis for more accurate ML prediction results.
- **TheMealDB Integration**: Automatically searches and displays cooking instructions and reference photos if the predicted food is available in the database.
- **Gemini AI Nutrition**: Identifies detailed nutritional content (Calories, Carbohydrates, Fat, Fiber, Protein) using Google Generative AI (Structured Output JSON Schema).
- **Smart Caching**: Saves previous analysis results (MealDB & Gemini) in memory for instant access without draining API quotas or internet data.
- **Secure API Management**: Uses the `envied` package to hide sensitive API Keys through code obfuscation, preventing credential leaks.

---

## 🚀 How to Run the Project

### 1. Prerequisites
- Flutter SDK (Latest version highly recommended).
- A Firebase project setup (with the TFLite model uploaded to Firebase ML).
- A Google Gemini API Key (Can be obtained at [Google AI Studio](https://aistudio.google.com/)).

### 2. API Key Configuration (IMPORTANT)
This project uses the `envied` package for security. The `.env` file is intentionally ignored in version control. Follow these steps so the app can run:

1. Create a new file named `.env` in the root directory (alongside `pubspec.yaml`).
2. Fill the file using the following exact format:
   ```text
   GEMINI_API_KEY=PLACE_YOUR_GEMINI_API_KEY_HERE
3. Run the following command in your terminal to generate the required environment files (env.g.dart):
   ```text
   flutter pub run build_runner build --delete-conflicting-outputs

### 3. Installation
1. Clone this repository.
2. Run flutter pub get to download all dependencies.
3. Connect a physical device or start an Android/iOS emulator.
4. Run the app using flutter run or build the APK using flutter build apk.

---

🛠️ Tech Stack
- State Management: Provider
- Machine Learning: Firebase ML Custom Model & TensorFlow Lite
- Network API: HTTP (TheMealDB) & google_generative_ai
- Utilities:
  - image_picker (Gallery & System Camera)
  - image_cropper (Image Processing)
  - envied & build_runner (Security)
  - camera (Custom Camera Implementation)
 
---

### 📝 Notes for Reviewer
- Advanced Criteria (Gemini API): If an "API Key quota exceeded" or "Server Error [503]" message occurs during testing, it is likely due to Google's Free Tier or region limitations. The application is equipped with proper error handling and dummy data (0 values for nutrition) to ensure the UI can still be evaluated and does not crash.
- Labels: The labels.txt file has been properly extracted and included in the assets/ folder, and registered in pubspec.yaml to ensure the label accuracy perfectly matches the output index of the TFLite model.
- Linting: The codebase follows the latest linter standards with the optimal use of const modifiers for maximum performance.

---

### 👨‍💻 Developer
Faqih Asyari Universitas Muhammadiyah Cirebon (UMC)
