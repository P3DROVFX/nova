import QtQuick
import qs.modules.common

Rectangle {
    property bool vertical: false

    implicitWidth: vertical ? Theme.metrics.borderWidth : 100
    implicitHeight: vertical ? 100 : Theme.metrics.borderWidth
    width: implicitWidth
    height: implicitHeight
    color: Theme.color.borderSubtle
}
