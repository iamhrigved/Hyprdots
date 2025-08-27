import qs.config
import qs.utils
import qs.services

import QtQuick

Rectangle {
    id: root

    property real focusedWorkspaceId: Hyprland.focusedWorkspaceId
    property var windowsInWorkspace: Hyprland.getWindowsInWorkspace(focusedWorkspaceId)
    property real windowsBehind: {
        let ret = 0;

        for (let i = 1; i < focusedWorkspaceId; i++) {
            ret += Hyprland.getWindowsInWorkspace(i)?.length || 1;
        }

        return ret;
    }

    anchors.verticalCenter: parent.verticalCenter

    x: windowsBehind * 26 + 4

    implicitWidth: (windowsInWorkspace?.length || 1) * 26
    implicitHeight: 26
    radius: 13

    color: Colors.palette.secondary

    Behavior on implicitWidth {
        Anim {}
    }

    Behavior on windowsBehind {
        Anim {}
    }

    component Anim: NumberAnimation {
        duration: 250
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Appearance.anim.emphasized
    }
}
