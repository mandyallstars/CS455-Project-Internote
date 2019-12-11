import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inter_note/screens/coursesScreens/add_course.dart';

class Courses extends StatefulWidget {
  final String currentUserId;

  Courses({Key key, @required this.currentUserId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    //creates a state of CoursesState with logged in user's ID as argument
    return CoursesState(loggedInUserId: this.currentUserId);
  }
}

class CoursesState extends State<Courses> {
  final String loggedInUserId;

  CoursesState({Key key, @required this.loggedInUserId});

  //varaibe to impelement minimum padding/margin where applicable
  final _minimumPadding = 5.0;

  final TextEditingController _searchBarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses'),
      ),
      body: getCoursesPage(), //creates the body of the course page
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //takes to new form to add course to user's profile for current school
          navigateToAddCourse('Add Course', this.loggedInUserId, 'New');
        },
        tooltip: 'Add Course',
        child: Icon(Icons.add),
      ),
    );
  }

  Container getCoursesPage() {
    return Container(
      margin: EdgeInsets.all(_minimumPadding * 2),
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(this.loggedInUserId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return ListView(
              children: <Widget>[
                searchBar(),
                coursesHeading(),
                //create blank body if there are no courses
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
                //builds a list of courses for user in current school
                getThisSchoolCourseList(document['current_school_id']),
              ],
            );
          }
        },
      ),
    );
  }

  //returns the UI for seach bar
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

  //returns the UI for course heading
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

  //returns the list of courses in user profile for current school
  StreamBuilder getThisSchoolCourseList(String currentSchoolId) {
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
                  //if no courses in users profile for current school
                  //then supposed to return this - does not  work
                  "No Courses added to this School",
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
              //builds each item of the list of courses
              itemBuilder: (context, index) => buildThisSchoolCourseItem(
                  context, snapshot.data.documents[index]));
        }
      },
    );
  }

  //returns a single item of the course in the form of a card
  Card buildThisSchoolCourseItem(
      BuildContext context, DocumentSnapshot document) {
    return Card(
      color: Colors.white,
      elevation: 2.5,
      child: ListTile(
        title: Text(
          document['course_number'],
          style: TextStyle(color: Colors.black),
        ),
        subtitle: Text(
          document['course_name'],
          style: TextStyle(color: Colors.black),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.grey),
          onPressed: () {
            //deletes the course from user's profile for the current school
            deleteCourseForUser(document.documentID);
          },
        ),
        onTap: () {
          //takes user to course form where the user can edit the details of the course
          navigateToAddCourse(
              'Edit Course', this.loggedInUserId, document['course_id']);
        },
      ),
    );
  }

  //function to delete the course from user's profile for current school
  Future<void> deleteCourseForUser(String courseDocumentID) async {
    await Firestore.instance.collection('user_course_info').document(courseDocumentID).delete();
  }

  void navigateToAddCourse(
      String appBarTitle, String loggedInUserId, String courseId) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddCourse(appBarTitle, loggedInUserId, courseId);
    }));
  }
}
