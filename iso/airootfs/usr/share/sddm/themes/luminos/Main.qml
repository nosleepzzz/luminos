import QtQuick 2.15
import SddmComponents 2.0

Item {
    id: root
    property real titleSize: Math.min(width, height) * 0.045

    Image {
        anchors.fill: parent
        source: config.background || "/usr/share/backgrounds/luminos/lumin-wallpaper.jpg"
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: true
    }

    Rectangle {
        anchors.fill: parent
        color: "#66000000"
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.08
        text: "LuminOS Glass"
        color: "#e6b800"
        font.pixelSize: titleSize
        font.bold: true
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.08 + titleSize + 8
        text: "pre-alpha live session"
        color: "#cccccc"
        font.pixelSize: titleSize * 0.45
    }

    Login {
        id: login
        anchors.centerIn: parent
        width: parent.width / 2.4
        height: parent.height / 2.4
    }
}
