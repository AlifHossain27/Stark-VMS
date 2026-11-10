# API Contract: Assignment 1 (Core Vehicle CRUD)

Base path: `/api`. All bodies are JSON (`Content-Type: application/json`).

> Adjust the vehicle fields to match your course's screens/spec. Keep this file and the code in sync.

## Vehicle object

| Field | Type | Rules |
|---|---|---|
| `id` | number | server-generated, read-only |
| `vehicleNumber` | string | required, 3-30 chars, trimmed, stored UPPERCASE, **unique** (case-insensitive) |
| `brand` | string | required, max 50 |
| `model` | string | required, max 50 |
| `manufactureYear` | number | required, 1980 to current year + 1 |
| `vehicleType` | string | required, e.g. CAR, VAN, TRUCK, BUS, MOTORCYCLE |
| `color` | string | optional, max 30 |
| `createdAt` | string (ISO-8601) | server-generated, read-only |
| `updatedAt` | string (ISO-8601) | server-generated, read-only |

## Endpoints

### GET /api/vehicles
List all vehicles (Assignment 2 adds search/filter/sort/pagination query params).
- **200**
```json
[
  {
    "id": 1,
    "vehicleNumber": "DHAKA-METRO-GA-11-2233",
    "brand": "Toyota",
    "model": "Hiace",
    "manufactureYear": 2019,
    "vehicleType": "VAN",
    "color": "White",
    "createdAt": "2026-11-09T12:00:00Z",
    "updatedAt": "2026-11-09T12:00:00Z"
  }
]
```

### GET /api/vehicles/{id}
- **200** vehicle object
- **404** not found

### POST /api/vehicles
Request body: vehicle fields (no `id`, `createdAt`, `updatedAt`).
```json
{
  "vehicleNumber": "dhaka-metro-ga-11-2233",
  "brand": "Toyota",
  "model": "Hiace",
  "manufactureYear": 2019,
  "vehicleType": "VAN",
  "color": "White"
}
```
- **201** created vehicle object (with `Location: /api/vehicles/{id}` header)
- **400** validation error
- **409** duplicate vehicle number

### PUT /api/vehicles/{id}
Full update, same body as POST.
- **200** updated vehicle object
- **400** validation error
- **404** not found
- **409** vehicle number already used by a *different* vehicle (updating a vehicle while keeping its own number must succeed)

### DELETE /api/vehicles/{id}
- **204** no content
- **404** not found

## Error shape (all errors)

```json
{
  "timestamp": "2026-11-09T12:00:00Z",
  "status": 409,
  "error": "Conflict",
  "message": "Vehicle number DHAKA-METRO-GA-11-2233 already exists",
  "fieldErrors": { "vehicleNumber": "already exists" }
}
```
For 400, `fieldErrors` maps each invalid field to a message. For 404/409 `fieldErrors` may be omitted or contain only the relevant field.

## CORS
Allowed origins come from env var `CORS_ALLOWED_ORIGINS` (comma-separated). Allow methods GET, POST, PUT, DELETE, OPTIONS.

## Acceptance criteria (Assignment 1)
1. List screen shows real DB rows; empty state shown when none.
2. Adding a vehicle persists it and it appears in the list after refresh.
3. Adding a duplicate vehicle number (any letter case, extra spaces) shows a clear error on the form.
4. Editing keeps data consistent; saving without changing the number does not trigger a duplicate error.
5. Deleting asks for confirmation, then removes the row from DB and UI.
6. No mock data remains in the frontend.
