---
description: Review the current changes like a strict code reviewer
---

Review the uncommitted changes (use `git diff`). Do NOT edit files. Check and report on:

1. Does it satisfy `docs/requirements.md` and `docs/api-contract.md`?
2. Backend: entities leaking from controllers, missing `@Valid`, logic in controllers, missing transactions, N+1 queries, wrong status codes, swallowed exceptions.
3. Frontend: hard-coded URLs or mock data, missing loading/error/empty states, unhandled API errors, state not refreshed after writes.
4. Security: secrets in code, over-permissive CORS, unvalidated uploads.
5. Tests: missing cases (validation, 404, 409), tests that don't assert anything.
6. Unrelated or unexplained changes and new dependencies.

Output a prioritised list: Must fix / Should fix / Nice to have, with file and line references.
