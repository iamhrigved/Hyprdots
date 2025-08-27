import qs.services
import qs.config
import qs.utils
import "popouts"

import QtQuick
import QtQuick.Effects
import Quickshell

Item {
    id: root

    z: -100

    required property real center
    required property var bar

    readonly property var barState: ShellState.bar
    readonly property bool hovered: !!barState.workspaces.hoveredWindow

    property var mask: Region {
        item: contentRect
        intersection: Intersection.Subtract
    }

    anchors.top: bar.bottom
    anchors.left: parent.left
    anchors.right: parent.right

    implicitHeight: contentRect.implicitHeight

    Rectangle {
        id: contentRect

        color: Colors.palette.surface

        implicitWidth: content.implicitWidth
        implicitHeight: content.implicitHeight
        // implicitHeight: hovered ? content.implicitHeight : 0

        x: content.posX
        y: hovered ? 0 : -implicitHeight

        bottomRightRadius: 15
        bottomLeftRadius: 15

        WorkspaceWindow {
            id: content
            anchors.fill: parent
        }

        Behavior on y {
            Anim {}
        }
        Behavior on implicitHeight {
            Anim {}
        }
        Behavior on x {
            Anim {}
        }
    }

    Border {
        direction: "left"
    }

    Border {
        direction: "right"
    }

    component Border: Item {
        required property string direction

        anchors.top: parent.top
        anchors.bottom: parent.bottom

        anchors.left: direction === "left" ? parent.left : contentRect.right
        anchors.right: direction === "right" ? parent.right : contentRect.left

        Rectangle {
            anchors.fill: parent
            color: Colors.palette.surface

            layer.enabled: true
            layer.effect: MultiEffect {
                maskEnabled: true
                maskInverted: true
                maskSpreadAtMin: 1
                maskThresholdMin: 0.5
                maskSource: mask
            }
        }

        Item {
            id: mask
            anchors.fill: parent
            layer.enabled: true
            visible: false
            Rectangle {
                anchors.fill: parent
                anchors.margins: 0
                topLeftRadius: direction == "right" && 15
                topRightRadius: direction == "left" && 15

                Behavior on topLeftRadius {
                    Anim {}
                }
                Behavior on topRightRadius {
                    Anim {}
                }
            }
        }
    }

    component Anim: NumberAnimation {
        duration: 250
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Appearance.anim.emphasized
    }
}
