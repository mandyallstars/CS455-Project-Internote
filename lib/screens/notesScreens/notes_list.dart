import 'package:flutter/material.dart';
import 'package:inter_note/screens/notes.dart';
import 'notes_body.dart';

class NotesList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NotesListState();
  }
}

class NotesListState extends State<NotesList> {
  int notesCount = 10;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Course Title Placeholder"),
      ),
      body: getNotesList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint("FAB pressed");
        },
        tooltip: 'Add Note',
        child: Icon(Icons.add),
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
            },
          ),
        );
      },
    );
  }
}
