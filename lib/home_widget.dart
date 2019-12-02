import 'package:flutter/material.dart';
import 'package:inter_note/screens/profile.dart';
import 'package:inter_note/screens/courses.dart';
import 'package:inter_note/screens/notes.dart';
import 'package:inter_note/screens/notesScreens/notes_body.dart';
import 'package:inter_note/screens/notesScreens/notes_list.dart';
import 'package:inter_note/screens/profileScreens/school_select.dart';
import 'package:inter_note/screens/coursesScreens/add_course.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin<HomePage> {
  int _currentIndex = 0;

  Widget callPage(int currentIndex) {
    switch(currentIndex) {
      case 0: return Profile();
      case 1: return AddCourse();
      case 2: return Notes();

      break;
      default: return Notes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: callPage(_currentIndex),
      //body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          _currentIndex = index;
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.person),
            title: new Text("Profile"),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.library_books),
            title: new Text("Courses"),
          ),BottomNavigationBarItem(
            icon: new Icon(Icons.description),
            title: new Text("Notes"),
          ),
        ],
      ),
    );
  }
}