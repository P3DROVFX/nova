import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import qs.modules.common
import qs.modules.lock

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: window

            required property var modelData

            screen: modelData
            color: Theme.color.bgCanvas
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.namespace: "nova:desktop"
            WlrLayershell.layer: WlrLayer.Background
            WlrLayershell.keyboardFocus: DesktopState.searchActive ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.OnDemand

            anchors {
                top: true
                left: true
                right: true
                bottom: true
            }

            DesktopSurface {
                anchors.fill: parent
            }
        }
    }

    Connections {
        target: LockState

        function onLockedChanged() {
            DesktopState.revealed = !LockState.locked;
        }
    }

    GlobalShortcut {
        name: "searchToggleRelease"
        description: "Focuses the desktop search"
        onPressed: DesktopState.toggleSearch()
    }

    GlobalShortcut {
        name: "searchOnlyToggle"
        description: "Focuses the desktop search"
        onPressed: DesktopState.toggleSearch()
    }

    IpcHandler {
        target: "search"

        function toggle(): void {
            DesktopState.toggleSearch();
        }

        function open(): void {
            DesktopState.openSearch();
        }

        function close(): void {
            DesktopState.closeSearch();
        }
    }
}
