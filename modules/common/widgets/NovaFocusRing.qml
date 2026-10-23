import QtQuick
import qs.modules.common

Rectangle {
    id: root

    property bool active: false

    anchors.fill: parent
    anchors.margins: -(Theme.metrics.focusRingOffset + Theme.metrics.focusRingWidth)
    color: "transparent"
    border.width: Theme.metrics.focusRingWidth
    border.color: Theme.color.textPrimary
    visible: active
}
