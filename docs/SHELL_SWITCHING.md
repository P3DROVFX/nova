# Shell switching

NOVA runs side by side with the daily shell on disk (`~/.config/quickshell/nova` and `~/.config/quickshell/ii`), and only one runs at a time.

```bash
scripts/nova-switch nova
scripts/nova-switch ii
scripts/nova-switch toggle
scripts/nova-switch status
```

## What the script does

1. Stops the running `qs` instance (the shells are mutually exclusive: both own notifications, tray and layer surfaces).
2. Starts the target through the same launcher the Hyprland config uses (`qs-guard.sh` for `ii`, plain `qs -c nova` for NOVA), detached.
3. Updates `qsConfig` inside the running Hyprland with `hyprctl eval`, so existing keybinds that call `qs -c $qsConfig ipc call ...` follow the active shell.
4. Records the choice in `~/.local/state/nova/active-shell`.

## Keybinds

Existing `global("quickshell:...")` binds keep working for features NOVA implements under the same shortcut name. No existing bind is changed.

## Persisting across login

`hypr/custom/variables.lua` reads `~/.local/state/nova/active-shell` and sets `qsConfig` accordingly; deleting the file returns to `ii`.

## Safety

- The script refuses to run outside a Hyprland session.
- The default shell name is `ii`; override with `NOVA_DEFAULT_SHELL`.
