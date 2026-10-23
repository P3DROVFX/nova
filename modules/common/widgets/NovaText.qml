import QtQuick
import qs.modules.common

Text {
    id: root

    property string role: "body"
    readonly property var spec: Theme.type[role]

    color: Theme.color.textPrimary
    font.family: spec.family
    font.pixelSize: spec.size
    font.weight: spec.weight
    font.letterSpacing: spec.spacing
    font.capitalization: spec.upper ? Font.AllUppercase : Font.MixedCase
    renderType: Text.NativeRendering
}
