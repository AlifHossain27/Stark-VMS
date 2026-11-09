---
name: flutter-feature-structure
description: Use when building or changing Flutter Web screens, API client code, models, or state management in frontend/.
---

# Flutter feature structure

Folders under `frontend/lib/`: `models`, `services`, `providers`, `screens`, `widgets`.

For each feature:
1. **Model** (`models/`): plain Dart class with `fromJson`/`toJson`. Field names must match `docs/api-contract.md` exactly.
2. **API service** (`services/`): one class using the `http` (or `dio`) package. Base URL ONLY from `const String.fromEnvironment('API_BASE_URL')`. Throw a typed `ApiException` carrying the server's `message` and `fieldErrors`.
3. **State** (`providers/`): one approach project-wide (Riverpod or Provider). Expose loading / error / data.
4. **Screens** (`screens/`): every screen handles loading, error (with retry), and empty states.
5. **Forms**: client-side validation mirroring the backend rules, plus show server `fieldErrors` under the matching field (e.g. duplicate vehicle number).
6. **Destructive actions** (delete) need a confirmation dialog.
7. After create/edit/delete, refresh the list from the server; do not fake local state.
8. Never hard-code vehicle data or `localhost` URLs in code.
9. Add at least a widget test for the main list screen and form validation. Run `cd frontend && flutter analyze && flutter test`.

Flutter Web notes: CORS must be allowed on the backend; for file upload (Assignment 2) use `file_picker` and send bytes via multipart (web has no file paths).
