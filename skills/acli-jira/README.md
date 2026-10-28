# acli-jira

Synthesized skill for working with Jira Cloud via the Atlassian CLI (`acli`).

## Sources

Merged and reorganized from:

1. Previous local `jira-cli` skill, from [znorris/claude-marketplace](https://github.com/znorris/claude-marketplace) (`plugins/atlassian-tools/skills/jira-cli`). Contributed: bulk/JQL flags, edit flags, JQL tips, common flags, review workflow.
2. [nmoinvaz/speedy-gonzales `skills/acli`](https://raw.githubusercontent.com/nmoinvaz/speedy-gonzales/refs/heads/main/skills/acli/SKILL.md). Contributed: `--key` vs positional rule, "always ADF via file", `comment update --body-adf`, raw ADF via `view --json`, create/edit via `--from-json`, JQL examples.
3. [luigiinred/dotfiles `working-with-jira-acli`](https://raw.githubusercontent.com/luigiinred/dotfiles/refs/heads/main/dot_cursor/skills/working-with-jira-acli/SKILL.md). Contributed: auth commands, `assign`, ADF block examples.

## Deliberately skipped

Scope is core agentic dev work (find, read, create, update, comment, link, transition tickets). Niche features are left out on purpose:

- Claude Code-specific `allowed-tools` frontmatter and the `` !`acli --version` `` dynamic injection (not portable across skill CLIs).
- Long ADF examples (nested lists, full multi-section ticket, ADF node table). Replaced by compact building blocks plus `--generate-json`.
- Custom field create/delete (`acli jira field ...`). Rare, admin-only.
- Saved filters (`acli jira filter ...`, `--filter <id>`). JQL covers it.
- Watchers, attachments, `clone`, `archive`/`unarchive`, `delete`, `create-bulk`.
- Boards, sprints, projects commands. JQL `sprint in openSprints()` covers "my sprint work" without board/sprint IDs.
- `comment create --editor` (interactive), `comment delete`, `edit --type`, `--remove-assignee`, `assign default`, `reporter`, extra edit-JSON fields.
- `--web` output (opens a browser, useless for agents) and most bulk `--jql` examples. Bulk is mentioned once in Fundamentals.
- Short flags, on purpose. They are inconsistent across subcommands, so the skill uses long flags only.
- The luigiinred `--link-type/--outward-key` link syntax, which is outdated. The skill uses `--out/--in/--type`, verified on acli 1.3.39.
- Shell error-handling script template and the generic "acli not in PATH" troubleshooting.
- Project-specific examples (e.g. `RETIRE` project, Android FLAG_SECURE ticket).
- Comment `--body` inline ADF JSON. File based is more robust against shell quoting.

## Known uncertainties

- Sources disagree on whether acli supports ADF headings and text marks. The skill says they work and tells the agent to simplify if rendering fails. Verify on your acli version.
- Flags checked against `acli --help` of acli 1.3.39. Read paths (`view` text/JSON, `search --csv`, `auth status`) tested live with OAuth (`--web`). API token auth failed for unknown reasons (`auth login --token` → `authentication failed`; old token session failed JQL search and `auth status`). Writes not tested.
- `comment list` dropping list items (from speedy-gonzales) not verified.

## Installing

Point a skill CLI at this repo, e.g. `skillshare install <this-repo>` and pick `acli-jira`.
