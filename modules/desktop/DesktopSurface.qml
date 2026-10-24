import QtQuick
import qs.modules.common
import qs.modules.common.widgets

Item {
    id: root

    readonly property real unit: height / 1080
    readonly property real insetX: 168 * unit
    readonly property real insetTop: 140 * unit
    readonly property real insetBottom: 140 * unit

    Component.onCompleted: DesktopState.registerSurface(root)

    DesktopBackdrop {
        anchors.fill: parent
    }

    NovaReveal {
        id: headerReveal
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: root.insetX
        anchors.rightMargin: root.insetX
        anchors.topMargin: root.insetTop
        height: header.implicitHeight
        shown: DesktopState.revealed

        DesktopHeader {
            id: header
            anchors.fill: parent
        }
    }

    NovaReveal {
        anchors.left: parent.left
        anchors.leftMargin: root.insetX
        anchors.verticalCenter: parent.verticalCenter
        width: icons.width
        height: icons.implicitHeight
        shown: DesktopState.revealed
        delay: 40

        DesktopIcons {
            id: icons
            width: 3 * Config.options.desktop.iconCellWidth + 2 * Theme.metrics.gap
        }
    }

    NovaReveal {
        anchors.right: parent.right
        anchors.rightMargin: root.insetX
        anchors.verticalCenter: parent.verticalCenter
        width: telemetry.implicitWidth
        height: telemetry.implicitHeight
        shown: DesktopState.revealed
        delay: 80

        DesktopTelemetry {
            id: telemetry
        }
    }

    NovaReveal {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: root.insetBottom
        width: Math.min(parent.width * 0.4, 640)
        height: search.implicitHeight
        shown: DesktopState.revealed
        delay: 80

        DesktopSearch {
            id: search
            anchors.fill: parent
        }
    }
}
