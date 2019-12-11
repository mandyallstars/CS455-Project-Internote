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
    //creates a state of NoteBodyState with note ID and course ID as argument
    return NotesBodyState(notesBodyBarTitle, this.noteId, this.courseId);
  }
}

class NotesBodyState extends State<NotesBody> {
  String notesBodyBarTitle;
  String noteId;
  String courseId;

  NotesBodyState(this.notesBodyBarTitle, this.noteId, this.courseId);

  //controllers to retrieve information entered by user
  TextEditingController _noteTopicController = TextEditingController();
  TextEditingController _noteContentController = TextEditingController();
  TextEditingController _lectureNumberController = TextEditingController();

  var lastModifiedTime = "";

  //variabe to impelement minimum padding/margin where applicable
  final _minimumPadding = 5.0;

  //global key for the form used in this page
  final _formKey = GlobalKey<FormState>();

  final _noteContentFocus = FocusNode();

  //called when the page is created
  @override
  void initState() {
    super.initState();
    //sets the note info the the data retrieved from firestore for the note
    setNoteInfo();
  }

  //function to initialize the form elements with the note info is the user
  //is trying to edit a note that already exists
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
                //save icon to save the note
                saveThisNote();
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              tooltip: 'Delete Note',
              onPressed: () {
                //delete icon to delete the note
                deleteThisNote();
                navigateToPreviousScreen();
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
            //floating button for clicking photo
            //functionality not implemented
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

  //returns the UI of the Notes Body
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
              //shows the last modified time for the note
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
                          softWrap: false,
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          //to get lecture number for which the note is being created
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
                            //lecture number cannot be left empty
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
                    //for the topic of the note
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
                        //topic cannot be left empty
                        return '*Required';
                      }
                    },
                  ),
                ),
                Divider(color: Colors.black54),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: EditableText(
                    //content can be left empty - if the user wants to add the content later
                    //or hopes for other to add to it
                    controller: _noteContentController,
                    focusNode: _noteContentFocus,
                    maxLines: null,
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

  //function to save the note
  Future<void> saveThisNote() async {
    if (_formKey.currentState.validate()) {

      //if the form is validated as required, run the following code

      if (this.noteId == 'New') {

        //if the user is creating a new note by tapping on + floating button on notes_list page,
        //then run the following code

        //query to check if the note with same lecture number and topic exists
        QuerySnapshot doesSameNoteExist = await Firestore.instance
            .collection('notes')
            .where('lecture_no', isEqualTo: _lectureNumberController.text)
            .where('course_id', isEqualTo: this.courseId)
            .where('topic', isEqualTo: _noteTopicController.text)
            .getDocuments();

        final List<DocumentSnapshot> doesSameNoteExistDoc =
            doesSameNoteExist.documents;

        if (doesSameNoteExistDoc.length == 0) {

          //if no note for this course exists with same topic or lecture number,
          //then add the note to the notes collection

          Firestore.instance.collection('notes').add({
            'course_id': this.courseId,
            'lecture_no': _lectureNumberController.text,
            'topic': _noteTopicController.text,
            'content': _noteContentController.text,
            'last_modified_time': DateTime.now()
          });

          //go back to notes list after adding the note
          Navigator.of(context).pop();
        } else {

          //if the note for this course already exists with same lecture number and topic,
          //then indicate to user
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
            'Note for same lecture and topic exists.',
            textAlign: TextAlign.center,
          )));
        }
      } else {

        //following code is run if user is editing an existing note for this course

        //query to check if anything has changed in the note that the user is editing
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

          //if something has changed, then update the existing note
          Firestore.instance
              .collection('notes')
              .document(this.noteId)
              .updateData({
            'lecture_no': _lectureNumberController.text,
            'topic': _noteTopicController.text,
            'content': _noteContentController.text,
            'last_modified_time': DateTime.now()
          });

          //navigate back to note list after updating the note
          Navigator.of(context).pop();

        } else {

          //if nothing has changed, then just navigate back to the note list
          Navigator.of(context).pop();

        }
      }
    } else {
      //if the form is not validated as required, indicate to user
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
        'Enter Valid Values',
        textAlign: TextAlign.center,
      )));
    }
  }

  //function to delete the note
  Future<void> deleteThisNote() async {

    //only need to delete the note if it is not a new note
    if(this.courseId != 'New') {
      await Firestore.instance
          .collection('notes')
          .document(this.noteId)
          .delete();
    }
  }

  void navigateToPreviousScreen() {
    Navigator.of(context).pop();
  }
}
