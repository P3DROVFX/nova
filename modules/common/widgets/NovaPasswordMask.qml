import QtQuick
import qs.modules.common

Item {
    id: root

    property int count: 0
    property real cell: 30
    property real gap: 36
    property real fieldWidth: 1008
    property bool active: true
    property bool danger: false
    property real fillProgress: 0
    property color maskColor: danger ? Theme.color.dangerAccent : Theme.color.textPrimary
    property color accentColor: danger ? Theme.color.dangerAccent : Theme.color.actionPrimary

    readonly property real glyphSize: cell * 3
    readonly property real pitch: glyphSize + gap
    readonly property int capacity: Math.max(1, Math.floor((fieldWidth - cell - gap) / pitch))
    readonly property int visibleCount: Math.min(count, capacity)
    readonly property real cursorWidth: cell + 2

    implicitWidth: fieldWidth
    implicitHeight: glyphSize
    width: implicitWidth
    height: implicitHeight

    onVisibleCountChanged: {
        cursor.opacity = 1;
        if (cursor.visible && !Theme.reducedMotion)
            cursorBlink.restart();
    }

    Repeater {
        model: root.visibleCount

        Item {
            id: glyph

            required property int index
            x: index * root.pitch
            width: root.glyphSize
            height: root.glyphSize

            Repeater {
                model: [[0, 0], [2, 0], [1, 1], [0, 2], [2, 2]]

                Rectangle {
                    required property var modelData
                    x: modelData[0] * root.cell
                    y: modelData[1] * root.cell
                    width: root.cell
                    height: root.cell
                    color: root.maskColor
                }
            }
        }
    }

    Rectangle {
        id: cursor
        x: root.visibleCount * root.pitch
        width: root.cursorWidth
        height: root.glyphSize
        color: root.accentColor
        visible: root.active && root.fillProgress <= 0 && !root.danger

        SequentialAnimation {
            id: cursorBlink
            running: cursor.visible && !Theme.reducedMotion
            loops: Animation.Infinite
            NumberAnimation { target: cursor; property: "opacity"; to: 1; duration: 0 }
            PauseAnimation { duration: 530 }
            NumberAnimation { target: cursor; property: "opacity"; to: 0; duration: 0 }
            PauseAnimation { duration: 530 }
        }
    }

    Rectangle {
        height: root.glyphSize
        width: Math.round(root.fillProgress * root.fieldWidth / root.cell) * root.cell
        color: root.accentColor
        visible: width > 0
    }
}
