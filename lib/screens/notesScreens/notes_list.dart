import 'package:flutter/material.dart';
import 'package:inter_note/screens/notes.dart';
import 'package:inter_note/screens/notesScreens/notes_body.dart';

class NotesList extends StatefulWidget {

  String appBarTitle;

  NotesList(this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NotesListState(appBarTitle);
  }
}

class NotesListState extends State<NotesList> {

  String appBarTitle;

  NotesListState(this.appBarTitle);

  int notesCount = 10;

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
            debugPrint("FAB pressed");
            navigateToNotesBody('New Note');
          },
          tooltip: 'Add Note',
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  ListView getNotesList() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: notesCount,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.5,
          child: ListTile(
            title: Text("Notes Title Placeholder"),
            subtitle: Text("Notes Subtitle Placeholder"),
            trailing: Icon(
              Icons.delete,
              color: Colors.grey,
            ),
            onTap: () {
              debugPrint("Notes Card Tapped");
              navigateToNotesBody('Note Title');
            },
          ),
        );
      },
    );
  }

  void navigateToNotesBody(String notesBodyBarTitle) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NotesBody(notesBodyBarTitle);
    }));
  }

  void navigateToPreviousScreen() {
    Navigator.pop(context);
  }
}
