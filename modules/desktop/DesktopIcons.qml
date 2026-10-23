import QtQuick
import Quickshell
import qs.modules.common
import qs.modules.common.widgets
import qs.services

Flow {
    id: root

    readonly property var entries: {
        const all = DesktopEntries.applications.values;
        return Config.options.launcher.pinnedApps.map(id => DesktopEntries.heuristicLookup(id)).filter(Boolean);
    }

    spacing: Theme.metrics.gap

    Repeater {
        model: root.entries

        NovaIconTile {
            required property var modelData
            iconName: modelData.icon
            title: modelData.name
            onActivated: modelData.execute()
        }
    }
}
