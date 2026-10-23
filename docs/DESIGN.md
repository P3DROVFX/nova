# NOVA Design Language

Source of truth: the early Figma export in [reference/](reference). The system was originally named ORCA; the name is now NOVA. The default wallpaper is the former "ORCA / Login" frame.

> Exposed machine. Precise signal. Intentional flicker.

## Principles

1. **Visible architecture.** Checker blocks, concave planes and negative space expose structure. Registration crosses (`+`) mark the corners of the visual field.
2. **Controlled signal and noise.** Monospace for system data, grotesque for user decisions. Peripheral text distributes technical information.
3. **Electric green is action.** `#C2FF3D` signals action, selection and progress, and nothing else.

Dense, not crowded. Rigid, not hostile. Technical, not cryptic.

## Contrast is hierarchy

Two visual registers:

- **Decorative grays** (`bg.raised`, `border.subtle`, `border.control`, `text.muted`) are for structural texture only: checker patterns, tonal planes, corner marks, ambient text that fades in peripheral reading.
- **Functional text** (labels, values, status) is always `text.primary` or `action.primary`.

Never use decorative grays for readable information. Never use off-white for background decoration.

## Palette tokens (`nova-dark`)

| Token | Hex | Use |
| --- | --- | --- |
| `bg.canvas` | `#101012` | Absolute background |
| `bg.surface` | `#19191C` | Concave plane / windows |
| `bg.raised` | `#222225` | Decorative checker / menus |
| `bg.hover` | `#292F28` | Neutral hover |
| `border.subtle` | `#2A2A2E` | Structural divisions |
| `border.control` | `#57575C` | Limits / corner marks / control borders |
| `text.primary` | `#F3F2ED` | Main reading |
| `text.secondary` | `#A6A6A8` | Support and metadata |
| `text.muted` | `#66666B` | Ambient / system labels |
| `action.primary` | `#C2FF3D` | Action, cursor, selection |
| `action.primary.hover` | `#D4FF5C` | Pointer over action |
| `action.primary.pressed` | `#A8DE30` | Confirmed press |
| `action.on-primary` | `#161B10` | Text over lime |
| `status.success` | `#8ED9AA` | Completed |
| `status.warning` | `#F2C66D` | Recoverable risk |
| `status.error` | `#FF8D85` | Failure / destruction |
| `status.info` | `#92C5F5` | Neutral context |

Destructive button: hover `#FFB1AA`, pressed `#DF726B`, text `#111608`.

Palettes are fixed files in `modules/common/palettes`. Switching palette swaps every token at once (the future replacement for matugen schemes).

## Typography

| Role | Font | Use |
| --- | --- | --- |
| Expressive | Architype Stedelijk W00 | Logo, big titles, key words, primary action labels |
| Content | IBM Plex Mono | All other text: body, subtitles, labels, data, inputs |

Scale (see `Theme.type`): `display`, `title`, `heading`, `body`, `label`, `mono`, `monoLarge`, `monoInput`. Uppercase is reserved for short identifiers, system labels and corner marks.

## Components

- **Buttons:** height 44, padding 16, gap 8, label 14. Primary (lime), secondary (outline), destructive (red). States: default, hover, pressed, focus (2 px off-white ring, 2 px offset), disabled (`bg.raised`, `text.muted`, `border.subtle`). One primary per group. Hover is never the only signal.
- **Authentication-scale button:** height 88, font 32, lime.
- **Text input:** label always visible, border-bottom for large fields, 1 px `border.control`, focus `action.primary`, cursor is a lime block.
- **Password mask:** checker pixel pattern, never glyphs.
- **Switch / checkbox / tabs:** active state uses lime; 44 px minimum hit area.
- **Surface:** tonal planes (`bg.surface` over `bg.canvas`) with negative space, offset planes (`bg.raised`), concave notched corners, `+` markers. No rounded borders.

## Motion

| Token | ms | Use |
| --- | --- | --- |
| `motion.instant` | 0 | Focus, selection, error |
| `motion.reduced` | 80 | Reduced-motion fade |
| `motion.fast` | 100 | Hover, pressed, switch, flicker |
| `motion.base` | 180 | Menus, tooltips, notifications |
| `motion.window` | 240 | Open and restore panels |
| `motion.reveal` | 320 | Reveal workspace |

Curves: `ease.enter = cubic-bezier(0.16, 1, 0.3, 1)`, `ease.exit = cubic-bezier(0.4, 0, 1, 1)`, `ease.standard = cubic-bezier(0.2, 0, 0, 1)`.

Rules:

- Animate only `opacity` and `transform`; never layout width/height.
- Ambient text flicker: low amplitude (10-15% opacity), at most 100 ms, local, at most one cycle. Never full-screen flashes or continuous tremor.
- Everything is interruptible; a new action resumes from the current position.
- Reduced motion replaces translation, scale and flicker with an instant swap or an 80 ms fade.

## Desktop model

The desktop is the only surface. Apps are desktop icons. Search is an element on the desktop. Network lists, volume, notifications and similar are desktop regions or panes revealed in place; they never open as layers above the desktop.
