# Porting map from end4 dots-hyprland

Source: `~/.config/quickshell/dots-hyprland/dots/.config/quickshell/ii`.

## Removed on purpose

| Feature | Notes |
| --- | --- |
| matugen / MaterialThemeLoader / generated colors | Replaced by fixed palettes |
| Waffle panel family | Entire family |
| Sidebar policies, sidebar left and right, dashboard | Frontend dropped; backends kept (see below) |
| Bar | Replaced by desktop regions |
| Dock | Apps become desktop icons |
| Game overlay, game mode | Not needed |
| Cheatsheet | Dropped |
| Overview | Dropped |
| Wallpaper selector | Fixed wallpaper; structure allows switching later |
| Screen corners | The wallpaper frame replaces them |
| Screen translator | Dropped |
| Overlay | Dropped |
| On-screen display | Dropped |
| AI, Booru, Google Cloud, Latex, SongRec, Ydotool | Out of prototype scope |
| Translation system | English only |

## Frontend removed, backend kept

| Backend | Future NOVA frontend |
| --- | --- |
| `Network` | Wi-Fi list region on the desktop |
| `BluetoothStatus` | Bluetooth region |
| `Audio` | Volume region |
| `Brightness` | Brightness control |
| `Notifications` | Notification region |
| `MprisController` | Media region |
| `Battery`, `ResourceUsage`, `SystemInfo`, `DateTime` | Ambient telemetry text |
| `TrayService` | Tray region |
| `LauncherSearch`, `AppSearch`, `LauncherApps` | Desktop search and icons |
| `PolkitService` | Desktop auth dialog |
| `Idle` | Idle inhibit |

## Ported services

All core backend services are ported in `services/` and decoupled from `Translation`, `GlobalStates`, `Appearance` and `Hyprsunset`:

- `AppSearch`, `LauncherApps`, `LauncherSearch`
- `Audio`, `MprisController`
- `Battery`, `Brightness`, `Idle`, `ResourceUsage`, `SystemInfo`, `DateTime`
- `Network` (`network/WifiAccessPoint`), `BluetoothStatus`
- `Notifications`, `PolkitService`, `Privacy`, `TrayService`
- `HyprlandData`, `Wallpapers`

Tracked in [PROGRESS.md](PROGRESS.md).
