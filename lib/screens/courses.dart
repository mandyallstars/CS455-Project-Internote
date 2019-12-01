import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Courses extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CoursesState();
  }
}

class CoursesState extends State<Courses> {
  final _minimumPadding = 5.0;

  int _coursesCount = 10;

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
        },
        tooltip: 'Add Course',
        child: Icon(Icons.add),
      ),
    );
  }

  Container getCoursesPage() {
    return Container(
      margin: EdgeInsets.all(_minimumPadding * 2),
      child: ListView(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(
                  top: _minimumPadding, bottom: _minimumPadding),
              child: Text(
                "Search Bar Placeholder",
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
              )),
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
          getCoursesList(),
        ],
      ),
    );
  }

  ListView getCoursesList() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: _coursesCount,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.white,
            elevation: 2.5,
            child: ListTile(
              title: Text(
                "Course Title Placeholder",
                style: TextStyle(color: Colors.black),
              ),
              trailing: Icon(Icons.delete, color: Colors.grey),
              onTap: () {
                debugPrint("Course ListTile Tapped");
              },
            ),
          );
        });
  }
}
