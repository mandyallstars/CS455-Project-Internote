import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inter_note/screens/coursesScreens/add_course.dart';

class Courses extends StatefulWidget {

  final String currentUserId;

  Courses({Key key, @required this.currentUserId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CoursesState(loggedInUserId: this.currentUserId);
  }
}

class CoursesState extends State<Courses> {

  final String loggedInUserId;

  CoursesState({Key key, @required this.loggedInUserId});

  final _minimumPadding = 5.0;

  int _coursesCount = 10;

  final TextEditingController _searchBarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('Courses'),
        ),
        body: getCoursesPage(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            debugPrint("FAB pressed");
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
                getThisSchoolCourseList(document['current_school_id']),
              ],
            );
          }
        },
      ),
    );
  }

  Padding searchBar() {
    return Padding(
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
                WidgetsBinding.instance.addPostFrameCallback(
                        (_) => _searchBarController.clear());
              },
            ),
            hintText: "Search...",
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 32.0),
                borderRadius: BorderRadius.circular(20.0)),
            focusedBorder: OutlineInputBorder(
                borderSide:
                BorderSide(color: Colors.grey[300], width: 32.0),
                borderRadius: BorderRadius.circular(20.0))),
      ),
    );
  }

  Padding coursesHeading() {
    return Padding(
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
        ));
  }

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
              itemBuilder: (context, index) =>
                  buildThisSchoolCourseItem(context, snapshot.data.documents[index]));
        }
      },
    );
  }

  Card buildThisSchoolCourseItem(BuildContext context, DocumentSnapshot document) {
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
              trailing: Icon(Icons.delete, color: Colors.grey),
              onTap: () {
                navigateToAddCourse('Edit Course', this.loggedInUserId, document['course_id']);
              },
            ),
          );
  }

  void navigateToAddCourse(String appBarTitle, String loggedInUserId, String courseId) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddCourse(appBarTitle, loggedInUserId, courseId);
    }));
  }

}


//  Container getCoursesPage() {
//    return Container(
//      margin: EdgeInsets.all(_minimumPadding * 2),
//      child: ListView(
//        children: <Widget>[
//          Padding(
//            padding:
//                EdgeInsets.only(top: _minimumPadding, bottom: _minimumPadding),
//            child: TextField(
//              controller: _searchBarController,
//              style: TextStyle(fontSize: 15.0),
//              decoration: InputDecoration(
//                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//                  prefixIcon: IconButton(
//                    icon: Icon(Icons.search),
//                  ),
//                  suffixIcon: IconButton(
//                    icon: Icon(Icons.clear),
//                    onPressed: () {
//                      WidgetsBinding.instance.addPostFrameCallback(
//                          (_) => _searchBarController.clear());
//                    },
//                  ),
//                  hintText: "Search...",
//                  border: OutlineInputBorder(
//                      borderSide: BorderSide(color: Colors.white, width: 32.0),
//                      borderRadius: BorderRadius.circular(20.0)),
//                  focusedBorder: OutlineInputBorder(
//                      borderSide:
//                          BorderSide(color: Colors.grey[300], width: 32.0),
//                      borderRadius: BorderRadius.circular(20.0))),
//            ),
//          ),
//          Padding(
//              padding: EdgeInsets.only(
//                  top: _minimumPadding, bottom: _minimumPadding),
//              child: Text(
//                "Courses",
//                textAlign: TextAlign.center,
//                textDirection: TextDirection.ltr,
//                style: TextStyle(
//                    fontSize: 40.0,
//                    color: Colors.black,
//                    fontWeight: FontWeight.bold),
//              )),
//          getThisSchoolCourseList(),
//        ],
//      ),
//    );
//  }

//
//  ListView getCoursesList() {
//    return ListView.builder(
//        scrollDirection: Axis.vertical,
//        shrinkWrap: true,
//        physics: ScrollPhysics(),
//        itemCount: _coursesCount,
//        itemBuilder: (BuildContext context, int position) {
//          return Card(
//            color: Colors.white,
//            elevation: 2.5,
//            child: ListTile(
//              title: Text(
//                "Course Title Placeholder",
//                style: TextStyle(color: Colors.black),
//              ),
//              trailing: Icon(Icons.delete, color: Colors.grey),
//              onTap: () {
//                debugPrint("Course ListTile Tapped");
//                navigateToAddCourse('Edit Course');
//              },
//            ),
//          );
//        });
//  }

//    stream: Firestore.instance
//        .collection('users')
//        .document(this.currentUserId)
//        .snapshots();
//    return Container(
//      child: StreamBuilder(
//          stream: Firestore.instance
//              .collection('user_course_info')
//              .where('user_id', isEqualTo: this.currentUserId)
//              .where('school_id', isEqualTo: currentSchoolID)
//              .snapshots(),
//          builder: (context, snapshot) {
//            if (!snapshot.hasData) {
//              return ListView(
//                scrollDirection: Axis.vertical,
//                shrinkWrap: true,
//                physics: ScrollPhysics(),
//                children: <Widget>[
//                  ListTile(
//                    title: Text(
//                      "Add courses to this school in Courses tab",
//                      style: TextStyle(color: Colors.black, fontSize: 15.0),
//                      textDirection: TextDirection.ltr,
//                      softWrap: true,
//                      overflow: TextOverflow.ellipsis,
//                    ),
//                  )
//                ],
//              );
//            } else {
//              return ListView.builder(
//                  scrollDirection: Axis.vertical,
//                  shrinkWrap: true,
//                  physics: ScrollPhysics(),
//                  itemCount: snapshot.data.documents.length,
//                  itemBuilder: (context, index) =>
//                      buildCourseItem(context, snapshot.data.documents[index]));
//            }
//          }),
//    );
