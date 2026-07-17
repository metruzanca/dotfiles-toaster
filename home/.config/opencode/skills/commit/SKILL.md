---
name: commit
description: Use when the user says "commit", "commit changes", or wants to save current work to git. Commits using conventional commits and pushes when done.
---

Please commit the current changes using conventional commits.

1. Check `git status` and `git diff` to understand what changed.
2. Group related changes into separate commits if it makes the history clearer. Each commit should have a clear, single purpose.
3. Use conventional commit format: `type(scope): description`
   - Types: `feat`, `fix`, `docs`, `style`, `refactor`, `chore`, `test`
   - Scope is optional but preferred
4. Push all commits when done.
