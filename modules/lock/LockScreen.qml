import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Services.Pam
import qs.modules.common
import qs.services

Scope {
    id: root

    LockContext {
        id: lockContext
        onAuthRequested: pam.start()
        onAuthenticated: action => root.perform(action)
    }

    PamContext {
        id: pam

        onPamMessage: {
            if (responseRequired)
                respond(lockContext.currentText);
        }

        onCompleted: result => {
            if (result === PamResult.Success)
                lockContext.authSucceeded();
            else
                lockContext.authFailed();
        }
    }

    function perform(action) {
        if (action === "poweroff")
            Session.poweroff();
        else if (action === "reboot")
            Session.reboot();
    }

    function completeUnlock() {
        LockState.unlock();
        lockContext.reset();
    }

    WlSessionLock {
        locked: LockState.locked

        WlSessionLockSurface {
            color: Theme.color.bgCanvas

            LockSurface {
                anchors.fill: parent
                context: lockContext
                onUnlockFinished: root.completeUnlock()
            }
        }
    }

    GlobalShortcut {
        name: "lock"
        description: "Locks the session"
        onPressed: LockState.lock()
    }

    GlobalShortcut {
        name: "lockFocus"
        description: "Refocuses the lock screen"
        onPressed: lockContext.shouldReFocus()
    }

    IpcHandler {
        target: "lock"

        function activate(): void {
            LockState.lock();
        }

        function focus(): void {
            lockContext.shouldReFocus();
        }
    }
}
