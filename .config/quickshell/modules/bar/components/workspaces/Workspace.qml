import qs.utils
import qs.config
import qs.services
import qs.config

import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

Item {
    id: root

    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight

    required property var index
    readonly property var windowsInWorkspace: Hyprland.getWindowsInWorkspace(index + 1)

    property var isHovered

    RowLayout {
        id: layout
        spacing: 0

        Repeater {
            id: repeater
            model: windowsInWorkspace.length || 1

            Item {
                id: workspaceRect

                required property var index

                implicitWidth: 26
                implicitHeight: implicitWidth
            }
        }
    }

    component Anim: NumberAnimation {
        duration: 200
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Appearance.anim.curves.standard
    }
}
