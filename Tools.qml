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
                text: qsTr("hide cites")
                onTriggered: {
                    messageDialog.show("hide cites")
                }
            }
        }
    }



    Component.onCompleted: {
        addSection("\n\n\n\n\n",true,500);
        addSection("topic",false,250);
        addSection("authors",false,250);
    }




    Component{
        id: font_delegate
        Text {
            text: modelData
            font.family: modelData
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    test_textarea.font.family = modelData
                }
            }
        }

    }



    ListView{
        id: sections_listview
        delegate: font_delegate
        model: Qt.fontFamilies()
        height: parent.height/2
        width: parent.width/2
        anchors.top: parent.top
        anchors.left: parent.left
        spacing: 10
        highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
    }

    TextArea{
        id: test_textarea
        width: parent.width/2
        height: parent.height/2
        anchors.top: parent.top
        anchors.right: parent.right

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
