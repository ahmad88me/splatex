import QtQuick 2.0

Rectangle {
    height: text_area.height+5
    width : 100
    color: "#FFFFFF"
    property alias text: text_area.text
    property alias readonly: text_area.readOnly
    property alias font: text_area.font
//    property int section_type: 0//should be one of the below
//    property int section_header: 0//a section type
//    property int subsection_header: 1//a section type
//    property int section: 2//a section type
    border.width: 1
    border.color: "#AAAAAA"
    radius: 3
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

