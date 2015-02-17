import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import FileIO 1.0

ApplicationWindow {
    title: qsTr("Hello World")
    width: 640
    height: 480
    visible: true
    id: main_editor
    color: "white"
    property int num_of_headers: 0//this is to hold number of section headers
    property int num_of_subs: 0//this is to hold number of sections for the current header
    property int section_header: 0
    property int subsection_header: 1
    property int section: 2
    property int part: 3
    property int section_margin: 0
    property bool delete_mode: false
    //property bool android: true

    menuBar: MenuBar {
        Menu {
            title: qsTr("&File")
//            MenuItem {
//                text: qsTr("&Open")
//                onTriggered: messageDialog.show(qsTr("Open action triggered"));
//            }
            MenuItem{
                text: qsTr("&Open")
                shortcut: "Ctrl+o"
                onTriggered: {
                    file_dialog.selectExisting=true
                    file_dialog.operation = file_dialog.load_op
                    file_dialog.visible=true
                }
            }
            MenuItem{
                text: qsTr("&Save")
                shortcut: "Ctrl+s"
                onTriggered: {
                    //console.debug(my_file.write("blah blah blah"))
                    file_dialog.selectExisting=false
                    file_dialog.operation = file_dialog.save_op
                    file_dialog.visible=true
                    //console.debug("saved")
                    // console.debug(file_dialog.fileUrls)
                }
            }


            MenuItem {
                text: qsTr("E&xit")
                onTriggered: Qt.quit();
            }
//            MenuItem {
//                text: qsTr("Exit")
//                //onTriggered: Qt.quit();
//            }
        }
        Menu{
            title: qsTr("&Latex")
            MenuItem{
                text: qsTr("Add section header")
                shortcut: "Ctrl+w"
                onTriggered: {
                    //messageDialog.show("show cites")
                    addSectionHeader("header section")
                }
            }
            MenuItem{
                text: qsTr("Add subsection header")
                shortcut: "Ctrl+e"
                onTriggered: {
                    addSubsectionHeader("subsection header")
                }
            }
            MenuItem{
                text: qsTr("Add section")
                shortcut: "Ctrl+r"
                onTriggered: {
                    addSection("section")
                }
            }
            MenuItem{
                text: qsTr("Delete section")
                shortcut: "Ctrl+d"
                onTriggered: {
                    delete_mode= ! delete_mode
                }
            }
        }
        Menu{
            title: qsTr("&About")
            MenuItem{
                text: qsTr("&About")
                onTriggered: {
                    messageDialog.show("This application is developed by A. Alobaid. For more info please contact me on aalobaid@runzbuzz.com")
                }
            }
        }
    }

//    Tools{
//        id: tools
//        visible: false
//    }

    FileIO{
        id: my_file
        source: "" //"/Users/blakxu/workspaces/Qtworkspace/SpringersLatex/my_file.txt"
        onError: console.log("error in fileio")
    }

    FileDialog{
        id: file_dialog
        title: "Please choose a file"
        visible: false
        selectMultiple: false
        property int operation: 2
        property int save_op: 0
        property int load_op: 1
        onAccepted: {
            //console.log("You chose: " + file_dialog.fileUrl)
            my_file.source = file_dialog.fileUrl
            my_file.source = my_file.source.substring(7)
            console.log("You chose: " + my_file.source)
            if(operation==save_op){
              save()
            }
            else if(operation==load_op){
                load()
            }
            else{
                console.debug("Wrong operation")
            }
            //Qt.quit()
        }
        onRejected: {
            console.log("Canceled")
            //Qt.quit()
        }
        selectExisting: false
        //Component.onCompleted: visible = true
    }

    Component.onCompleted: {
        //messageDialog.show("loaded")
//        var w=main_editor.width
//        if(android){
//            w=2000
//            section_margin = 200
//        }
//        addPart("",true,0)
//        addPart("topic",false,w)
//        addPart("authors",false,w)
//        addPart("institute",false,w)
//        addPart("url",false,w)
//        addPart("keywords",false,w)
//        addPart("abstract",false,w-section_margin)
        //v_text,v_readonly,v_width,v_margin
    }

    Text{
        visible: false
        text: "0.00"
        id: section_shift
    }

    Timer{
        interval: 1
        repeat: false
        running: true
        onTriggered: {
            var w=main_editor.width-2*section_shift.width
            section_margin=w
            addPart("",true,0)
            addPart("topic",false,w)
            addPart("authors",false,w)
            addPart("institute",false,w)
            addPart("url",false,w)
            addPart("keywords",false,w)
            addPart("abstract",false,w)
            //messageDialog.show("loaded")
        }
    }

    Component{
        id: section_delegate
        CustomTextEdit{
            text: v_text
            readonly: v_readonly
            width: v_width
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: "times new roman"
            //font.pointSize: 22
            onTextChanged: {
                sections_listmodel.get(index).v_text = text
            }

            Text{
                text: {
                    if (v_type == section_header){
                        return v_sec
                    }
                    else{
                        return v_sec+"."+v_sub
                    }
                }
                anchors.right: parent.left
                visible: v_type == section_header || v_type == subsection_header
            }
            Rectangle{
                color: "red"
                anchors.right: parent.left
                height: parent.height
                width: height
                visible: delete_mode && (v_type == section_header || v_type == subsection_header || v_type == section)
                Text{
                    text: "X"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    color:"white"
                    font.bold: true
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        sections_listmodel.remove(index)
                        delete_mode = false
                    }
                }
            }

            Rectangle{
                id: grr

                //color: "green"
                anchors.left: parent.right
                height: parent.height
                width: height
                Text{
                    text:"^"
                    font.bold: true
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        sections_listmodel.move(index,index-1,1)
                        fix_numbering()
                        console.debug("up")
                    }
                }
            }
            Rectangle{
                //color: "blue"
                anchors.left: grr.right
                height: parent.height
                width: height
                Text{
                    text: "v"
                    font.bold: true
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        sections_listmodel.move(index,index+1,1)
                        fix_numbering()
                        console.debug("down")
                    }
                }
            }
        }
    }



    ListView{
        id: sections_listview
        delegate: section_delegate
        model: sections_listmodel
        anchors.fill: parent
        spacing: 10
        //highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
    }

    ListModel{
        id: sections_listmodel
    }

    function addSectionHeader(v_text){
        num_of_headers+=1
        sections_listmodel.append({"v_readonly": false, "v_width":section_margin, "v_text": v_text,"v_type": section_header, "v_sec": num_of_headers, "v_sub":0 })
        num_of_subs=0
    }

    function addSubsectionHeader(v_text){
        num_of_subs+=1
        sections_listmodel.append({"v_readonly": false, "v_width":section_margin, "v_text": v_text,"v_type": subsection_header,"v_sec": num_of_headers,"v_sub":num_of_subs })
    }

    function addSection(v_text){
        sections_listmodel.append({"v_readonly": false, "v_width":section_margin, "v_text": v_text,"v_type": section, "v_sec": 0, "v_sub": 0 })
    }

    function addPart(v_text,v_readonly,v_width){
        //sections_listmodel.insert()
        sections_listmodel.append({"v_readonly": v_readonly, "v_width":v_width, "v_text": v_text, "v_type": part, "v_sec": 0, "v_sub":0})
    }

    function fix_numbering(){
        num_of_headers=0
        num_of_subs=0
        var ele
        for(var i=1;i<sections_listmodel.count;i++){
            ele = sections_listmodel.get(i)
            if(ele.v_type==section_header){
                num_of_headers+=1
                num_of_subs=0
                ele.v_sec=num_of_headers
            }
            else if (ele.v_type==subsection_header){
                num_of_subs+=1
                ele.v_sub=num_of_subs
                ele.v_sec=num_of_headers
            }
        }
    }

    function getLatexHeader(){
        var v="
\\documentclass[runningheads,a4paper]{llncs}
\\usepackage{amssymb}
\\setcounter{tocdepth}{3}
\\usepackage{graphicx}
\\usepackage{url}
\\urldef{\\mailsa}\\path|"
        v+="a.alobaid@alumnos.upm.es|\n"
        v+="\\newcommand{\\keywords}[1]{\\par\\addvspace\\baselineskip
\\noindent\\keywordname\\enspace\\ignorespaces#1}
\\begin{document}
\\mainmatter\n"
        v+="\\title{"+sections_listmodel.get(1).v_text+"}\n"
        v+="\\author{"+sections_listmodel.get(2).v_text+"}\n"
        v+="\\institute{"+sections_listmodel.get(3).v_text+"\\\\\n\\mailsa\\\\\n"+"\\url{"+ sections_listmodel.get(4).v_text+"}}\n"
        v+="\\maketitle\n\\begin{abstract}\n"+sections_listmodel.get(6).v_text+"\n"+ "\\keywords{"+ sections_listmodel.get(5).v_text + "}"+"\n\\end{abstract}\n"
        return v
    }

    function save(){
        var v="";
        //console.debug(sections_listmodel.count)
        for(var i=7;i<sections_listmodel.count;i++){
            //console.debug(i)
            //console.debug(sections_listmodel.get(i).v_text)
            //v+=sections_listmodel.get(i).v_text+"\n"
            if(sections_listmodel.get(i).v_type == section_header){
                v+="\\section{"+sections_listmodel.get(i).v_text+"}\n"
            }
            else if(sections_listmodel.get(i).v_type == subsection_header){
                v+="\\subsection{"+sections_listmodel.get(i).v_text+"}\n"
            }
            else if(sections_listmodel.get(i).v_type == section){
                v+=sections_listmodel.get(i).v_text+"\n"
            }
            else if(sections_listmodel.get(i).v_type == part){
                v+=sections_listmodel.get(i).v_text+"\n"
            }
            else{
                console.debug("error:"+sections_listmodel.get(i).v_type+sections_listmodel.get(i).v_text)
            }
        }
        v = getLatexHeader()+v+"\\end{document}"
        console.debug(v)
        my_file.write(v)
    }

    function loadInstitute(s){
        var start,end,v,keyw;
        keyw = "\\institute"
        start = s.search(keyw)
        //console.debug("the first start:"+start)
        start = start + keyw.length
        //console.debug("the second start:"+start)
        for(end=start;true;end++){
            if(s.charAt(end)=="\\"){
                //end=end-1;
                break;
            }
        }
        v = s.substring(start,end)
        return v
    }

    function loadVal(s,keyw){
        var start,end,v;
        start = s.search(keyw)
        //console.debug(keyw+"found in "+start)
        start = start + keyw.length
        //console.debug("start: "+start)
        for(end = start;true;end++){
           // console.debug(end)
            if(s.charAt(end)=="}"){
                break;
            }
        }
        v = s.substring(start+1,end)
        return v
    }

    function loadValBetween(s,keyw_start,keyw_end){
        var start,end,v
        start = s.search(keyw_start)
        start = start + keyw_start.length
        end = s.search(keyw_end)
        console.debug(start+" to "+end)
        v = s.substring(start,end)
        return v
    }

    function load_sections(s){
        var start,keyw,sections,subs,sub_i
        keyw = "end{abstract}"
        start = s.search(keyw)
        start = start + keyw.length
        s = s.substring(start,s.length)
        sections = s.split("\\section")
        console.debug("print sections")
        for(var i=1;i<sections.length;i++){
            console.debug(i+" -- "+sections[i]+"\n")
            subs = sections[i].split("\\subsection")
            sub_i=0
            if(subs[0].trim()==""){
                sub_i=1
                console.debug("empty body for the heading")
            }
            else{
                console.debug("heading body:<"+subs[0].trim()+">")
            }
            console.debug("print subsections")
            for(;sub_i<subs.length-1;sub_i++){
                console.debug(subs[sub_i])
                addSection(subs[sub_i])
            }
            console.debug(subs[sub_i])
            addSection(subs[sub_i].substring(0,subs[sub_i].length-14))
        }
    }

    function load(){
        var s,v="",temp_s,i;
        s = my_file.read()
        console.debug(s)
        temp_s = loadVal(s,"title")
        sections_listmodel.get(1).v_text = temp_s
        v+="title:"+temp_s
        temp_s = loadVal(s,"author")
        sections_listmodel.get(2).v_text = temp_s
        v+="\nauthor:"+temp_s
        i = s.search("keywords")
        temp_s = s.substring(i+1,s.length)
        temp_s = loadVal(temp_s,"keywords")
        sections_listmodel.get(5).v_text = temp_s
        v+="\nkeywords:"+temp_s
        temp_s = loadInstitute(s)
        sections_listmodel.get(3).v_text = temp_s
        v+="\ninstite:"+temp_s
        i = s.search("url")
        temp_s = s.substring(i+1,s.length)
        i = s.search("url")
        temp_s = temp_s.substring(i+1,temp_s.length)
        temp_s = loadVal(temp_s,"url")
        sections_listmodel.get(4).v_text = temp_s
        v+="\nurl:"+temp_s
        i = s.search("keywords")
        temp_s = s.substring(i+1,s.length)
        temp_s = loadValBetween(temp_s,"{abstract}","keywords")
        temp_s = temp_s.substring(0,temp_s.length-1)
        sections_listmodel.get(6).v_text = temp_s
        v+="\nabstract:"+temp_s
        console.debug(v)
        load_sections(s)
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
