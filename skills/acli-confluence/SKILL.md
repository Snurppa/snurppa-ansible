---
name: acli-confluence
description: WIP. Read Confluence Cloud pages (specs, docs) through the Atlassian CLI (acli).
---

# acli - Confluence (WIP)

`acli confluence ...` talks to Confluence Cloud. In acli 1.3.39 pages are read-only: only `page view` exists.

When unsure about a flag, trust `acli confluence page view --help` over this document.

## Auth

Separate from Jira auth.

```bash
acli confluence auth status
acli confluence auth login --web
```

## Read a page

The page ID is in the page URL: `https://<site>.atlassian.net/wiki/spaces/<SPACE>/pages/<id>/<title>`.

```bash
acli confluence page view --id 123456 --body-format storage --json
acli confluence page view --id 123456 --include-direct-children --json   # navigate a page tree
```

`--body-format`: `storage` (XHTML, most complete), `atlas_doc_format` (ADF JSON), `view` (rendered HTML).

## TODO

- Revisit when page create/update land in acli
