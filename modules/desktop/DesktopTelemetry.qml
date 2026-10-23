import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import qs.services

Column {
    spacing: 4

    NovaStat {
        label: "CPU"
        labelWidth: 48
        value: `${Math.round(ResourceUsage.cpuUsage * 100)}%`
    }

    NovaStat {
        label: "RAM"
        labelWidth: 48
        value: `${Math.round(ResourceUsage.memoryUsedPercentage * 100)}%`
    }

    NovaStat {
        visible: Battery.available
        label: "BAT"
        labelWidth: 48
        value: `${Math.round(Battery.percentage * 100)}%${Battery.isCharging ? " +" : ""}`
        valueColor: Battery.isCriticalAndNotCharging ? Theme.color.statusError : Battery.isLowAndNotCharging ? Theme.color.statusWarning : Theme.color.textPrimary
    }

    NovaStat {
        label: "NET"
        labelWidth: 48
        value: Network.networkName.length > 0 ? Network.networkName : "OFFLINE"
        valueColor: Network.networkName.length > 0 ? Theme.color.textPrimary : Theme.color.textSecondary
    }
}
