import qs.utils

import "components"
import "components/workspaces"

import QtQuick
import Quickshell

Rectangle {
    id: root

    anchors.top: parent.top
    anchors.right: parent.right
    anchors.left: parent.left

    implicitHeight: Math.max(osIcon.implicitHeight, workspaces.implicitHeight) + 10

    color: Colors.palette.surface

    OsIcon {
        id: osIcon
        objectName: "osIcon"

        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 10
    }

    Workspaces {
        id: workspaces
        objectName: "workspaces"

        anchors.left: osIcon.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 30
    }

    WindowTitle {
        id: windowTitle
        objectName: "windowTitle"

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Network {
        id: network
        objectName: "network"

        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 30
    }
}
