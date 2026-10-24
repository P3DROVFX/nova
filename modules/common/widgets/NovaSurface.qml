import QtQuick
import QtQuick.Shapes
import qs.modules.common

Item {
    id: root

    property color fill: Theme.color.bgSurface
    property color stroke: Theme.color.borderSubtle
    property real strokeWidth: 0
    property real notch: 0
    property real notchWidth: notch
    property real notchHeight: notch
    property bool notchTopLeft: true
    property bool notchTopRight: true
    property bool notchBottomRight: true
    property bool notchBottomLeft: true
    default property alias content: contentItem.data

    readonly property real wTL: notchTopLeft ? notchWidth : 0
    readonly property real wTR: notchTopRight ? notchWidth : 0
    readonly property real wBR: notchBottomRight ? notchWidth : 0
    readonly property real wBL: notchBottomLeft ? notchWidth : 0
    readonly property real hTL: notchTopLeft ? notchHeight : 0
    readonly property real hTR: notchTopRight ? notchHeight : 0
    readonly property real hBR: notchBottomRight ? notchHeight : 0
    readonly property real hBL: notchBottomLeft ? notchHeight : 0

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
                    Qt.point(root.wTL, 0),
                    Qt.point(root.width - root.wTR, 0),
                    Qt.point(root.width - root.wTR, root.hTR),
                    Qt.point(root.width, root.hTR),
                    Qt.point(root.width, root.height - root.hBR),
                    Qt.point(root.width - root.wBR, root.height - root.hBR),
                    Qt.point(root.width - root.wBR, root.height),
                    Qt.point(root.wBL, root.height),
                    Qt.point(root.wBL, root.height - root.hBL),
                    Qt.point(0, root.height - root.hBL),
                    Qt.point(0, root.hTL),
                    Qt.point(root.wTL, root.hTL),
                    Qt.point(root.wTL, 0)
                ]
            }
        }
    }

    Item {
        id: contentItem
        anchors.fill: parent
    }
}
