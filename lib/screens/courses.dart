import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:inter_note/screens/coursesScreens/add_course.dart';

class Courses extends StatefulWidget {

  final String currentUserId;

  Courses({Key key, @required this.currentUserId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CoursesState(currentUserId: this.currentUserId);
  }
}

class CoursesState extends State<Courses> {

  final String currentUserId;

  CoursesState({Key key, @required this.currentUserId});

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
            navigateToAddCourse('Add Course');
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
                navigateToAddCourse('Edit Course');
              },
            ),
          );
        });
  }

  void navigateToAddCourse(String appBarTitle) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddCourse(appBarTitle);
    }));
  }

}
