# Quotely (graduation_project_nti)

Quotely is a Flutter app for discovering inspirational quotes, saving favorites, organizing them into collections, and viewing a daily quote with Android home-screen widget support.

## Overview

This project uses:
- `Flutter` for UI
- `flutter_bloc` for state management
- `Firebase Auth` for authentication
- `Cloud Firestore` for user profiles, favorites, and collections
- `Dio` + API Ninjas Quotes API for quotes data
- `SharedPreferences` for daily quote caching and widget sync

## Main Features

- Email/password authentication (login, signup, password reset)
- Home feed with categories and refresh
- Search by quote text or author + category filter
- Favorite/unfavorite quotes
- Create/delete collections and add/remove quotes from collections
- Daily quote screen with local cache fallback
- Share quotes via system share sheet
- Android home widget for daily quote

## Architecture Summary

The app follows a feature-first structure with Cubit per feature:

- `lib/features/auth`: login/signup/auth gate
- `lib/features/home`: home quotes and categories
- `lib/features/search`: search/filter flow
- `lib/features/favorites`: favorites + collections
- `lib/features/daily_quote`: quote of the day logic + caching
- `lib/features/profile`: profile editing + logout
- `lib/core/data`: data sources and models
- `lib/core/widgets`: reusable UI widgets

Data flow pattern (typical):
1. `View` dispatches action to `Cubit`
2. `Cubit` calls data source
3. Data source calls remote API / Firebase
4. `Cubit` emits states (`Loading`, `Success`, `Failure`)
5. `View` rebuilds based on state

## Project Structure

```text
lib/
  core/
    data/
      datasources/
      models/
    services/
    widgets/
  features/
    auth/
    daily_quote/
    favorites/
    home/
    main_screen/
    profile/
    search/
  firebase_options.dart
  main.dart
```

## Prerequisites

- Flutter SDK (matching Dart `^3.10.7`)
- Android Studio or VS Code with Flutter tooling
- Firebase project configured for this app

## Environment Variables

Create a `.env` file in the project root:

```env
QUOTES_API_KEY=YOUR_API_NINJAS_KEY
```

The app reads this key in `QuotesRemoteDataSource` using `flutter_dotenv`.

## Firebase Setup

This repo already contains Firebase integration files (`firebase_options.dart`, `android/app/google-services.json`).

If you connect to a different Firebase project:
1. Reconfigure with FlutterFire CLI.
2. Regenerate `lib/firebase_options.dart`.
3. Replace platform Firebase config files.

Expected Firestore paths:
- `profiles/{uid}`
- `profiles/{uid}/favorites/{quoteId}`
- `profiles/{uid}/collections/{collectionId}`

## Run the App

```bash
flutter pub get
flutter run
```

## Android Daily Quote Widget

Widget integration is implemented in:
- `android/app/src/main/kotlin/.../MainActivity.kt`
- `android/app/src/main/kotlin/.../DailyQuoteWidgetProvider.kt`
- `android/app/src/main/res/layout/daily_quote_widget.xml`

The widget content is synced from Flutter through a `MethodChannel` named:
- `daily_quote_widget`

## Known Notes

- `.env` is currently tracked in the repository and contains a real API key. This should be treated as exposed.
- Recommended immediate actions:
  1. Rotate/revoke the current API key.
  2. Remove `.env` from version control.
  3. Add `.env` to `.gitignore`.
  4. Use a safe `.env.example` template instead.

## Suggested Next Improvements

- Add repository layer/interfaces between Cubits and data sources
- Add unit tests for Cubits and data sources
- Add widget tests for critical views
- Improve error typing and centralized failure handling
- Add CI checks (`flutter analyze`, `flutter test`)

## License

Private graduation project.
