# PR Review Standards

Edit this file to match your project's conventions.
The `/review-pr` skill reads this automatically.

---

## Always flag

- Hardcoded secrets, API keys, or credentials in any file
- Missing `await` on async calls
- SQL or command built by string concatenation (injection risk)
- Unhandled promise rejections or bare `except: pass`
- N+1 query patterns (DB call inside a loop)
- New dependencies added without clear justification
- Breaking changes to public API response shapes

## Security checklist

- New API endpoints must require authentication
- Admin-only routes must verify admin status before executing
- No sensitive data in logs or error messages

## Skip / ignore

- Whitespace-only or formatting changes
- Auto-generated files
- Lock file changes unless packages actually changed

## Severity prefixes

- `[BUG]` — incorrect behaviour, will break at runtime
- `[SECURITY]` — potential vulnerability
- `[PATTERN]` — violates a project convention
- `[NIT]` — minor style issue, non-blocking
