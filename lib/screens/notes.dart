import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inter_note/screens/notesScreens/notes_list.dart';

class Notes extends StatefulWidget {
  final String currentUserId;

  Notes({Key key, @required this.currentUserId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    //creates a state of NotesState with logged in user's ID as argument
    return NotesState(loggedInUserId: this.currentUserId);
  }
}

class NotesState extends State<Notes> {
  final String loggedInUserId;

  NotesState({Key key, @required this.loggedInUserId});

  //variabe to impelement minimum padding/margin where applicable
  final _minimumPadding = 5.0;

  //controllers for form elements in this page UI
  final TextEditingController _searchBarController = TextEditingController();
  final TextEditingController _semesterYearController = TextEditingController();

  var semesterValue;

  //variable to store current school ID
  var currentSchoolId;

  //array for semester drop dow
  var _semesterArray = [
    'Fall',
    'Winter',
    'Spring Summer',
  ];

  @override
  void initState() {
    super.initState();
    //user's current school ID is initialized when the page is rendered
    getCurrentSchoolId();
  }

  //function to initialize the currentSchoolID for the user
  Future<void> getCurrentSchoolId() async {
    final currentUserDoc = await Firestore.instance
        .collection('users')
        .document(this.loggedInUserId)
        .get();

    currentSchoolId = currentUserDoc['current_school_id'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: getNotesMainPage(),
    );
  }

  //creates the body for the page
  Container getNotesMainPage() {
    return Container(
      margin: EdgeInsets.all(_minimumPadding * 2),
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(this.loggedInUserId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            //return blank page with basic elements if there is no data for user
            return ListView(
              children: <Widget>[
                searchBar(),
                coursesHeading(),
                Container(
                  color: Colors.white,
                )
              ],
            );
          } else {
            DocumentSnapshot document = snapshot.data;
            return ListView(
              children: <Widget>[
                searchBar(),
                coursesHeading(),
                //creates a list of courses for user for the current school
                thisSemesterUserCourseList(document['current_school_id']),
              ],
            );
          }
        },
      ),
    );
  }

  //creates search bar UI
  //search bar does not work
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

  //creates course heading UI element
  Padding coursesHeading() {
    return Padding(
        padding: EdgeInsets.only(top: _minimumPadding, bottom: _minimumPadding),
        child: Text(
          "Courses",
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
          style: TextStyle(
              fontSize: 40.0, color: Colors.black, fontWeight: FontWeight.bold),
        ));
  }

  //widget to create a drop down and text field to get semester info from user
  //Removed from UI because it was not working
  Padding getSemesterInfo() {
    return Padding(
      padding: EdgeInsets.fromLTRB(_minimumPadding * 3, _minimumPadding,
          _minimumPadding * 3, _minimumPadding),
      child: Row(
        children: <Widget>[
          Expanded(
              child: DropdownButton(
            value: semesterValue,
            isExpanded: true,
            elevation: 10,
            iconEnabledColor: Colors.black,
            items: _semesterArray.map((String semesterDropDownItem) {
              return DropdownMenuItem<String>(
                value: semesterDropDownItem,
                child: Text(semesterDropDownItem,
                    style: TextStyle(fontSize: 20.0)),
              );
            }).toList(),
            hint: Text('Semester', style: TextStyle(fontSize: 20)),
            onChanged: (semesterDropDownItem) {
              setState(() {
                semesterValue = semesterDropDownItem;
              });
            },
          )),
          Container(
            padding: EdgeInsets.only(
                left: _minimumPadding * 2, right: _minimumPadding * 2),
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
                  labelText: "Year E.g. 2019", counter: Offstage()),
            ),
          ),
        ],
      ),
    );
  }

  //function to create a list of courses in user's profile for current school
  StreamBuilder thisSemesterUserCourseList(String currentSchoolId) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('user_course_info')
          .where('user_id', isEqualTo: this.loggedInUserId)
          .where('school_id', isEqualTo: currentSchoolId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            children: <Widget>[
              ListTile(
                title: Text(
                  //supposed to show if there are no courses but not working
                  "No Courses added to this school",
                  style: TextStyle(color: Colors.blueGrey, fontSize: 15.0),
                  textDirection: TextDirection.ltr,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          );
        } else {
          return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: snapshot.data.documents.length,
              //build items in courses list
              itemBuilder: (context, index) => buildThisSchoolCourseItem(
                  context, snapshot.data.documents[index]));
        }
      },
    );
  }

  //returns a single item in the courses list
  Card buildThisSchoolCourseItem(
      BuildContext context, DocumentSnapshot document) {
    return Card(
      color: Colors.white,
      elevation: 2.5,
      child: ListTile(
        title: Text(
          document['course_number'],
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        subtitle: Text(
          document['course_name'],
          style: TextStyle(color: Colors.black, fontSize: 13),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue),
        onTap: () {
          //takes to the list of notes for this course when user taps on course card
          navigateToNotesList(
              document['course_number'], document['course_id']);
        },
      ),
    );
  }

  void navigateToNotesList(String appBarTitle, String courseId) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NotesList(appBarTitle, courseId);
    }));
  }
}
