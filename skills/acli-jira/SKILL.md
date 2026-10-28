---
name: acli-jira
description: Jira via Atlassian CLI (acli). Ticket/issue lifecycle (start work, create subtasks, comment, transition), JQL search, formatted descriptions and comments. Use when Jira issue ticker (e.g. PROJ-123) comes up.
---

# acli - Jira workflows

`acli jira ...` talks to Jira Cloud. Jira issues are called **work items** in the CLI (`acli jira workitem ...`).

When unsure about a flag, trust `acli jira workitem <subcommand> --help` over this document. The CLI changes between versions.

## Fundamentals

```bash
acli --version
acli jira auth status          # check first when anything fails with auth errors
acli jira auth login --web     # authenticate (OAuth)
acli jira auth switch          # switch between accounts
```

Rules that apply to nearly every command:

- `view` takes the key positionally: `acli jira workitem view PROJ-123`
- Almost everything else needs `--key`: `comment list`, `comment create`, `transition`, `edit`, `assign`, ...
- Bulk: edit, transition, assign and comment create accept comma-separated `--key "PROJ-1,PROJ-2"`, or `--jql "<query>"` instead of `--key`. `--yes` skips the confirmation prompt. Bulk changes are hard to undo, so confirm the target list with a search first.
- Output: `--json` for parsing. `--csv` (search) is a compact alternative for listing many items.
- Use long flags. Short flags mean different things in different subcommands (e.g. `-f` is `--fields` in search but `--from-file` in delete).

## Basic workflows

### Start work on an item

1. Read it: `acli jira workitem view PROJ-123 --fields "summary,status,assignee,description,comment"`
2. Assign: `acli jira workitem assign --key PROJ-123 --assignee "@me"`
3. Move to in-progress: `acli jira workitem transition --key PROJ-123 --status "In Progress"`. Status names vary per project. On error, see [Transitions](#transitions).
4. Optional: branch named after the key, e.g. `git switch -c PROJ-123-short-summary`.

### Reconcile tickets with code

1. List open items: `acli jira workitem search --jql "assignee = currentUser() AND resolution = Unresolved" --fields "key,status,summary"`
2. For each, search history: `git log --oneline --grep="<KEY>"`
3. Check whether those commits are released: `git tag --contains <sha>`.
4. Comment and/or transition accordingly.

## Search (JQL)

```bash
acli jira workitem search --jql "project = PROJ AND assignee = currentUser() AND resolution = Unresolved"
acli jira workitem search --jql "project = PROJ" --fields "key,status,summary" --limit 20 --json
acli jira workitem search --jql "project = PROJ" --paginate     # fetch all pages
acli jira workitem search --jql "project = PROJ" --count
```

JQL tips:

- Use single quotes for values with spaces inside a double-quoted shell string: `status = 'In Progress'`
- Prefer `NOT status = 'Done'` over `!=`. Escaping `!=` through the shell has caused trouble.
- Functions: `currentUser()`, `now()`, `startOfDay()`, `endOfWeek()`, `openSprints()`
- `statusCategory = Done` / `'In Progress'` is more portable than concrete status names across projects
- `~` is "contains" (text search): `summary ~ "CVE-2024-1234"`, `text ~ "terms"` (all text fields)

Common patterns:

```sql
assignee = currentUser() AND sprint in openSprints() AND resolution = Unresolved
project = PROJ AND updated >= -7d ORDER BY updated DESC
project = PROJ AND component = 'my-component'
text ~ "search terms" AND statusCategory = Done AND resolved >= -30d
```

Duplicate check before creating: search by `summary ~` / `text ~` and exclude the current key with `AND NOT key = PROJ-123`.

## View

Default to plain text. It is compact (ADF flattened to readable lines, empty fields omitted), roughly 10x smaller than `--json` for the same fields.

```bash
acli jira workitem view PROJ-123 --fields "summary,status,assignee"                       # quick check
acli jira workitem view PROJ-123 --fields "summary,status,assignee,description,comment"   # full context to work on it
```

Use `--json` only when needed: raw ADF (editing a description while keeping its formatting) or custom fields. Large payloads go to a file, then query with jq:

```bash
acli jira workitem view PROJ-123 --fields "*all" --json > /tmp/PROJ-123.json
jq '.fields.description' /tmp/PROJ-123.json        # raw ADF
```

Many items: one search instead of one `view` per item:

```bash
acli jira workitem search --jql "key in (PROJ-1, PROJ-2)" --fields "key,summary,status,assignee" --csv
```

Paths: `.fields.summary`, `.fields.status.name`, `.fields.assignee.displayName`, `.fields.comment.comments`.

`--fields` values: `*all`, `*navigable`, `-fieldname` (exclude). Default: `key,issuetype,summary,status,assignee,description`.

## Rich text: always use ADF

Descriptions and comments are stored as ADF (Atlassian Document Format, JSON). Markdown and wiki markup are NOT rendered, they show up as literal characters. Plain strings lose all structure, and `\n` does not create paragraph breaks.

Rules of thumb:

- Write ADF to a JSON file and pass the file. Inline JSON breaks easily under shell quoting.
- Root is always `{"type": "doc", "version": 1, "content": [...]}`
- Get a template: `acli jira workitem create --generate-json`, `acli jira workitem edit --generate-json`
- Reliable nodes: `paragraph`, `heading` (`attrs.level` 1-6), `bulletList`, `orderedList` (both contain `listItem` > `paragraph`), `codeBlock` (`attrs.language`)
- Text marks: `strong`, `em`, `code`, `link` (`attrs.href`)
- If the result renders wrong in Jira, simplify to paragraphs, lists and plain code blocks.

Minimal building blocks:

```json
{"type": "paragraph", "content": [{"type": "text", "text": "Plain text"}]}
```

```json
{"type": "heading", "attrs": {"level": 2}, "content": [{"type": "text", "text": "Title"}]}
```

```json
{"type": "paragraph", "content": [
  {"type": "text", "text": "Use "},
  {"type": "text", "text": "FLAG", "marks": [{"type": "code"}]},
  {"type": "text", "text": " and see "},
  {"type": "text", "text": "docs", "marks": [{"type": "link", "attrs": {"href": "https://example.com"}}]}
]}
```

```json
{"type": "bulletList", "content": [
  {"type": "listItem", "content": [{"type": "paragraph", "content": [{"type": "text", "text": "Item"}]}]}
]}
```

```json
{"type": "codeBlock", "attrs": {"language": "bash"}, "content": [{"type": "text", "text": "echo hi"}]}
```

## Create

Formatted description via JSON (`assignee`, `labels`, `parentIssueId` and `additionalAttributes` optional). `--generate-json` shows the full template.

```json
{
  "projectKey": "PROJ",
  "type": "Task",
  "summary": "Title",
  "assignee": "user@example.com",
  "labels": ["triage"],
  "parentIssueId": "10100",
  "additionalAttributes": {"customfield_10001": 50, "customfield_10000": {"value": "Option"}},
  "description": {
    "type": "doc",
    "version": 1,
    "content": [
      {"type": "paragraph", "content": [{"type": "text", "text": "Description"}]}
    ]
  }
}
```

`parentIssueId` is the parent for sub-tasks. `additionalAttributes` sets custom field values.

```bash
acli jira workitem create --from-json workitem.json
```

Plain text only (quick, no formatting). Labels use `--label` (singular, comma-separated) here, unlike `edit`:

```bash
acli jira workitem create --project PROJ --type Bug --summary "Title" --description "Plain text" --label "triage"
acli jira workitem create --project PROJ --type Sub-task --summary "Child" --parent PROJ-100
```

## Edit and assign

```bash
acli jira workitem edit --key PROJ-123 --summary "New title"
acli jira workitem edit --key PROJ-123 --labels "bug,urgent"
acli jira workitem edit --key PROJ-123 --remove-labels "wontfix"
acli jira workitem assign --key PROJ-123 --assignee "@me"       # or an email
```

Formatted description on an existing item: write a JSON file with an `issues` array and an ADF `description`, then `acli jira workitem edit --from-json workitem.json --yes`:

```json
{"issues": ["PROJ-123"], "description": {"type": "doc", "version": 1, "content": [ ... ]}}
```

## Comments

```bash
acli jira workitem comment create --key PROJ-123 --body-file comment.json   # ADF file
acli jira workitem comment create --key PROJ-123 --body "Quick plain text"
acli jira workitem comment create --key PROJ-123 --edit-last --body-file comment.json   # replace your last comment
acli jira workitem comment list --key PROJ-123 --json
acli jira workitem comment update --key PROJ-123 --id 10001 --body-adf comment.json
```

Gotchas:

- `comment update --body-file` is plain text only. Use `--body-adf` for ADF.
- `comment list` flattens bodies to plain text and drops list items. To read the raw ADF use `acli jira workitem view PROJ-123 --fields comment --json`.

## Transitions

```bash
acli jira workitem transition --key PROJ-123 --status "In Progress"
acli jira workitem transition --key "PROJ-1,PROJ-2" --status "Done" --yes
```

- Valid target statuses depend on the project workflow and the current status. A transition error usually means "not reachable from current status", so view the item's status and try an intermediate step.
- Current status: `acli jira workitem view PROJ-123 --fields status --json`

## Links

`--type` accepts the outward description of the link type. List available types with `link type`.

```bash
acli jira workitem link create --out PROJ-1 --in PROJ-2 --type "Blocks" --yes
acli jira workitem link list --key PROJ-1 --json
acli jira workitem link type --json
acli jira workitem link delete --id LINK_ID --yes      # link ID from link list --json
```

## Troubleshooting

- Auth errors: `acli jira auth status`, then ask the user to run `acli jira auth login --web` (browser, interactive)
- Observed with API token auth, cause unknown: `auth login --token` returns `✗ Error: authentication failed`, and an existing token session failed `auth status` and every JQL search (`failed to parse JQL`) while `view` worked. `--web` login fixed both.
- Unknown command or flag: `acli jira workitem --help`, `acli jira workitem <sub> --help`
- JQL errors: check quotes and escaping first, then test the query with `--count`
- Output looks wrong in Jira: check ADF validity (root `doc`, `version: 1`) and fall back to simpler nodes
- Outdated acli can lack flags mentioned here: `acli --version`
