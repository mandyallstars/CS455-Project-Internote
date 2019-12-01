import 'package:flutter/material.dart';
import 'stack_index.dart';
import 'package:inter_note/screens/profile.dart';
import 'package:inter_note/screens/courses.dart';
import 'package:inter_note/screens/notes.dart';
import 'package:inter_note/screens/notesScreens/notes_body.dart';
import 'package:inter_note/screens/notesScreens/notes_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin<HomePage> {
  int _currentIndex = 0;

  Widget callPage(int currentIndex) {
    switch(currentIndex) {
      case 0: return Profile();
      case 1: return Courses();
      case 2: return NotesList();

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
            icon: new Icon(Icons.school),
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