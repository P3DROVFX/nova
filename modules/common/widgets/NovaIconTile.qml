import QtQuick
import qs.modules.common

FocusScope {
    id: root

    property string iconName: ""
    property string title: ""
    property real iconSize: Config.options.desktop.iconSize
    readonly property bool hovered: mouse.containsMouse
    readonly property bool selected: activeFocus

    signal activated

    activeFocusOnTab: true
    implicitWidth: Config.options.desktop.iconCellWidth
    implicitHeight: Config.options.desktop.iconCellHeight
    width: implicitWidth
    height: implicitHeight

    Rectangle {
        anchors.fill: parent
        color: root.hovered ? Theme.color.bgHover : root.selected ? Theme.color.bgSurface : "transparent"
        border.width: root.selected ? Theme.metrics.borderWidth : 0
        border.color: Theme.color.actionPrimary

        Behavior on color {
            ColorAnimation {
                duration: Theme.motion.fast
            }
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: Theme.metrics.gap
        width: parent.width - Theme.metrics.gap * 2

        NovaAppIcon {
            anchors.horizontalCenter: parent.horizontalCenter
            size: root.iconSize
            source: root.iconName
            fallback: "application-x-executable"
        }

        NovaText {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: root.title
            role: "mono"
            elide: Text.ElideRight
            maximumLineCount: 2
            wrapMode: Text.Wrap
            color: root.selected || root.hovered ? Theme.color.textPrimary : Theme.color.textSecondary
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.forceActiveFocus()
        onDoubleClicked: root.activated()
    }

    Keys.onPressed: event => {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            root.activated();
            event.accepted = true;
        }
    }
}
