---
name: api-contract-sync
description: Use before any change that touches request/response shapes, endpoints, or error formats, to keep backend, frontend, and docs/api-contract.md consistent.
---

# Keeping the contract in sync

1. `docs/api-contract.md` is the source of truth. Change it first, in the same commit as the code.
2. After backend changes, check every DTO field name, type and nullability against the contract.
3. After frontend changes, check every model's `fromJson`/`toJson` against the contract.
4. Verify against the RUNNING backend, not just assumptions: call the endpoint with `curl` and compare the actual JSON to the contract. Paste the real response into your report.
5. If code and contract disagree, stop and ask which one is right instead of silently picking.
6. Report a short list: "contract updated / backend matches / frontend matches".
