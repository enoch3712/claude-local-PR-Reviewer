# Adding specs to the PR reviewer

Drop any `.md` file in this directory and it will be automatically injected into every PR review.

## Folder structure

```
.claude/skills/review-pr/
├── SKILL.md              # skill entry point (do not edit)
└── specs/
    ├── README.md         # this file
    ├── typescript.md     # your TypeScript rules
    ├── react.md          # your React rules
    └── security.md       # your security policy
```

## Example uses

- Language conventions (`typescript.md`, `python.md`)
- Framework rules (`react.md`, `django.md`)
- Architecture decisions (`api-design.md`, `data-layer.md`)
- Compliance requirements (`security-policy.md`, `gdpr.md`)

## Example file

Create `typescript.md`:

```md
## TypeScript standards

- No `any` — use `unknown` and narrow with type guards
- Explicit return types on all exported functions
- Every Promise must be awaited or `.catch()`-ed
```

That's it. The reviewer picks it up automatically on the next run.
