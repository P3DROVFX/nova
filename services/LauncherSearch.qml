pragma Singleton

import qs.modules.common
import qs.modules.common.models
import qs.modules.common.functions
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string query: ""
    property string mathResult: ""

    readonly property string prefixApp: Config.options.search.prefix.app
    readonly property string prefixMath: Config.options.search.prefix.math
    readonly property string prefixShell: Config.options.search.prefix.shellCommand
    readonly property string prefixWeb: Config.options.search.prefix.webSearch

    function openEntry(entry: var, runInTerminal: bool, command: var): void {
        if (!runInTerminal) {
            entry.execute();
            return;
        }
        Quickshell.execDetached(["bash", "-c", `${Config.options.apps.terminal} -e '${StringUtils.shellSingleQuoteEscape(command.join(" "))}'`]);
    }

    function clear(): void {
        query = "";
        mathResult = "";
    }

    Timer {
        id: mathTimer
        interval: Config.options.search.nonAppResultDelay
        onTriggered: {
            const expression = root.query.startsWith(root.prefixMath) ? root.query.slice(root.prefixMath.length) : root.query;
            mathProcess.calculate(expression);
        }
    }

    Process {
        id: mathProcess
        function calculate(expression) {
            running = false;
            command = ["qalc", "-t"].concat(expression);
            running = true;
        }
        stdout: SplitParser {
            onRead: data => root.mathResult = data
        }
    }

    Component {
        id: resultComponent
        LauncherSearchResult {}
    }

    property list<var> results: {
        if (root.query === "")
            return [];

        mathTimer.restart();

        const startsWithNumber = /^\d/.test(root.query);
        const startsWithMath = root.query.startsWith(root.prefixMath);
        const startsWithShell = root.query.startsWith(root.prefixShell);
        const startsWithWeb = root.query.startsWith(root.prefixWeb);

        const apps = AppSearch.fuzzyQuery(StringUtils.cleanPrefix(root.query, root.prefixApp)).map(entry => resultComponent.createObject(null, {
            type: "App",
            id: entry.id,
            name: entry.name,
            iconName: entry.icon,
            verb: "Open",
            comment: entry.comment,
            genericName: entry.genericName,
            execute: () => root.openEntry(entry, entry.runInTerminal, entry.command),
            actions: entry.actions.map(action => resultComponent.createObject(null, {
                name: action.name,
                iconName: action.icon,
                execute: () => root.openEntry(action, action.runInTerminal, action.command)
            }))
        }));

        const math = resultComponent.createObject(null, {
            type: "Math",
            name: root.mathResult,
            verb: "Copy",
            monospace: true,
            iconName: "accessories-calculator",
            execute: () => Quickshell.clipboardText = root.mathResult
        });

        const shellCommand = StringUtils.cleanPrefix(root.query, root.prefixShell).replace("file://", "");
        const command = resultComponent.createObject(null, {
            type: "Command",
            name: shellCommand,
            verb: "Run",
            monospace: true,
            iconName: "utilities-terminal",
            execute: () => Quickshell.execDetached(["bash", "-c", `${Config.options.apps.terminal} -e bash -c '${StringUtils.shellSingleQuoteEscape(shellCommand)}; read -n1'`])
        });

        const webQuery = StringUtils.cleanPrefix(root.query, root.prefixWeb);
        const web = resultComponent.createObject(null, {
            type: "Web",
            name: webQuery,
            verb: "Search",
            iconName: "internet-web-browser",
            execute: () => Quickshell.execDetached(["xdg-open", `${Config.options.search.engineBaseUrl}${encodeURIComponent(webQuery)}`])
        });

        let result = [];
        if (startsWithNumber || startsWithMath)
            result.push(math);
        else if (startsWithShell)
            result.push(command);
        else if (startsWithWeb)
            result.push(web);

        result = result.concat(apps);

        if (Config.options.search.prefix.showDefaultActionsWithoutPrefix) {
            if (!startsWithShell)
                result.push(command);
            if (!startsWithNumber && !startsWithMath)
                result.push(math);
            if (!startsWithWeb)
                result.push(web);
        }
        return result;
    }
}
