# LinkedIn Post

---

**"Reviews average $15–25"** — that's the price floating around for Anthropic's managed Code Review feature.

Per PR.

If your team ships 20 PRs a week, you're looking at $300–500/week just for automated reviews. That's before anyone has even read the code.

So we built the same thing locally.

**PR Pilot** — a Claude Code skill + a shell script that watches your GitHub repo 24/7 from your own machine:

→ New PR opens
→ Cron detects it (every 3 min)
→ Claude Code checks out the branch in an isolated worktree
→ Detects what changed — backend only? frontend only? both?
→ Starts only what's needed, runs Playwright via MCP if there's UI
→ Posts a structured review comment to the PR

No GitHub App. No cloud CI. No $25/review.

Just your machine, your API key, and Claude Code running in the background.

The whole thing is ~100 lines of bash + a skill file.

Open source 👇
https://github.com/enoch3712/claude-local-PR-Reviewer

---

*Built with Claude Code — skills, worktree isolation, and MCP tools.*
