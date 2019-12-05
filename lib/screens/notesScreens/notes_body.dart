import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotesBody extends StatefulWidget {

  String notesBodyBarTitle;

  NotesBody(this.notesBodyBarTitle);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NotesBodyState(notesBodyBarTitle);
  }
}

class NotesBodyState extends State<NotesBody> {

  String notesBodyBarTitle;

  NotesBodyState(this.notesBodyBarTitle);

  TextEditingController noteTitleController = TextEditingController();
  TextEditingController _noteContentController = TextEditingController();
  TextEditingController _lectureNumberController = TextEditingController();

  final _noteContentFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () {
        navigateToPreviousScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(notesBodyBarTitle),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              navigateToPreviousScreen();
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                debugPrint("User Pressed Save Button");
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                debugPrint("User Pressed Delete Button");
              },
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: getNotesBody(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            debugPrint("FAB Camera pressed");
          },
          tooltip: 'Add Photo',
          child: Icon(Icons.monochrome_photos, color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
    );
  }

  ListView getNotesBody() {
    return ListView(
      children: <Widget>[
        Padding(
          padding:
              EdgeInsets.only(top: 2.0, bottom: 2.0, left: 2.0, right: 2.0),
          child: Text(
            "Last Modified Placeholder",
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.grey,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15.0, right: 10.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                 // margin: EdgeInsets.only(left: 25),
                ),
              ),
              Expanded(
                child: Text(
                  "Lecture",
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: TextField(
                  maxLength: 3,
                  maxLengthEnforced: true,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.numberWithOptions(
                      signed: false, decimal: false),
                  controller: _lectureNumberController,
                  textDirection: TextDirection.rtl,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(3)
                  ],
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      hintText: "999", counter: Offstage()),
                ),
              ),
              Expanded(
                child: Container(
                  //margin: EdgeInsets.only(right: 25),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding:
              EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
          child: TextField(
              controller: noteTitleController,
            style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                  labelText: "Topic",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0))),
              onChanged: (noteTitleValue) {
                debugPrint("User entered $noteTitleValue");
              },
            ),
        ),
        Divider(color: Colors.black54),
        Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: EditableText(
            controller: _noteContentController,
            focusNode: _noteContentFocus,
            maxLines: 1000,
            style: TextStyle(color: Colors.black, fontSize: 20),
            backgroundCursorColor: Colors.black,
            cursorColor: Colors.blue,
            selectionColor: Colors.blueAccent,
            paintCursorAboveText: true,
            onChanged: (noteBodyValue) {
              debugPrint("User entered $noteBodyValue");
            },
          ),
        ),
      ],
    );
  }

  void navigateToPreviousScreen() {
    Navigator.pop(context);
  }
}
