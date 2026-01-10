# API Keys Setup Guide

## Important Security Notice
**Your Google Maps API keys were previously exposed in the repository. Please:**
1. Rotate/regenerate your API keys in Google Cloud Console
2. Restrict the keys to your app's package name and bundle identifier
3. Set up API key restrictions (HTTP referrers, Android app restrictions, iOS app restrictions)

## Setup Instructions

### For Flutter/Dart Code (`.env.dart`)

1. Copy the example file:
   ```bash
   cp lib/.env.example.dart lib/.env.dart
   ```

2. Open `lib/.env.dart` and replace `YOUR_API_KEY_HERE` with your actual Google Maps API key:
   ```dart
   const String googleApiKey = 'YOUR_ACTUAL_API_KEY_HERE';
   ```

### For Android

1. Open `android/local.properties` (this file is gitignored)

2. Add your Google Maps API key:
   ```
   google.maps.api.key=YOUR_ANDROID_API_KEY_HERE
   ```

   If the file doesn't exist, create it with:
   ```
   sdk.dir=YOUR_SDK_PATH
   flutter.sdk=YOUR_FLUTTER_SDK_PATH
   google.maps.api.key=YOUR_ANDROID_API_KEY_HERE
   ```

### For iOS

1. Open `ios/Runner/Info.plist`

2. Find the `GoogleMapsApiKey` entry and replace `YOUR_IOS_GOOGLE_MAPS_API_KEY` with your actual iOS API key:
   ```xml
   <key>GoogleMapsApiKey</key>
   <string>YOUR_IOS_API_KEY_HERE</string>
   ```

## Files That Are Gitignored

The following files contain sensitive information and are excluded from version control:
- `lib/.env.dart` - Dart API key
- `android/local.properties` - Android API key and local configuration
- `*.key.properties` - Signing keys
- `*.keystore` - Keystore files

## Verifying Setup

After setting up your API keys:
1. Clean the project: `flutter clean`
2. Get dependencies: `flutter pub get`
3. Build and run the app to verify everything works

## Need Help?

If you encounter issues:
- Ensure all three locations (`.env.dart`, `local.properties`, `Info.plist`) have valid API keys
- Check that your API keys have the necessary permissions enabled in Google Cloud Console
- Verify API key restrictions match your app's package name/bundle ID

