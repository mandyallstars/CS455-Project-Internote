import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart' as intl;

class NotesBody extends StatefulWidget {
  String notesBodyBarTitle;
  String noteId;
  String courseId;

  NotesBody(this.notesBodyBarTitle, this.noteId, this.courseId);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NotesBodyState(notesBodyBarTitle, this.noteId, this.courseId);
  }
}

class NotesBodyState extends State<NotesBody> {
  String notesBodyBarTitle;
  String noteId;
  String courseId;

  NotesBodyState(this.notesBodyBarTitle, this.noteId, this.courseId);

  TextEditingController _noteTopicController = TextEditingController();
  TextEditingController _noteContentController = TextEditingController();
  TextEditingController _lectureNumberController = TextEditingController();

  var lastModifiedTime = "";

  final _minimumPadding = 5.0;

  final _formKey = GlobalKey<FormState>();

  final _noteContentFocus = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setNoteInfo();
  }

  Future<void> setNoteInfo() async {
    if (this.noteId != 'New') {
      final noteDoc = await Firestore.instance
          .collection('notes')
          .document(this.noteId)
          .get();

      lastModifiedTime = intl.DateFormat('MMM dd, yyyy HH:MM:ss').format(noteDoc['last_modified_time'].toDate());

      _noteTopicController.text = noteDoc['topic'];
      _noteContentController.text = noteDoc['content'];
      _lectureNumberController.text = noteDoc['lecture_no'];
      ;
    }
  }

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
              tooltip: 'Save Note',
              onPressed: () {
                saveThisNote();
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              tooltip: 'Delete Note',
              onPressed: () {
                deleteThisNote();
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
            Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(
              'Camera Functionality Not Implemented',
              textAlign: TextAlign.center,
            )));
          },
          tooltip: 'Add Photo',
          child: Icon(Icons.monochrome_photos, color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
    );
  }

  Container getNotesBody() {
    return Container(
      margin: EdgeInsets.all(_minimumPadding * 2),
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: <Widget>[
          Padding(
            padding:
                EdgeInsets.only(top: 2.0, bottom: 2.0, left: 2.0, right: 2.0),
            child: Text(
              "Last Modified: $lastModifiedTime",
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.grey,
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 10.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            //margin: EdgeInsets.only(left: 25),
                            ),
                      ),
                      Expanded(
                        child: Text(
                          "Lecture # ",
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
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
                          validator: (value) {
                            if (value.isEmpty) {
                              return '*Required';
                            }
                          },
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
                  padding: EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                  child: TextFormField(
                    maxLength: 50,
                    maxLengthEnforced: true,
                    controller: _noteTopicController,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        labelText: "Topic",
                        counter: Offstage(),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0))),
                    validator: (value) {
                      if (value.isEmpty) {
                        return '*Required';
                      }
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
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> saveThisNote() async {
    if (_formKey.currentState.validate()) {
      if (this.noteId == 'New') {
        QuerySnapshot doesSameNoteExist = await Firestore.instance
            .collection('notes')
            .where('lecture_no', isEqualTo: _lectureNumberController.text)
            .where('topic', isEqualTo: _noteTopicController.text)
            .getDocuments();

        final List<DocumentSnapshot> doesSameNoteExistDoc =
            doesSameNoteExist.documents;

        if (doesSameNoteExistDoc.length == 0) {

          Firestore.instance.collection('notes').add({
            'course_id': this.courseId,
            'lecture_no': _lectureNumberController.text,
            'topic': _noteTopicController.text,
            'content': _noteContentController.text,
            'last_modified_time': DateTime.now()
          });
        } else {
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
            'Note for same lecture and topic exists.',
            textAlign: TextAlign.center,
          )));
        }
      } else {
        QuerySnapshot hasNoteChanged = await Firestore.instance
            .collection('notes')
            .where('course_id', isEqualTo: this.courseId)
            .where('lecture_no', isEqualTo: _lectureNumberController.text)
            .where('topic', isEqualTo: _noteTopicController.text)
            .where('content', isEqualTo: _noteContentController.text)
            .getDocuments();

        final List<DocumentSnapshot> hasNoteChangedDoc =
            hasNoteChanged.documents;
        if (hasNoteChangedDoc.length == 0) {

          Firestore.instance
              .collection('notes')
              .document(this.noteId)
              .updateData({
            'lecture_no': _lectureNumberController.text,
            'topic': _noteTopicController.text,
            'content': _noteContentController.text,
            'last_modified_time': DateTime.now()
          });
        } else {
          Navigator.of(context).pop();
        }
      }
      Navigator.of(context).pop();
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
        'Enter Valid Values',
        textAlign: TextAlign.center,
      )));
    }
  }

  Future<void> deleteThisNote() async {
    if (this.courseId == 'New') {
      Navigator.of(context).pop();
    } else {
      await Firestore.instance
          .collection('notes')
          .document(this.noteId)
          .delete();
      Navigator.of(context).pop();
    }
  }

  void navigateToPreviousScreen() {
    Navigator.pop(context);
  }
}
