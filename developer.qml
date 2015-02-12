import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2

ApplicationWindow {
    title: qsTr("Hello World")
    width: 640
    height: 480
    visible: true

    property variant blue_highlights: ["cite"]
    property alias main_text: main_text_area.text

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
                text: qsTr("show cites")
                onTriggered: {
                    //messageDialog.show("show cites")
                    addColor()
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

//    MainForm {
//        anchors.fill: parent
//        button1.onClicked: messageDialog.show(qsTr("Button 1 pressed"))
//        button2.onClicked: messageDialog.show(qsTr("Button 2 pressed"))
//        button3.onClicked: messageDialog.show(qsTr("Button 3 pressed"))
//    }

    Timer{
        interval: 3000
        running: true
        repeat: true
        onTriggered: checkCitation()
    }

    TextArea{
        id: main_text_area
        text: "before<span style='color:#aa0000;'>within</span>after"
        width: parent.width-20
        height: parent.height/2
        anchors.right: parent.right
        anchors.top: parent.top
        textFormat: TextEdit.RichText
    }

    TextArea{
        text: main_text
        textFormat: TextEdit.PlainText
        width: main_text_area.width
        height: parent.height - main_text_area.height
        anchors.bottom: parent.bottom
        anchors.right: parent.right
    }

    function addColor(){
        main_text.slice()
        main_text = "new text"
    }

    function checkCitation(){
        var cursor_position;//main_text_area.cursorPosition;
        var re = [new RegExp(/\\cite/g), new RegExp(/\\section/g) ];
        var rep = ["cite", "section"]
        for (var i in re){
            cursor_position = main_text_area.cursorPosition;
            //console.debug(re[i]);
            //main_text = main_text.replace(re[i],"<span style=\"color:#aa0000;\">\\cite</span>");
            main_text = main_text.replace(re[i],"<span style=\"color:#0000ff;\">\\"+rep[i]+"</span>");
            main_text_area.cursorPosition = cursor_position;
        }
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
