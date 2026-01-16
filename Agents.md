# AGENTS.md

## Project context
This is a Flutter Android application.
The project is already created using `flutter create`.

## Architecture rules (MANDATORY)
- Feature-Sliced Design (FSD)
- Clean Architecture
- Separation: presentation / domain / data
- BLoC for state management
- No business logic in UI widgets

## Code rules
- UI widgets are dumb (rendering + animations only)
- Business logic lives in use cases and blocs
- Repositories must be interfaces in domain
- Data layer implements repositories
- Firebase must NOT be referenced in domain or presentation

## Tech stack
- Flutter (Android only)
- flutter_bloc
- equatable

## Agent constraints
- Do NOT modify pubspec.yaml unless explicitly asked
- Do NOT introduce Firebase unless explicitly requested
- Do NOT shortcut architecture for simplicity
- Prefer clarity and maintainability over brevity
