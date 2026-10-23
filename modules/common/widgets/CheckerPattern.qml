import QtQuick
import qs.modules.common

Item {
    id: root

    property real block: Theme.metrics.block
    property color color: Theme.color.bgRaised
    property bool inverted: false

    readonly property var cells: {
        const columns = Math.ceil(width / block);
        const rows = Math.ceil(height / block);
        const parity = inverted ? 1 : 0;
        const result = [];
        for (let row = 0; row < rows; row++) {
            for (let column = 0; column < columns; column++) {
                if ((row + column) % 2 === parity)
                    result.push(Qt.point(column * block, row * block));
            }
        }
        return result;
    }

    clip: true

    Repeater {
        model: root.cells

        Rectangle {
            required property var modelData
            x: modelData.x
            y: modelData.y
            width: root.block
            height: root.block
            color: root.color
        }
    }
}
