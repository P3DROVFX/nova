pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    readonly property list<ColorPalette> all: [novaDark]
    readonly property ColorPalette fallback: novaDark

    function byKey(key: string): ColorPalette {
        return all.find(p => p.key === key) ?? fallback;
    }

    NovaDark {
        id: novaDark
    }
}
