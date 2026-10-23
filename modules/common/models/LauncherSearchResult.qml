import QtQuick

QtObject {
    property string type: ""
    property string name: ""
    property string iconName: ""
    property string verb: ""
    property bool monospace: false
    property string id: ""
    property string comment: ""
    property string genericName: ""
    property var execute: () => {}
    property var actions: []
}
