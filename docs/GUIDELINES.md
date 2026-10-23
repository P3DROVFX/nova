# Guidelines

## Code

- English only, no unnecessary comments.
- One component per file, file name equals component name.
- Feature code composes widgets from `modules/common/widgets`; it does not style primitives.
- Colors, fonts, spacing and durations only via `Theme`. No hex literals outside `palettes/`.
- Animate only `opacity` and `transform`. Respect `Theme.motion.reduced`.
- Services are singletons without UI. UI never shells out directly; add a service.

## Adding a widget

1. Create `modules/common/widgets/NovaThing.qml`.
2. Expose behavior through properties and signals, no hardcoded content.
3. Implement all states: default, hover, pressed, focus, disabled.
4. Use the matching `Theme` tokens.
5. Add it to the widget list in `docs/ARCHITECTURE.md` if it introduces a new concept.

## Adding a palette

1. Copy `palettes/NovaDark.qml` to `palettes/YourPalette.qml` and change values.
2. Register it in `palettes/Palettes.qml`.
3. Select it with `appearance.palette` in `~/.config/nova/config.json`.

## Adding a service

1. Port or write `services/Thing.qml` as `pragma Singleton`.
2. Read options from `Config.options`, persisted state from `Persistent.states`.
3. Add default options to `Config.qml`.
4. Record the origin in `docs/PORTING.md` when ported.

## Testing without touching the live session

The daily shell must stay untouched. Run NOVA inside a headless Hyprland instance:

```bash
scripts/test-headless start
scripts/test-headless screenshot /tmp/nova.png
scripts/test-headless logs
scripts/test-headless stop
```

## Commits

Single short subject line, imperative, no body, no co-author trailers.
