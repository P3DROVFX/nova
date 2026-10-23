import QtQuick
import qs.modules.common

FocusScope {
    id: root

    property string label: ""
    property string hint: ""
    property string errorText: ""
    property string placeholderText: ""
    property bool large: false
    property alias text: input.text
    property alias echoMode: input.echoMode
    property alias inputItem: input
    readonly property bool hasError: errorText.length > 0

    signal accepted
    signal textEdited

    activeFocusOnTab: true
    implicitWidth: 240
    implicitHeight: column.implicitHeight
    width: implicitWidth
    height: implicitHeight
    onActiveFocusChanged: if (activeFocus)
        input.forceActiveFocus()

    Column {
        id: column
        width: parent.width
        spacing: Theme.metrics.gap

        NovaText {
            visible: root.label.length > 0
            text: root.label
            role: "label"
            color: root.enabled ? Theme.color.textPrimary : Theme.color.textMuted
        }

        Item {
            width: parent.width
            height: root.large ? Theme.metrics.authFieldHeight : Theme.metrics.controlHeight

            Rectangle {
                anchors.fill: parent
                visible: !root.large
                color: root.enabled ? Theme.color.bgCanvas : Theme.color.bgRaised
                border.width: Theme.metrics.borderWidth
                border.color: !root.enabled ? Theme.color.borderSubtle : root.hasError ? Theme.color.statusError : input.activeFocus ? Theme.color.actionPrimary : Theme.color.borderControl
            }

            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: input.activeFocus ? 2 : Theme.metrics.borderWidth
                visible: root.large
                color: root.hasError ? Theme.color.statusError : input.activeFocus ? Theme.color.actionPrimary : Theme.color.borderControl
            }

            TextInput {
                id: input
                anchors.fill: parent
                anchors.leftMargin: root.large ? 0 : Theme.metrics.padding - 4
                anchors.rightMargin: root.large ? 0 : Theme.metrics.padding - 4
                verticalAlignment: TextInput.AlignVCenter
                clip: true
                enabled: root.enabled
                focus: true
                color: root.enabled ? Theme.color.textPrimary : Theme.color.textMuted
                selectionColor: Theme.color.actionPrimary
                selectedTextColor: Theme.color.actionOnPrimary
                font.family: root.large ? Theme.type.monoInput.family : Theme.type.body.family
                font.pixelSize: root.large ? Theme.type.monoInput.size : Theme.type.body.size
                renderType: Text.NativeRendering
                onAccepted: root.accepted()
                onTextEdited: root.textEdited()

                cursorDelegate: Rectangle {
                    width: root.large ? 12 : 2
                    color: Theme.color.actionPrimary
                    visible: input.activeFocus

                    SequentialAnimation on opacity {
                        running: input.activeFocus && !Theme.reducedMotion
                        loops: Animation.Infinite
                        NumberAnimation { to: 1; duration: 0 }
                        PauseAnimation { duration: 530 }
                        NumberAnimation { to: 0; duration: 0 }
                        PauseAnimation { duration: 530 }
                    }
                }
            }

            NovaText {
                anchors.fill: input
                verticalAlignment: Text.AlignVCenter
                visible: input.text.length === 0 && !input.activeFocus
                text: root.placeholderText
                role: root.large ? "monoInput" : "body"
                color: Theme.color.textMuted
            }
        }

        NovaText {
            visible: text.length > 0
            text: root.hasError ? root.errorText : root.hint
            role: "mono"
            color: root.hasError ? Theme.color.statusError : Theme.color.textSecondary
        }
    }
}
