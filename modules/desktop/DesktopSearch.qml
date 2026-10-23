import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import qs.services

FocusScope {
    id: root

    property int currentIndex: 0
    readonly property var results: LauncherSearch.results

    implicitHeight: column.implicitHeight

    function focusInput() {
        field.inputItem.forceActiveFocus();
    }

    function runCurrent() {
        const item = results[currentIndex];
        if (!item)
            return;
        item.execute();
        LauncherSearch.clear();
        DesktopState.closeSearch();
    }

    Connections {
        target: DesktopState
        function onSearchFocusRequested() {
            root.focusInput();
        }
    }

    Connections {
        target: LauncherSearch
        function onQueryChanged() {
            root.currentIndex = 0;
        }
    }

    Column {
        id: column
        width: parent.width
        spacing: Theme.metrics.gap

        NovaSurface {
            width: parent.width
            height: list.height
            visible: list.count > 0
            fill: Theme.color.bgCanvas
            stroke: Theme.color.borderSubtle
            strokeWidth: Theme.metrics.borderWidth

            ListView {
                id: list
                width: parent.width
                height: Math.min(contentHeight, 6 * (Theme.metrics.controlHeight + Theme.metrics.gap))
                interactive: contentHeight > height
                clip: true
                model: root.results
                currentIndex: root.currentIndex

                delegate: NovaListItem {
                    required property var modelData
                    required property int index
                    width: list.width
                    iconName: modelData.iconName
                    title: modelData.name
                    subtitle: modelData.comment
                    tag: modelData.type
                    monospace: modelData.monospace
                    highlighted: index === root.currentIndex
                    onActivated: {
                        root.currentIndex = index;
                        root.runCurrent();
                    }
                }
            }
        }

        NovaTextField {
            id: field
            width: parent.width
            label: "SEARCH"
            placeholderText: "Apps, = math, $ command, ? web"
            text: LauncherSearch.query
            onTextEdited: LauncherSearch.query = text
            onAccepted: root.runCurrent()
            Keys.onPressed: event => {
                if (event.key === Qt.Key_Down) {
                    root.currentIndex = Math.min(root.currentIndex + 1, root.results.length - 1);
                    event.accepted = true;
                } else if (event.key === Qt.Key_Up) {
                    root.currentIndex = Math.max(root.currentIndex - 1, 0);
                    event.accepted = true;
                } else if (event.key === Qt.Key_Escape) {
                    LauncherSearch.clear();
                    DesktopState.closeSearch();
                    event.accepted = true;
                }
            }
        }
    }
}
