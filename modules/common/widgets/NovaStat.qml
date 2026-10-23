import QtQuick
import qs.modules.common

Row {
    id: root

    property string label: ""
    property string value: ""
    property color valueColor: Theme.color.textPrimary
    property real labelWidth: 0

    spacing: Theme.metrics.gap

    NovaText {
        width: root.labelWidth > 0 ? root.labelWidth : implicitWidth
        text: root.label
        role: "caption"
        color: Theme.color.textMuted
    }

    NovaText {
        text: root.value
        role: "mono"
        color: root.valueColor
    }
}
