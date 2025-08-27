pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

import QtQuick

Singleton {
    id: root

    readonly property var toplevels: Hyprland.toplevels
    readonly property var activeToplevel: getWindowsInWorkspace(focusedWorkspaceId).length !== 0 && Hyprland.activeToplevel
    readonly property var workspaces: Hyprland.workspaces
    readonly property var focusedWorkspace: Hyprland.focusedWorkspace
    readonly property var focusedWorkspaceId: focusedWorkspace?.id ?? 1

    function dispatch(request: string): void {
        Hyprland.dispatch(request);
    }

    function getWindowsInWorkspace(workspaceId: int): var {
        return root.toplevels.values.filter(tl => tl.workspace?.id === workspaceId);
    }

    function updateAll() {
        Hyprland.refreshWorkspaces();
        Hyprland.refreshToplevels();
    }

    // update all variables at the start
    Component.onCompleted: {
        updateAll();
    }

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            // if (event.name.endsWith("v2"))
            //     return;

            root.updateAll();
        }
    }
}
