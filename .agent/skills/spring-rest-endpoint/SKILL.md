---
name: spring-rest-endpoint
description: Use when adding or changing a REST endpoint in the Spring Boot backend (controller, service, repository, DTOs, tests).
---

# Adding or changing a REST endpoint

1. Open `docs/api-contract.md`. If the endpoint is new or changed, update the contract FIRST and show me the diff.
2. Create/adjust DTOs in `dto/`: separate request and response classes (Java records are fine). Put Jakarta validation annotations (`@NotBlank`, `@Size`, `@Min`, ...) on request DTOs.
3. Entity changes go in `entity/`. Never return an entity from a controller.
4. Repository: Spring Data JPA interface in `repository/`. Add derived queries (e.g. `existsByVehicleNumberIgnoreCase`) instead of hand-written SQL when possible.
5. Service: all business rules live here (duplicate checks, status rules, mapping DTO <-> entity). Mark write methods `@Transactional`.
6. Controller: thin. Only `@Valid @RequestBody`, call the service, return `ResponseEntity` with the correct status.
7. Errors: throw custom exceptions (`NotFoundException`, `DuplicateResourceException`); the `@RestControllerAdvice` maps them to the error shape in the contract.
8. Tests: add a service unit test and a `@WebMvcTest`/MockMvc (or `@SpringBootTest`) test covering success, validation failure, 404 and 409.
9. Run `cd backend && ./gradlew test`. Report the real result, including failures.

Status codes: 200 read/update, 201 create (+ Location header), 204 delete, 400 validation, 404 not found, 409 duplicate.
