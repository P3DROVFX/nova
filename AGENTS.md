# AGENTS.md

Instructions for any AI agent working on NOVA.

## What this project is

NOVA is a Quickshell shell for Hyprland. One desktop panel hosts everything. The backend (services) is ported from end4's dots-hyprland; the frontend is a new design system. Read [docs/DESIGN.md](docs/DESIGN.md) and [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) before changing UI code.

## Hard rules

- English only: code, docs, commit messages, UI strings.
- No unnecessary comments in code. Name things well instead.
- Commits: short subject line only, no body, no `Co-authored-by` trailers.
- Everything is modular. Every visual element must be a reusable widget in `modules/common/widgets` instantiated by feature modules. Never style raw `Rectangle`/`Text` in feature code when a widget exists or should exist.
- No sidebar, dock, bar, overlay, cheatsheet, wallpaper selector, screen corners or any floating layer. Everything is drawn inside the single desktop panel.
- No matugen and no dynamic colors. Colors come only from fixed palettes through the `Theme` singleton.
- Never read or write `~/.config/illogical-impulse`. NOVA state lives in `~/.config/nova`, `~/.local/state/nova` and `~/.cache/nova`.
- Do not disturb the user's daily shell (`ii`). Test NOVA in a headless Hyprland instance (see [docs/GUIDELINES.md](docs/GUIDELINES.md)) instead of killing the live session.

## Workflow

1. One item at a time.
2. Verify by loading the shell in the headless test compositor and grabbing a screenshot.
3. Commit after each item.
4. Update [docs/PROGRESS.md](docs/PROGRESS.md) when an item is finished.
