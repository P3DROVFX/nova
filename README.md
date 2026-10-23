# NOVA

A visual-prototype Quickshell shell for Hyprland. Everything lives on the desktop, in a single panel: no bar, dock, sidebars or overlays.

NOVA reuses the proven backend of [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland) (services for audio, network, bluetooth, notifications, media, brightness, launcher search, ...) and replaces the entire frontend with its own design language.

## Quick start

```bash
qs -c nova
```

Switch between this shell and the daily shell without touching your normal setup:

```bash
scripts/nova-switch nova
scripts/nova-switch ii
scripts/nova-switch toggle
```

See [docs/SHELL_SWITCHING.md](docs/SHELL_SWITCHING.md).

## Documentation

| Doc | Purpose |
| --- | --- |
| [docs/DESIGN.md](docs/DESIGN.md) | Design language, tokens, typography, motion |
| [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) | Folder layout, singletons, how the desktop panel works |
| [docs/GUIDELINES.md](docs/GUIDELINES.md) | Coding rules and how to add widgets, services, palettes |
| [docs/PORTING.md](docs/PORTING.md) | What was ported from end4, what was dropped and why |
| [docs/SHELL_SWITCHING.md](docs/SHELL_SWITCHING.md) | Running NOVA next to another shell |
| [docs/PROGRESS.md](docs/PROGRESS.md) | Roadmap and current status |

## Licensing notes

- `assets/fonts/IBMPlexMono-*` is SIL OFL 1.1 (license included).
- `assets/fonts/ArchitypeStedelijkW00.ttf` is a commercial font; do not publish this repository publicly with it included.
- Backend code derived from end4's dots-hyprland keeps its original license (GPL-3.0).
