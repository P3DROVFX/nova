# Architecture

## Layout

```
shell.qml                     entry point, loads services and the desktop
assets/
  fonts/                      bundled fonts
  wallpapers/default.png      fixed wallpaper
modules/
  common/
    Theme.qml                 semantic color, type, motion, metric tokens
    Config.qml                persisted user options (~/.config/nova/config.json)
    Persistent.qml            persisted runtime state (~/.local/state/nova)
    Directories.qml           all paths
    palettes/                 fixed color palettes + registry
    functions/                pure helpers
    widgets/                  every reusable visual element
  desktop/                    the single panel and its regions
services/                     backend singletons (ported from end4)
scripts/                      shell helpers and the shell switcher
docs/
```

## Single desktop panel

`modules/desktop/DesktopPanel.qml` creates one layer-shell window per screen on the background layer. Everything the user sees is a region inside it. Features never create their own windows. A region is a self-contained component that binds to services and uses only `common/widgets`.

Reasons: one surface makes cross-region animation trivial, avoids overlay/focus fighting, and matches the "everything is the desktop" model.

## Theme and palettes

`Theme` is a singleton that exposes semantic tokens (`Theme.color.bgCanvas`, `Theme.type.body`, `Theme.motion.fast`). Colors come from the active palette resolved by `Palettes` using `Config.options.appearance.palette`. Palettes are plain QML objects with identical properties, so adding a palette is adding one file and one registry line. Nothing outside `Theme` reads palette files.

Wallpaper path comes from `Config.options.background.wallpaperPath` (default: bundled asset), resolved by the `Wallpapers` service. Changing wallpaper later means changing that one option.

## Services

Ported from end4 with `Config`, `Persistent` and `Directories` pointed at NOVA's own storage, and `Translation` removed. Services never contain UI. They are loaded lazily by singleton access; `shell.qml` only touches those that need an explicit `load()`.

## Shortcuts and IPC

NOVA registers `GlobalShortcut`s with the same `quickshell` appid and names the daily shell uses where the feature maps one to one (for example `searchToggleRelease`), so existing Hyprland binds drive both shells without edits. NOVA-only shortcuts are additive. IPC targets are served by `qs -c nova ipc call <target> <function>`.

## Storage

| Path | Content |
| --- | --- |
| `~/.config/nova/config.json` | Options |
| `~/.local/state/nova/` | Persistent state, active shell marker |
| `~/.cache/nova/` | Caches |
