//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic

import qs.modules.common
import qs.modules.desktop
import qs.modules.dev
import QtQuick
import Quickshell

ShellRoot {
    Loader {
        active: Config.ready
        sourceComponent: DesktopPanel {}
    }

    Loader {
        active: Quickshell.env("NOVA_DEV") === "1"
        sourceComponent: DevTools {}
    }
}
