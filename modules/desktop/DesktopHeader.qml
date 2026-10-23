import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import qs.services

Item {
    id: root

    implicitHeight: Math.max(logo.height, clock.height)

    NovaLogo {
        id: logo
        size: Theme.type.boot.size
    }

    Column {
        id: clock
        anchors.right: parent.right
        spacing: Theme.metrics.gap

        NovaText {
            anchors.right: parent.right
            text: DateTime.time
            role: "display"
        }

        NovaText {
            anchors.right: parent.right
            text: DateTime.longDate
            role: "monoLarge"
            color: Theme.color.textSecondary
        }
    }
}
