---
name: dotagents-skill-creator
description: Bootstrap a provider-neutral .agents/skills workspace and plugin projection with dry-run first.
---

# DotAgents Skill Creator

Use this skill to create or reconcile a local agent-skill workspace. Scan an
existing repository before writing, route new skills through the declared
creator contract, and default to simulation.

Procedure:

1. Preserve the raw request and derive a small manifest.
2. Inspect existing .agents/skills, plugins, .pmcro, and Git state.
3. Emit a dry-run plan; apply only with an explicit Apply flag.
4. Create SKILL.md, agents, scripts, references, assets, and tests.
5. Preserve unknown files and remove only recorded managed paths.
6. Run validators and report paths, hashes, status, and one unexecuted seed.

This skill never publishes, accesses credentials, or self-approves a generated
child. An independent checker is required before promotion.
