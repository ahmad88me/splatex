import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2


ApplicationWindow {
    title: qsTr("Hello World")
    width: 640
    height: 480
    visible: true
    //color: "grey"

    menuBar: MenuBar {
        Menu {
            title: qsTr("&File")
            MenuItem {
                text: qsTr("&Open")
                onTriggered: messageDialog.show(qsTr("Open action triggered"));
            }
            MenuItem {
                text: qsTr("E&xit")
                onTriggered: Qt.quit();
            }
            MenuItem {
                text: qsTr("Exit")
                //onTriggered: Qt.quit();
            }
        }
        Menu{
            title: qsTr("&Latex")
            MenuItem{
                text: qsTr("Add section")
                shortcut: ""
                onTriggered: {
                    //messageDialog.show("show cites")
                    addSection("section",false,400)

                }
            }
            MenuItem{
                text: qsTr("tools")
                onTriggered: {
                    messageDialog.show("view tools")
                    tools.visible = true
                }
            }
        }
    }


    Tools{
        id: tools
        visible: true
    }


//    MainForm {
//        anchors.fill: parent
//        button1.onClicked: messageDialog.show(qsTr("Button 1 pressed"))
//        button2.onClicked: messageDialog.show(qsTr("Button 2 pressed"))
//        button3.onClicked: messageDialog.show(qsTr("Button 3 pressed"))
//    }

//    TextArea{
//        id: blank_header_area
//        text: "\n\n\n\n\n\n"
//        textFormat: TextEdit.PlainText
//        width: parent.width
//    }

//    CustomTextEdit{
//        id: topic_area
//        width: 250
//        anchors.horizontalCenter: parent.horizontalCenter
//        anchors.top: blank_header_area.bottom
//    }

    Component.onCompleted: {
        //messageDialog.show("loaded")
        addSection("\n\n\n\n\n",true,500);
        addSection("topic",false,250);
        addSection("authors",false,250);
        //v_text,v_readonly,v_width,v_margin
    }

//    CustomTextEdit{
//        id: autors_area
//        width: 250
//        anchors.horizontalCenter: parent.horizontalCenter
//        anchors.top: topic_area.top
//        anchors.topMargin: 50
//    }


    Component{
        id: section_delegate
        CustomTextEdit{
            text: v_text
            readonly: v_readonly
            width: v_width
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: "times new roman"
            font.pointSize: 22
            //font.bold: true
        }
    }

    Component{
        id: font_delegate
        Text {
            text: modelData
            font.family: modelData
        }
    }



    ListView{
        id: sections_listview
        //delegate: font_delegate
        delegate: section_delegate
        //model: Qt.fontFamilies()
        model: sections_listmodel
        //anchors.fill: parent
        height: parent.height/2
        width: parent.width
        anchors.top: parent.top
        spacing: 10
        highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
    }

    TextArea{
        id: mp
        textFormat: TextEdit.RichText
        height: parent.height/2
        width: parent.width/2
        anchors.bottom: parent.bottom
        anchors.right: parent.right
    }
    TextArea{
        text: mp.text
        textFormat: TextEdit.PlainText
        readOnly: true
        height: parent.height/2
        width: parent.width/2
        anchors.bottom: parent.bottom
        anchors.left: parent.left
    }

    ListModel{
        id: sections_listmodel
//        ListElement{
//            v_text: "the new test"
//            v_readonly: false
//            v_width: 250
//            v_margin: 100
//        }
    }


    function addSection(v_text,v_readonly,v_width){
        //sections_listmodel.insert()
        sections_listmodel.append({"v_readonly": v_readonly, "v_width":v_width, "v_text": v_text })
    }


    MessageDialog {
        id: messageDialog
        title: qsTr("May I have your attention, please?")

        function show(caption) {
            messageDialog.text = caption;
            messageDialog.open();
        }
    }

}
