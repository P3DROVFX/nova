import QtQuick
import QtQuick.Shapes
import qs.modules.common

Item {
    id: root

    property color fill: Theme.color.bgSurface
    property color stroke: Theme.color.borderSubtle
    property real strokeWidth: 0
    property real notch: 0
    property bool notchTopLeft: true
    property bool notchTopRight: true
    property bool notchBottomRight: true
    property bool notchBottomLeft: true
    default property alias content: contentItem.data

    readonly property real nTL: notchTopLeft ? notch : 0
    readonly property real nTR: notchTopRight ? notch : 0
    readonly property real nBR: notchBottomRight ? notch : 0
    readonly property real nBL: notchBottomLeft ? notch : 0

    Shape {
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            fillColor: root.fill
            strokeColor: root.stroke
            strokeWidth: root.strokeWidth > 0 ? root.strokeWidth : -1
            joinStyle: ShapePath.MiterJoin

            PathPolyline {
                path: [
                    Qt.point(root.nTL, 0),
                    Qt.point(root.width - root.nTR, 0),
                    Qt.point(root.width - root.nTR, root.nTR),
                    Qt.point(root.width, root.nTR),
                    Qt.point(root.width, root.height - root.nBR),
                    Qt.point(root.width - root.nBR, root.height - root.nBR),
                    Qt.point(root.width - root.nBR, root.height),
                    Qt.point(root.nBL, root.height),
                    Qt.point(root.nBL, root.height - root.nBL),
                    Qt.point(0, root.height - root.nBL),
                    Qt.point(0, root.nTL),
                    Qt.point(root.nTL, root.nTL),
                    Qt.point(root.nTL, 0)
                ]
            }
        }
    }

    Item {
        id: contentItem
        anchors.fill: parent
    }
}
