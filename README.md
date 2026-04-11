# People Browser

A Flutter app for browsing deterministic user profiles from the Random User API with fast search, sorting, favorites, pull-to-refresh, detail actions, and light or dark theming.

People Browser is intentionally compact, but it is built with production-minded structure instead of demo-only shortcuts. The app uses `flutter_bloc`, layered architecture, deterministic API data, and a presentation layer split into focused widgets that are easier to test and evolve.

## Highlights

- deterministic dataset powered by Random User seed-based fetching
- responsive search, sort, favorites, refresh, and detail flows
- light, dark, and system theme support
- layered Flutter architecture with focused presentation widgets
- tested BLoC state transitions for key interactions

## Preview

<p align="center">
  <img src="docs/images/home-light.png" alt="Home screen light mode" width="240" />
  <img src="docs/images/home-dark.png" alt="Home screen dark mode" width="240" />
  <img src="docs/images/menu-drawer.png" alt="Menu drawer" width="240" />
</p>

<p align="center">
  <img src="docs/images/searching.png" alt="Search results view" width="240" />
  <img src="docs/images/favorite-sreen.png" alt="Favorites filtered view" width="240" />
  <img src="docs/images/profile-screen.png" alt="Profile screen" width="240" />
</p>

## What It Does

- fetches a stable list of people from `https://randomuser.me/api/`
- shows polished loading, empty, loaded, and error states
- supports debounced client-side search by full name
- supports pull-to-refresh and manual retry on failure
- supports ascending and descending name sorting
- supports favorites from both the list and detail screens
- supports filtering the list to favorite people only
- opens a detail page with age, gender, email, phone, and location
- launches email, phone, and map actions from the detail screen
- supports light, dark, and system theme modes

## Why This Project Is Useful

This codebase works well as a compact reference for:

- layered Flutter architecture
- `flutter_bloc` state management
- mapping remote JSON into domain entities
- handling UI state transitions cleanly
- building a small app with production-minded structure

## Architecture

The main data flow is:

```text
UI -> PeopleBloc -> GetPeople / GetVisiblePeople -> PeopleRepository -> PeopleRemoteDataSource -> UserService -> Random User API
```

Layer responsibilities:

- `presentation`: pages, widgets, bloc, cubit, and UI state transitions
- `domain`: entities, repository contracts, and use cases
- `data`: API calls, DTO/model mapping, datasource, and repository implementation
- `core`: shared constants, theme setup, and app exceptions

Recent presentation split:

- `PeoplePage` owns the scaffold shell
- `PeopleSearchSection` owns search input and debounce handling
- `PeopleContent` owns loading, empty, error, and list rendering
- `PeopleMenuDrawer` owns theme, sort, refresh, and about actions
- `PeopleFavoritesToggleButton` owns the app-bar favorites filter affordance

## Product Notes

### Data Fetching

- uses the public Random User API
- requests `30` users per load
- uses a fixed seed of `people-browser`
- limits nationalities to `us,gb,ca,au`

The fixed seed keeps the dataset stable enough for development, screenshots, and test assertions.

### Search And Sort

- search runs locally on the fetched dataset
- search input is debounced for smoother interaction
- sorting supports `name ascending` and `name descending`
- favorites can be toggled without leaving the list
- favorites-only mode can be toggled from the app bar or drawer

### Error Handling

- server responses with status codes are converted into user-facing error messages
- network-like failures surface a retry message
- retry is currently manual by design

## Project Structure

```text
lib/
  core/
    constants/
    errors/
    theme/
  data/
    datasources/
    models/
    repositories/
    services/
  domain/
    entities/
    repositories/
    usecases/
  presentation/
    bloc/
    pages/
    widgets/
test/
  people_bloc_test.dart
  user_model_test.dart
docs/
  images/
```

## Tech Stack

- Flutter
- Dart
- `flutter_bloc`
- `dio`
- `cached_network_image`
- `url_launcher`

## Getting Started

### Prerequisites

- Flutter SDK
- a simulator, emulator, browser, or physical device

### Install Dependencies

```sh
flutter pub get
```

### Run The App

```sh
flutter run
```

### Run On A Specific Device

```sh
flutter devices
flutter run -d <device-id>
```

## Quality Checks

Analyze the project:

```sh
flutter analyze
```

Run tests:

```sh
flutter test
```

## Test Coverage

Current coverage includes:

- BLoC state transitions for loading, error, search, sort, and favorites
- API model parsing into app models

Current gaps:

- widget tests for main page states
- repository tests for Dio error translation
- integration tests for full app navigation flow

## Design And Implementation Notes

### Why `flutter_bloc`

The app has explicit event-driven transitions like load, refresh, retry, search, and sort. `flutter_bloc` keeps those transitions testable and easy to reason about.

### Why A Fixed API Seed

Without a fixed seed, the API would return a different result set frequently, which makes screenshots, UI verification, and tests noisier than necessary.

### Why Client-Side Search

The fetched dataset is intentionally small, so client-side filtering keeps the implementation simple and responsive.

## What’s Next

Planned improvements:

- add local persistence for favorites and theme mode
- cache the last successful people payload for faster reopen
- sharpen loading, offline, and API error feedback
- extend test coverage with widget and integration flows
- explore pagination or staged loading for larger datasets

## API

This project uses the public [Random User API](https://randomuser.me/).
