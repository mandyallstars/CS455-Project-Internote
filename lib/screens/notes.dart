import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:inter_note/screens/notesScreens/notes_list.dart';
import 'package:inter_note/screens/notesScreens/notes_body.dart';

class Notes extends StatefulWidget {

  const Notes({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NotesState();
  }
}

class NotesState extends State<Notes> {
  final _minimumPadding = 5.0;

  int _count = 10;

  final TextEditingController _searchBarController = TextEditingController();
  final TextEditingController _semesterYearController = TextEditingController();

  var semesterValue = [
    'Fall',
    'Winter',
    'Spring Summer',
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
      padding: EdgeInsets.fromLTRB(_minimumPadding * 3, _minimumPadding, _minimumPadding * 3, _minimumPadding),
      child: Row(
        children: <Widget>[
          Expanded(
              child: DropdownButton(
            isExpanded: true,
            elevation: 10,
            iconEnabledColor: Colors.black,
            items: semesterValue.map((String semesterDropDownItem) {
              return DropdownMenuItem<String>(
                value: semesterDropDownItem,
                child: Text(semesterDropDownItem,
                    style: TextStyle(fontSize: 20.0)),
              );
            }).toList(),
            hint: Text('Semester', style: TextStyle(fontSize: 20)),
            onChanged: (semesterDropDownItem) {
              setState(() {
                debugPrint("User selected $semesterDropDownItem");
              });
            },
          )),
          Container(
            padding: EdgeInsets.only(
                left: _minimumPadding * 2,
                right: _minimumPadding * 2),
          ),
          Expanded(
            child: TextFormField(
              maxLength: 4,
              maxLengthEnforced: true,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.numberWithOptions(
                  signed: false, decimal: false),
              controller: _semesterYearController,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                  labelText: "Year E.g. 2019",
                  counter: Offstage()),
            ),
          ),
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
              navigateToNotesList('This Course Title');
            },
          ),
        );
      },
    );
  }

  void navigateToNotesList(String appBarTitle) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NotesList(appBarTitle);
    }));
  }

}
