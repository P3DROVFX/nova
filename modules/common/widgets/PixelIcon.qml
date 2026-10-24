import QtQuick
import qs.modules.common

Item {
    id: root

    property var cells: []
    property real cell: 16
    property color color: Theme.color.textPrimary
    property real revealed: cells.length

    readonly property int columns: cells.reduce((m, c) => Math.max(m, c[0] + 1), 0)
    readonly property int rows: cells.reduce((m, c) => Math.max(m, c[1] + 1), 0)

    implicitWidth: columns * cell
    implicitHeight: rows * cell
    width: implicitWidth
    height: implicitHeight

    Repeater {
        model: root.cells

        Rectangle {
            required property var modelData
            required property int index
            x: modelData[0] * root.cell
            y: modelData[1] * root.cell
            width: root.cell
            height: root.cell
            color: root.color
            visible: index < root.revealed
        }
    }
}
