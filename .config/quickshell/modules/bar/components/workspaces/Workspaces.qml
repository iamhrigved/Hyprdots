import qs.utils
import qs.config
import qs.services

import QtQuick
import QtQuick.Layouts

Item {
    id: root

    implicitWidth: baseRect.implicitWidth
    implicitHeight: baseRect.implicitHeight

    // workspace outline
    Rectangle {
        id: baseRect

        color: Colors.palette.surface_container
        radius: implicitHeight / 2

        implicitHeight: baseLayout.implicitHeight + 8
        implicitWidth: baseLayout.implicitWidth + 8

        // main workspaces layout
        RowLayout {
            id: baseLayout
            spacing: 0
            z: 1

            anchors.centerIn: parent

            Repeater {
                model: {
                    const totalWorkspaces = Hyprland.workspaces.values.length;
                    const lastWsId = Hyprland.workspaces.values[totalWorkspaces - 1]?.id;

                    return lastWsId > 5 ? lastWsId : 5;
                }

                Workspace {}
            }
        }

        // focused workspace
        FocusedWorkspace {
            z: 2
        }

        // workspace icons
        RowLayout {
            id: workspaceIcons
            z: 3
            spacing: 0

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 4

            Repeater {
                model: {
                    const totalWorkspaces = Hyprland.workspaces.values.length;
                    const lastWsId = Hyprland.workspaces.values[totalWorkspaces - 1]?.id;

                    return lastWsId > 5 ? lastWsId : 5;
                }

                WorkspaceIcon {
                    id: wsIcon
                }
            }
        }

        Behavior on implicitWidth {
            NumberAnimation {
                duration: 250
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.anim.emphasized
            }
        }
    }
}
