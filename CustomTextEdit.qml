import QtQuick 2.0

Rectangle {
    height: text_area.height
    width : 100
    property alias text: text_area.text
    property alias readonly: text_area.readOnly
    property alias font: text_area.font

    color: "#FFFFFF"

    TextEdit{
        id: text_area
        text: ""
        width: parent.width//250//parent.width/2
        //anchors.horizontalCenter: parent.horizontalCenter
        //anchors.top: blank_header_area.bottom
        //verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff //to hide scrollbar
        z: 2
        wrapMode: TextEdit.Wrap


    }
//    Rectangle{
//        x: text_area.x
//        y: text_area.y
//        width: text_area.width
//        height: text_area.height
//        z: 1
//        color: "#FFFFFF"
//    }

}

