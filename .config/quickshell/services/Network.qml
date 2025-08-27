pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property list<NetworkConnection> wifiNetworks: []
    readonly property NetworkConnection activeNetwork: (ethernet || wifiNetworks?.find(net => net.active)) ?? null
    property NetworkConnection ethernet
    property bool scanning: false
    property var networkSpeed: QtObject {
        property int downTotal
        property int upTotal
        property string down
        property string up
    }

    function parseNetworkSpeed(bytes: int): string {
        const kib = 1024;
        const mib = 1024 ** 2;
        const gib = 1024 ** 3;

        if (bytes < kib) {
            return `${bytes} B/s`;
        } else if (bytes < mib) {
            return `${Math.trunc((bytes / kib) * 10) / 10} KiB/s`;
        } else if (bytes < gib) {
            return `${Math.trunc((bytes / mib) * 10) / 10} MiB/s`;
        }
        return "${bytes}";
    }

    function rescanWifi() {
        root.scanning = true;
        rescanWifiProc.running = true;
    }

    function connectToWifi(name: string) {
        connectWifiProc.command = ["bash", "-c", `nmcli connection up ${name}`];
        connectWifiProc.running = true;
    }

    function disconnectNetwork() {
        const name = root.activeNetwork.name;
        disconnectWifiProc.command = ["bash", "-c", `nmcli connection down ${name}`];
        disconnectWifiProc.running = true;
    }

    Timer {
        id: timerProc
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            networkSpeedProc.running = true;
            getWifiNetworks.running = true;
            checkEthernetConnection.running = true;
        }
    }

    Process {
        id: networkSpeedProc
        command: ["sh", "-c", "cat /proc/net/dev | tail -n +3"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let down = 0, up = 0;

                text.split("\n").forEach(line => {
                    if (line === "")
                        return;

                    const words = line.trim().split(/\s+/);

                    down += +words[1];
                    up += +words[9];
                });

                const oldDown = root.networkSpeed.downTotal;
                const oldUp = root.networkSpeed.upTotal;
                const downBytesPerSecond = (down - oldDown) / (timerProc.interval / 1000);
                const upBytesPerSecond = (up - oldUp) / (timerProc.interval / 1000);

                root.networkSpeed.down = root.parseNetworkSpeed(downBytesPerSecond);
                root.networkSpeed.up = root.parseNetworkSpeed(upBytesPerSecond);

                root.networkSpeed.downTotal = down;
                root.networkSpeed.upTotal = up;
            }
        }
    }

    Process {
        id: rescanWifiProc
        command: ["bash", "-c", "nmcli device wifi list --rescan auto"]
        stdout: SplitParser {
            onRead: {
                root.scanning = false;
                getWifiNetworks.running = true;
            }
        }
    }

    Process {
        id: connectWifiProc
        command: ["bash", "-c", "nmcli connection up"]
        stdout: SplitParser {
            onRead: getWifiNetworks.running = true
        }
    }

    Process {
        id: disconnectWifiProc
        command: ["bash", "-c", "nmcli connection up"]
        stdout: SplitParser {
            onRead: getWifiNetworks.running = true
        }
    }

    Process {
        id: checkEthernetConnection
        command: ["bash", "-c", "nmcli -g name,type connection show --active | head -n +1"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const [name, type] = text.split(":");

                if (!type.match("ethernet"))
                    return;

                root.ethernet?.destroy();

                const ethernetNetwork = ndComp.createObject(root, {
                    lastIpcObject: {
                        name,
                        type: "ethernet",
                        active: true
                    }
                });

                root.ethernet = ethernetNetwork;
            }
        }
    }

    Process {
        id: getWifiNetworks
        command: ["bash", "-c", "nmcli -g ssid,active,freq,signal,security,bssid device wifi"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const networks_raw = text.trim().split("\n");

                const networks = networks_raw.map(dev => {
                    const [ssid, active, frequency, signal, security, ...bssid] = dev.split(":");

                    return ndComp.createObject(root, {
                        lastIpcObject: {
                            name: ssid,
                            type: "wifi",
                            active: active === "yes",
                            bssid: bssid.join(":").replace(/\\/g, ""),
                            frequency,
                            strength: +signal,
                            security
                        }
                    });
                });

                networks.sort((net1, net2) => {
                    if (net1.active !== net2.active)
                        return net2.active - net1.active;

                    return net1.name > net2.name ? 1 : -1;
                });

                // destroy old networks
                root.wifiNetworks?.filter(oldNet => !networks.find(newNet => oldNet.bssid === newNet.bssid && oldNet.name === newNet.name && oldNet.frequency === newNet.frequency)).map(oldNet => oldNet.destroy());

                root.wifiNetworks = networks;
            }
        }
    }

    component NetworkConnection: QtObject {
        required property var lastIpcObject
        // strings
        readonly property var name: lastIpcObject.name
        readonly property var type: lastIpcObject.type
        readonly property var active: lastIpcObject.active
        readonly property var bssid: lastIpcObject.bssid
        readonly property var security: lastIpcObject.security
        // ints
        readonly property var frequency: lastIpcObject.frequency
        readonly property var strength: lastIpcObject.strength
    }

    Component {
        id: ndComp

        NetworkConnection {}
    }
}
