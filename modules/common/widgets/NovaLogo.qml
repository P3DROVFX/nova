import QtQuick
import qs.modules.common

Column {
    id: root

    property real size: Theme.type.boot.size
    property color color: Theme.color.textPrimary

    spacing: -size * 0.31

    Repeater {
        model: ["NO", "VA"]

        Text {
            required property string modelData
            text: modelData
            color: root.color
            font.family: Theme.fonts.expressive
            font.pixelSize: root.size
            font.letterSpacing: root.size * 0.04
            renderType: Text.NativeRendering
        }
    }
}
