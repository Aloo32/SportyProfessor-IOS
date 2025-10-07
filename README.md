# SportyProfessor

iOS app for learning sports through gamified lessons.

## Requirements

- Xcode 16.0+
- iOS 17.0+ simulator or device
- macOS Ventura or later

## Setup Instructions

### 1. Clone the Repository
```bash
git clone https://github.com/Aloo32/SportyProfessor-IOS.git
cd SportyProfessor-IOS
```

### 2. Open in Xcode
```bash
open SportyProfessor-IOS.xcodeproj
```

### 3. Set Up Firebase (Required)
** The app will crash without this configuration**

Create your own Firebase project:

1. Go to [console.firebase.google.com](https://console.firebase.google.com)
2. Click "Create Project" and follow the setup
3. Once created, click "Add app" → iOS
4. Register app with Bundle ID: `com.Alejandrob.SportyProfessor-IOS`
5. Download `GoogleService-Info.plist`
6. Drag the file into Xcode:
   - Drop it in the `SportyProfessor-IOS` folder
   - Check "Copy items if needed"
   - Add to target: SportyProfessor-IOS

### 4. Enable Authentication
In Firebase Console:
1. Go to Authentication → Get Started
2. Sign-in Methods tab → Enable:
   - Email/Password
   - Google (add support email when prompted)

### 5. Build and Run
1. Select iPhone simulator (iPhone 15 recommended)
2. Press `Cmd + R`

## Troubleshooting

### "No such module 'FirebaseCore'" error
- File → Packages → Resolve Package Versions
- Wait for packages to download

### App crashes on launch
- You're missing `GoogleService-Info.plist` (see Step 3)
- Ensure the file is added to the project target

### "Unable to find module dependency" errors
- In Xcode: Project → Package Dependencies
- Remove and re-add packages if needed:
  - Firebase: `https://github.com/firebase/firebase-ios-sdk`
  - Google Sign-In: `https://github.com/google/GoogleSignIn-iOS`
  - Click on the SportyProfessor-IOS Project-> Then SportyProfessor-IOS (the one under targets)
    -> Scroll down to "Frameworks,Libraries,and Embedded content" -> add "FirebaseAuth","FirebaseFirestore","GoogleSignIn","GoogleSignInSwift"

### Build fails with Info.plist errors
- Clean build folder: `Shift + Cmd + K`
- Delete derived data: `~/Library/Developer/Xcode/DerivedData`
- Rebuild

## Features

- Google Sign-In authentication
- Email/Password authentication
- Tab navigation (Home, Practice, Social, Profile)

---
© 2025 Alejandro Barajas. All rights reserved.
