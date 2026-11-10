# Stark Group Vehicle Management System (VMS)

Monorepo for a course project: fleet/vehicle management.

## Stack
- `backend/`: Java 21, Spring Boot 4.1.2, Gradle, Spring Data JPA, Bean Validation. H2 for local dev, PostgreSQL in production (Neon).
- `frontend/`: Flutter Web (Dart). Deployed to Netlify.
- Communication: REST/JSON. The contract lives in `docs/api-contract.md` and is the single source of truth.

## Commands
- Backend run: `cd backend && ./gradlew bootRun` (port 8080)
- Backend test: `cd backend && ./gradlew test`
- Frontend run: `cd frontend && flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8080`
- Frontend test: `cd frontend && flutter test`
- Frontend build: `cd frontend && flutter build web --dart-define=API_BASE_URL=<url>`

## Working rules
1. Read `docs/requirements.md` and `docs/api-contract.md` before changing code. Read `docs/design-guidelines.md` before UI work.
2. Work in small vertical slices (one feature, backend -> frontend). Do not build the whole app at once.
3. If an endpoint changes, update `docs/api-contract.md` FIRST, then the backend, then the frontend.
4. Never return JPA entities from controllers. Use request/response DTOs.
5. No mock or hard-coded vehicle data. All data comes from the database through the API.
6. No secrets in git. Use environment variables (`DB_URL`, `DB_USER`, `DB_PASSWORD`, `CORS_ALLOWED_ORIGINS`).
7. Do not add dependencies without saying why.
8. Do not touch files unrelated to the current task.
9. A task is NOT done until tests were run and results reported honestly (including failures).
10. Prefer simple, readable code over clever code. Explain non-obvious decisions briefly.

## Backend conventions
- Packages: `controller`, `service`, `repository`, `entity`, `dto`, `exception`.
- Global error handling with `@RestControllerAdvice`, using the error shape in the API contract.
- Status codes: 200 read/update, 201 create, 204 delete, 400 validation, 404 not found, 409 conflict (duplicate).

## Frontend conventions
- Folders under `lib/`: `models`, `services` (API client), `providers` (state), `screens`, `widgets`.
- One state-management approach throughout (Riverpod or Provider).
- Every screen handles loading, error, and empty states.
- API base URL comes only from `String.fromEnvironment('API_BASE_URL')`.
- Follow docs/design-guidelines.md. Use only tokens from lib/theme/; never hard-code colors, font sizes or spacing in widgets.

## Definition of done (per feature)
- [ ] Contract updated
- [ ] Backend implemented + tests passing
- [ ] Frontend implemented + works against the real backend
- [ ] Manually verified in the browser
- [ ] Committed with a clear message
