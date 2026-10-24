import QtQuick
import QtQuick.Effects
import qs.modules.common

Item {
    id: root

    property color glowColor: Theme.color.actionPrimary
    property real strength: 0.7
    property real blur: 0.9
    default property alias content: holder.data

    implicitWidth: holder.childrenRect.width
    implicitHeight: holder.childrenRect.height

    Item {
        id: holder
        anchors.fill: parent
        layer.enabled: root.strength > 0
        layer.effect: MultiEffect {
            autoPaddingEnabled: true
            shadowEnabled: true
            shadowColor: root.glowColor
            shadowOpacity: root.strength
            shadowBlur: root.blur
            shadowScale: 1.04
        }
    }
}
