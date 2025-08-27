pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property real cpuPerc
    readonly property real memPerc: Math.trunc((memUsed / memTotal) * 100) / 100
    readonly property real diskPerc: Math.trunc((diskUsed / diskTotal) * 100) / 100
    property string cpuTemp

    property int memTotal
    property int memUsed
    property int diskTotal
    property int diskUsed
    property int cpuTotal
    property int cpuIdle

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: {
            cpu.reload();
            mem.reload();
            disk.running = true;
            temp.running = true;
        }
    }

    FileView {
        id: mem
        path: "/proc/meminfo"

        onLoaded: {
            const data = text();
            root.memTotal = parseInt(data.match(/MemTotal: *(\d+)/)[1], 10) || 1;
            root.memUsed = (root.memTotal - parseInt(data.match(/MemAvailable: *(\d+)/)[1], 10)) || 0;
        }
    }

    Process {
        id: disk
        command: ["sh", "-c", "df --output=size,used /home | tail -n 1"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                const [total, used] = text.trim().split(/\s+/);

                root.diskTotal = total;
                root.diskUsed = used;
            }
        }
    }

    FileView {
        id: cpu
        path: "/proc/stat"

        onLoaded: {
            const data = text().match(/^cpu\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/);

            if (!data)
                return;

            const stats = data.slice(1).map(n => parseInt(n, 10));
            const total = stats.reduce((a, b) => a + b, 0);
            const idle = stats[3] + (stats[4] ?? 0);

            const totalDiff = total - root.cpuTotal;
            const idleDiff = idle - root.cpuIdle;
            const perc = totalDiff > 0 ? (1 - idleDiff / totalDiff) : 0;
            root.cpuPerc = Math.trunc(perc * 100) / 100;

            root.cpuTotal = total;
            root.cpuIdle = idle;
        }
    }

    Process {
        id: temp
        command: ["sensors"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                const tempText = text.match(/Package id \d+:\s+\+(\d+\.\d+°?C)/)[1];

                root.cpuTemp = tempText;
            }
        }
    }
}
