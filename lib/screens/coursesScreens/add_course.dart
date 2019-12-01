import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AddCourse extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddCourseState();
  }
}

class AddCourseState extends State<AddCourse> {

  final _minimumPadding = 5.0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Course"),
      ),
      body: getCourseAddForm(),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text('Add Course'),
        onPressed: () {
          debugPrint("Add Course Button Pressed");
        },
      ),
    );
  }

  Container getCourseAddForm() {
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
            child: Form(

            ),
          )
        ],
      ),
    );
  }
}
