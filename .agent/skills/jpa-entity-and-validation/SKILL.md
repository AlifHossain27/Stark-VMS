---
name: jpa-entity-and-validation
description: Use when creating or changing JPA entities, database constraints, relationships, or duplicate/uniqueness validation.
---

# JPA entities and validation

- Use `@Entity` with `@Id @GeneratedValue(strategy = GenerationType.IDENTITY)`.
- Uniqueness (e.g. vehicle number) is enforced in TWO places:
  1. Service check using `existsBy...IgnoreCase` (gives a friendly 409 message).
  2. A database `@Column(unique = true)` / unique index (protects against race conditions). Catch `DataIntegrityViolationException` and map it to the same 409.
- Normalise before saving: trim, and store vehicle numbers in uppercase.
- On update, exclude the current record from the duplicate check (`existsByVehicleNumberIgnoreCaseAndIdNot`).
- Enums (status, document type) use `@Enumerated(EnumType.STRING)`, never ordinal.
- Relationships (Assignment 2): Vehicle 1-N Maintenance, Vehicle 1-N VehicleDocument, Driver 1-N Vehicle (a vehicle has at most one current driver). Use `FetchType.LAZY`, and avoid N+1 queries on list endpoints (use `@EntityGraph` or fetch-join queries or DTO projections).
- Add `createdAt`/`updatedAt` using `@CreationTimestamp` / `@UpdateTimestamp` or JPA auditing.
- Schema: `ddl-auto=update` only in dev. For production/Render prefer Flyway migrations or `validate`.
