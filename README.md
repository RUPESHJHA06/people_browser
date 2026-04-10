# People Browser

A Flutter app for browsing people from the Random User API with search, pull-to-refresh, and a detail view.

## Current Features

- Splash screen before the main list
- Deterministic people fetch from `https://randomuser.me/api/`
- Client-side search by name
- Pull-to-refresh on the people list
- Loading, empty, loaded, and error states
- Person cards with avatar, name, email, and location
- Detail page with:
  - large profile photo
  - age
  - gender
  - email
  - phone
  - location
- Tap actions from the detail page for supported links
- Light and dark theme support

## Tech Stack

- Flutter
- Dart
- `flutter_bloc` for presentation state management
- `dio` for network requests
- `cached_network_image` for remote image loading
- `url_launcher` for external actions

## Project Structure

The app follows a clean layered structure:

- `lib/core`
  Shared constants, theme, and app-level exceptions
- `lib/data`
  API service, remote data source, models, and repository implementation
- `lib/domain`
  Entities, repository contracts, and use cases
- `lib/presentation`
  BLoC, pages, and widgets
- `test`
  Unit tests for BLoC logic and model parsing

## Architecture Notes

- UI reads state from a `PeopleBloc`
- BLoC handles loading, refresh, search, and error transitions
- Domain layer exposes use cases and repository contracts
- Data layer talks to Random User API and maps API models into app entities

## Getting Started

### Prerequisites

- Flutter SDK installed
- A connected emulator, simulator, or physical device

### Install Dependencies

```sh
flutter pub get
```

### Run the App

```sh
flutter run
```

## Quality Checks

### Analyze

```sh
flutter analyze
```

### Test

```sh
flutter test
```

## API

This project uses the public [Random User API](https://randomuser.me/).

## Possible Next Enhancements

- Favorites or saved people
- Sorting and filtering
- Offline caching
- Pagination
- More widget and integration tests
