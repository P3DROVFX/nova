pragma Singleton
pragma ComponentBehavior: Bound

import "palettes"
import QtQuick
import Quickshell

Singleton {
    id: root

    readonly property ColorPalette palette: Palettes.byKey(Config.options.appearance.palette)
    readonly property bool reducedMotion: Config.options.appearance.reducedMotion

    readonly property QtObject color: palette

    readonly property QtObject fonts: QtObject {
        readonly property string expressive: architype.name
        readonly property string mono: plexMono.name
    }

    readonly property QtObject type: QtObject {
        readonly property var boot: ({ family: root.fonts.expressive, size: 112, weight: Font.Normal, spacing: 4, upper: true })
        readonly property var display: ({ family: root.fonts.expressive, size: 64, weight: Font.Normal, spacing: 3, upper: true })
        readonly property var title: ({ family: root.fonts.expressive, size: 32, weight: Font.Normal, spacing: 2, upper: true })
        readonly property var heading: ({ family: root.fonts.mono, size: 20, weight: Font.Bold, spacing: 0, upper: false })
        readonly property var body: ({ family: root.fonts.mono, size: 14, weight: Font.Normal, spacing: 0, upper: false })
        readonly property var label: ({ family: root.fonts.mono, size: 13, weight: Font.Bold, spacing: 0, upper: false })
        readonly property var caption: ({ family: root.fonts.mono, size: 11, weight: Font.Normal, spacing: 1, upper: true })
        readonly property var mono: ({ family: root.fonts.mono, size: 12, weight: Font.Normal, spacing: 0, upper: false })
        readonly property var monoLarge: ({ family: root.fonts.mono, size: 18, weight: Font.Normal, spacing: 0, upper: false })
        readonly property var monoInput: ({ family: root.fonts.mono, size: 40, weight: Font.Normal, spacing: 0, upper: false })
        readonly property var action: ({ family: root.fonts.mono, size: 14, weight: Font.Bold, spacing: 1, upper: true })
        readonly property var clock: ({ family: root.fonts.mono, size: 24, weight: Font.Normal, spacing: 0, upper: false })
        readonly property var subtitle: ({ family: root.fonts.mono, size: 20, weight: Font.Normal, spacing: 0.5, upper: true })
        readonly property var fieldLabel: ({ family: root.fonts.mono, size: 16, weight: Font.Normal, spacing: 0.5, upper: true })
        readonly property var alertLarge: ({ family: root.fonts.expressive, size: 44, weight: Font.Normal, spacing: 3, upper: true })
        readonly property var actionLarge: ({ family: root.fonts.mono, size: 32, weight: Font.Normal, spacing: 0, upper: true })
    }

    readonly property QtObject metrics: QtObject {
        readonly property int controlHeight: 44
        readonly property int authControlHeight: 88
        readonly property int authFieldHeight: 120
        readonly property int hitArea: 44
        readonly property int padding: 16
        readonly property int gap: 8
        readonly property int borderWidth: 1
        readonly property int focusRingWidth: 2
        readonly property int focusRingOffset: 2
        readonly property int notch: 24
        readonly property int markSize: 28
        readonly property int block: 16
    }

    readonly property QtObject motion: QtObject {
        readonly property int instant: 0
        readonly property int reduced: 80
        readonly property int fast: root.reducedMotion ? 80 : 100
        readonly property int base: root.reducedMotion ? 80 : 180
        readonly property int window: root.reducedMotion ? 80 : 240
        readonly property int reveal: root.reducedMotion ? 80 : 320
    }

    readonly property QtObject ease: QtObject {
        readonly property list<real> enter: [0.16, 1, 0.3, 1, 1, 1]
        readonly property list<real> exit: [0.4, 0, 1, 1, 1, 1]
        readonly property list<real> standard: [0.2, 0, 0, 1, 1, 1]
    }

    FontLoader {
        id: architype
        source: Qt.resolvedUrl("../../assets/fonts/ArchitypeStedelijkW00.ttf")
    }

    FontLoader {
        id: plexMono
        source: Qt.resolvedUrl("../../assets/fonts/IBMPlexMono-Regular.ttf")
    }

    FontLoader {
        id: plexMonoBold
        source: Qt.resolvedUrl("../../assets/fonts/IBMPlexMono-Bold.ttf")
    }
}
