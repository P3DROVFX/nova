pragma Singleton

import QtQuick
import Quickshell

Singleton {
    property bool locked: false

    signal unlocked

    function lock() {
        locked = true;
    }

    function unlock() {
        if (!locked)
            return;
        locked = false;
        unlocked();
    }
}
