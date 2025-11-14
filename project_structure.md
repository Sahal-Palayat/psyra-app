# Flutter Project Structure (MVC + BLoC + GoRouter)

This document defines a clean, production-ready folder structure for a Flutter project using **MVC pattern**, **BLoC for state management**, and **GoRouter for navigation** — optimized for simplicity and maintainability.

---

## Root Files

```plaintext
lib/
│
├── main.dart                  # Application entry point. Initializes DI and runs the app.
├── app.dart                   # Root widget (MaterialApp.router). Sets up theme and global providers.
│
├── constants/
│   ├── app_constants.dart      # General limits, titles, animation durations
│   ├── api_constants.dart      # Base URLs, endpoints, headers
│   └── route_names.dart        # (Can replace core/navigation/route_paths.dart)
│
├── core/                      # CORE: Shared foundational code used across modules.
│   │
│   ├── common_blocs/          # Global state BLoCs (e.g., AuthBloc, ThemeBloc).
│   │
│   ├── common_models/         # Models shared by multiple modules (e.g., User, GenericResponse).
│   │
│   ├── common_widgets/        # Reusable UI components (e.g., PrimaryButton, CustomTextField).
│   │
│   ├── di/                    # Dependency Injection setup (e.g., get_it registration).
│   │
│   ├── exceptions/            # Custom global exception classes (e.g., NetworkException).
│   │
│   ├── navigation/            # Global routing configuration.
│   │   ├── app_router.dart        # Main GoRouter instance (imports module routes).
│   │   └── route_paths.dart       # Static string constants for route names/paths.
│   │
│   ├── services/              # Core services (3rd-party wrappers, storage, network).
│   │   ├── api_client.dart        # HTTP client (Dio/Http wrapper).
│   │   └── local_storage_service.dart
│   │
│   ├── theme/                 # Design system.
│   │   ├── app_theme.dart         # ThemeData configuration.
│   │   └── color_schemes.dart     # Light/Dark mode colors.
│   │
│   └── utils/                 # Helper functions, extensions, and constants.
│       ├── helper_functions.dart
│       └── string_extensions.dart
│
└── modules/                   # MODULES: Independent functional areas (features)
    │
    ├── login/                  # [MODULE 1]: Authentication Module
    │   │
    │   ├── controller/        # CONTROLLER (BLoC)
    │   │   └── login_bloc/
    │   │       ├── login_bloc.dart
    │   │       ├── login_event.dart
    │   │       └── login_state.dart
    │   │
    │   ├── model/             # MODEL (Data Models and Services)
    │   │   ├── models/
    │   │   │   └── login_request.dart
    │   │   └── services/
    │   │       └── auth_api_service.dart
    │   │
    │   ├── view/              # VIEW (UI Pages and Widgets)
    │   │   ├── pages/
    │   │   │   └── login_page.dart
    │   │   └── widgets/
    │   │       └── login_form.dart
    │   │
    │   └── routing/           # Module-specific Routes
    │       └── auth_routes.dart
    │
    └── home/                  # [MODULE 2]: Home Module
        │
        ├── controller/        # CONTROLLER (BLoC)
        │   └── dashboard_bloc/
        │       ├── dashboard_bloc.dart
        │       ├── dashboard_event.dart
        │       └── dashboard_state.dart
        │
        ├── model/             # MODEL (Data Models and Services)
        │   ├── models/
        │   │   └── feed_item.dart
        │   └── services/
        │       └── home_feed_service.dart
        │
        ├── view/              # VIEW (UI Pages and Widgets)
        │   ├── pages/
        │   │   └── home_page.dart
        │   └── widgets/
        │       └── feed_card.dart
        │
        └── routing/           # Module-specific Routes
            └── home_routes.dart
```