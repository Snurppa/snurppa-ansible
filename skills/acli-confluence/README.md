# acli-confluence (WIP)

Minimal skill for reading Confluence pages via `acli`.

## Sources

- `acli confluence ... --help` output of acli 1.3.39.
- No third-party Confluence skill was used as a source.

## Deliberately skipped

Scope is reading specs and docs for dev work. Left out on purpose:

- Blogs (`acli confluence blog ...`).
- Spaces (`acli confluence space ...`). Page IDs come from URLs, so space lookup is not needed.
- `auth switch`/`logout` and most `page view --include-*` flags.

## Status

WIP. Flags checked against `--help` only, nothing tested live. Page writes are not supported in acli 1.3.39.
