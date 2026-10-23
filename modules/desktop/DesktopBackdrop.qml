import QtQuick
import qs.modules.common
import qs.services

Item {
    Rectangle {
        anchors.fill: parent
        color: Theme.color.bgCanvas
    }

    Image {
        anchors.fill: parent
        source: Wallpapers.source
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: false
        smooth: true
    }
}
