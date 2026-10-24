import QtQuick
import qs.modules.lock

LockContext {
    id: mock

    property string password: "nova"

    onAuthRequested: submitted => verdict.restart()

    Timer {
        id: verdict
        interval: 600
        onTriggered: mock.currentText === mock.password ? authSucceeded() : authFailed()
    }
}
