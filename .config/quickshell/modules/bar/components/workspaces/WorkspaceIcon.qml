import qs.utils
import qs.config
import qs.services

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

// TODO: IMPLEMENT ON MOVE

Item {
    id: root

    required property var index
    readonly property var windowsInWorkspace: Hyprland.getWindowsInWorkspace(index + 1)
    readonly property var isFocused: Hyprland.focusedWorkspaceId === index + 1

    implicitWidth: appIconLoader.implicitWidth
    implicitHeight: appIconLoader.implicitHeight

    Loader {
        id: appIconLoader

        anchors.verticalCenter: root.verticalCenter
        anchors.left: root.left

        readonly property Component appIcon: RowLayout {
            id: layout
            spacing: 0

            Repeater {
                model: windowsInWorkspace

                IconItem {}
            }
        }

        readonly property Component dot: Item {
            id: dotItem
            implicitHeight: 26
            implicitWidth: 26

            property bool hovered

            Rectangle {
                id: dot
                anchors.centerIn: dotItem

                implicitHeight: 8
                implicitWidth: 8

                radius: 4
                scale: !root.isFocused && parent.hovered ? 1.5 : 1
                color: Colors.palette.surface_variant

                Behavior on scale {
                    Anim {}
                }
            }

            ActivateWindow {}
        }

        sourceComponent: windowsInWorkspace.length !== 0 ? appIcon : dot
    }

    component IconItem: Item {
        implicitWidth: 26
        implicitHeight: 26

        readonly property var window: modelData
        readonly property var windowClass: window.lastIpcObject?.class
        property bool hovered

        scale: windowClass ? 1 : 0

        IconImage {
            source: Quickshell.iconPath(Utils.getIconPath(windowClass), "window")
            anchors.centerIn: parent

            implicitSize: 18
            scale: parent.hovered ? 1.2 : 1

            Behavior on scale {
                Anim {}
            }
        }

        ActivateWindow {
            window: parent.window
        }

        Behavior on scale {
            Anim {}
        }
    }

    component ActivateWindow: MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        property var window

        onPressed: {
            // if clicked on a window icon
            if (window) {
                Hyprland.dispatch(`focuswindow address:0x${window.address}`);
            } else

            // if clicked on a dot which is not active
            if (!root.isFocused) {
                Hyprland.dispatch(`workspace ${root.index + 1}`);
            }
        }
        onEntered: {
            if (window)
                ShellState.bar.workspaces.hoveredWindow = window;
            parent.hovered = true;
        }
        onExited: {
            if (window)
                ShellState.bar.workspaces.hoveredWindow = undefined;
            parent.hovered = false;
        }
    }

    component Anim: NumberAnimation {
        duration: 250
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Appearance.anim.emphasized
    }
}
