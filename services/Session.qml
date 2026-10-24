pragma Singleton

import QtQuick
import Quickshell

Singleton {
    function lock(): void {
        Quickshell.execDetached(["loginctl", "lock-session"]);
    }

    function suspend(): void {
        Quickshell.execDetached(["bash", "-c", "systemctl suspend || loginctl suspend"]);
    }

    function logout(): void {
        Quickshell.execDetached(["pkill", "-i", "Hyprland"]);
    }

    function reboot(): void {
        Quickshell.execDetached(["bash", "-c", "systemctl reboot || loginctl reboot"]);
    }

    function poweroff(): void {
        Quickshell.execDetached(["bash", "-c", "systemctl poweroff || loginctl poweroff"]);
    }
}
