import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:inter_note/screens/notesScreens/notes_list.dart';
import 'package:inter_note/screens/notesScreens/notes_body.dart';

class Notes extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NotesState();
  }
}

class NotesState extends State<Notes> {
  final _minimumPadding = 5.0;

  int _count = 10;

  final TextEditingController _searchBarController = TextEditingController();

  var semesterValue = [
    'Fall 2019',
    'Winter 2020',
    'Spring Summer 2020',
    'Fall 2020',
    'Winter 2021'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: getNotesMainPage(),
    );
  }

  Container getNotesMainPage() {
    return Container(
      margin: EdgeInsets.all(_minimumPadding * 2),
      child: ListView(
        children: <Widget>[
          Padding(
            padding:
                EdgeInsets.only(top: _minimumPadding, bottom: _minimumPadding),
            child: TextField(
              controller: _searchBarController,
              style: TextStyle(fontSize: 15.0),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  prefixIcon: IconButton(
                    icon: Icon(Icons.search),
                  ),
                  suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) => _searchBarController.clear());
                    },
                  ),
                  hintText: "Search...",
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey[300], width: 32.0),
                      borderRadius: BorderRadius.circular(20.0)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey[300], width: 32.0),
                      borderRadius: BorderRadius.circular(20.0))),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
                  top: _minimumPadding, bottom: _minimumPadding),
              child: Text(
                "Courses",
                textAlign: TextAlign.center,
                textDirection: TextDirection.ltr,
                style: TextStyle(
                    fontSize: 40.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              )),
          getSemesterInfo(),
          getNotesList(),
        ],
      ),
    );
  }

  Padding getSemesterInfo() {
    return Padding(
      padding: EdgeInsets.only(
        top: _minimumPadding,
        bottom: _minimumPadding,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Text(
            "Semester",
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            style: TextStyle(
                fontSize: 25.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          )),
          Expanded(
              child: DropdownButton(
            isExpanded: true,
            elevation: 10,
            items: semesterValue.map((String semesterDropDownItem) {
              return DropdownMenuItem<String>(
                value: semesterDropDownItem,
                child: Text(semesterDropDownItem,
                    style: TextStyle(fontSize: 20.0)),
              );
            }).toList(),
            value: 'Fall 2019',
            onChanged: (semesterDropDownItem) {
              setState(() {
                debugPrint("User selected $semesterDropDownItem");
              });
            },
          )),
        ],
      ),
    );
  }

  ListView getNotesList() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: _count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.5,
          child: ListTile(
            title: Text(
              "Title Placeholder",
              style: TextStyle(color: Colors.black),
            ),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue),
            onTap: () {
              debugPrint("ListTile Tapped");
            },
          ),
        );
      },
    );
  }
}
