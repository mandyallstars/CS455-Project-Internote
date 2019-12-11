import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inter_note/screens/notesScreens/notes_body.dart';
import 'package:intl/intl.dart' as intl;

class NotesList extends StatefulWidget {

  String appBarTitle;
  String courseId;

  NotesList(this.appBarTitle, this.courseId);

  @override
  State<StatefulWidget> createState() {
    //creates a state of the NotesListState with course ID as argument
    return NotesListState(appBarTitle, this.courseId);
  }
}

class NotesListState extends State<NotesList> {

  String appBarTitle;
  String courseId;

  NotesListState(this.appBarTitle, this.courseId);

  //variabe to impelement minimum padding/margin where applicable
  final _minimumPadding = 5.0;

  final TextEditingController _searchBarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () {
        navigateToPreviousScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              navigateToPreviousScreen();
            },
          ),
        ),
        body: getNotesList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //takes user to the notes body page to add a new note to this course
            navigateToNotesBody('New Note', 'New', this.courseId);
          },
          tooltip: 'Add Note',
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  //creates a list of notes for this course
  Container getNotesList() {
    return Container(
      margin: EdgeInsets.all(_minimumPadding * 2),
      child: StreamBuilder(
        stream: Firestore.instance.collection('notes').where('course_id', isEqualTo: this.courseId).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                children: <Widget>[
                  searchBar(),
                  notesHeading(),
                  ListTile(
                    title: Text(
                      //supposed to show this if there are not notes in this course but does not work
                      "Add Notes to this course",
                      style: TextStyle(color: Colors.blueGrey, fontSize: 15.0),
                      textDirection: TextDirection.ltr,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              );
            } else {
              return ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                children: <Widget>[
                  searchBar(),
                  notesHeading(),
                  ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: snapshot.data.documents.length,
                  //builds the  list of notes for this course
                  itemBuilder: (context, index) =>
                      buildNotesItem(context, snapshot.data.documents[index])),
                ],
              );
            }
          }
      ),
    );
  }

  //returns the UI for the search bar
  //search bar is not working
  Padding searchBar() {
    return Padding(
      padding: EdgeInsets.only(top: _minimumPadding, bottom: _minimumPadding),
      child: TextField(
        controller: _searchBarController,
        style: TextStyle(fontSize: 15.0),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            prefixIcon: Icon(Icons.search),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => _searchBarController.clear());
              },
            ),
            hintText: "Search...",
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 32.0),
                borderRadius: BorderRadius.circular(20.0)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300], width: 32.0),
                borderRadius: BorderRadius.circular(20.0))),
      ),
    );
  }

  //returns the Notes heading UI element
  Padding notesHeading() {
    return Padding(
        padding: EdgeInsets.only(top: _minimumPadding, bottom: _minimumPadding),
        child: Text(
          "Notes",
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
          style: TextStyle(
              fontSize: 40.0, color: Colors.black, fontWeight: FontWeight.bold),
        ));
  }

  //returns a single item of note card in the notes list
  Card buildNotesItem(BuildContext context, DocumentSnapshot document) {

    //varaible to store the card title
    var noteTitle = "Lecture " + document['lecture_no'] + " - " + document['topic'];

    //parses the timestamp information retrieved from firestore
    //showed in the card subtitle
    String lastModifiedTime = intl.DateFormat('MMM dd, yyyy HH:MM:ss').format(document['last_modified_time'].toDate());

    return Card(
      color: Colors.white,
      elevation: 2.5,
      child: ListTile(
        title: Text(
          noteTitle,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        subtitle: Text(
          lastModifiedTime,
          style: TextStyle(color: Colors.black, fontSize: 13),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.grey),
          onPressed: () {
            //note is removed from this course if the delete button is tapped
            deleteThisNote(document.documentID);
          },
        ),
        onTap: () {
          //user is taken to the notes body page for the note when user taps on a card
          navigateToNotesBody(
              noteTitle, document.documentID, this.courseId);
        },
      ),
    );
  }

  //function to delete the note from course
  Future<void> deleteThisNote(String noteDocumentID) async {
    await Firestore.instance.collection('notes').document(noteDocumentID).delete();
  }

  //function to navigate to note body page with note ID and course ID as argument
  void navigateToNotesBody(String notesBodyBarTitle, String noteId, String courseId) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NotesBody(notesBodyBarTitle, noteId, courseId);
    }));
  }

  void navigateToPreviousScreen() {
    Navigator.pop(context);
  }
}
