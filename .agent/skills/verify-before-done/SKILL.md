---
name: verify-before-done
description: Use at the end of every task, before saying a feature is done. Runs tests and a manual end-to-end check and reports honestly.
---

# Verify before claiming done

1. Backend: `cd backend && ./gradlew test`. Quote the pass/fail summary.
2. Frontend: `cd frontend && flutter analyze && flutter test`.
3. Start backend and frontend together and walk through the feature in the browser (list -> add -> duplicate attempt -> edit -> delete, or the relevant flow). Note exactly what you saw.
4. Confirm data is really in the database (H2 console or a GET call), and that no mock data is used.
5. Check the Definition of Done in `AGENTS.md`, item by item.
6. Final report format:
   - What changed (files)
   - Tests run + results (including failures or things not run)
   - What was manually verified
   - Known gaps / follow-ups
Never say "done" if something failed or was not run; say so plainly.
