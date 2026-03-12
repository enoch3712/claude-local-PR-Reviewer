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

---

Here's where it gets interesting.

Think of it like torrents.

Someone on a bigger Claude subscription runs PR Pilot on their machine — they're the seeder. Everyone else on the team just opens a PR into the watched repo. They don't need a subscription. They don't need to run anything. They just get the review back as a comment, like magic.

One person with a Pro account can cover an entire team. Or an open source maintainer can run it on a public repo and review contributions from anyone in the world — contributors just PR in and get feedback automatically.

The reviewer runs the compute. Everyone else just benefits.

---

The whole thing is ~100 lines of bash + a skill file.

Open source 👇
https://github.com/enoch3712/claude-local-PR-Reviewer

*Built with Claude Code — skills, worktree isolation, and MCP tools.*
