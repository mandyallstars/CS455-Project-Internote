import 'package:flutter/material.dart';
import 'package:inter_note/screens/profile.dart';
import 'package:inter_note/screens/courses.dart';
import 'package:inter_note/screens/notes.dart';
import 'package:inter_note/screens/notesScreens/notes_body.dart';
import 'package:inter_note/screens/notesScreens/notes_list.dart';
import 'package:inter_note/screens/profileScreens/school_select.dart';
import 'package:inter_note/screens/coursesScreens/add_course.dart';
import 'package:inter_note/loginpage.dart';


class NavigationStack extends StatefulWidget {
  const NavigationStack ({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NavigationStackState(this.child);
  }
}

class NavigationStackState extends State<NavigationStack> {

  Widget pageName;

  NavigationStackState(this.pageName);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Navigator(
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              settings: settings,
              builder: (BuildContext context) {
                return this.pageName;
              }
          );
        },
      );
  }

}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: IndexedStack(
            index: _currentIndex,
            children: <Widget>[
              NavigationStack(child: LoginPage()),
              NavigationStack(child: Courses()),
              NavigationStack(child: Notes()),
            ],
          ),
        ),
        //body: callPage(_currentIndex),
        //body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.person),
              title: new Text("Profile"),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.library_books),
              title: new Text("Courses"),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.description),
              title: new Text("Notes"),
            ),
          ],
        ),
      );
  }

}
