import 'package:flutter/material.dart';
import 'package:inter_note/screens/profile.dart';
import 'package:inter_note/screens/courses.dart';
import 'package:inter_note/screens/notes.dart';


class NavigationStack extends StatefulWidget {
  const NavigationStack ({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  State<StatefulWidget> createState() {

    //creates a navigationStackState with the page as it's argument
    return NavigationStackState(this.child);
  }

}

class NavigationStackState extends State<NavigationStack> {

  Widget pageName;

  NavigationStackState(this.pageName);


  @override
  Widget build(BuildContext context) {
    //creates a navigation stack for the page passed as argument
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

  final String currentUserId;

  HomePage({Key key, @required this.currentUserId}) : super(key: key);

  @override
  //create state of HomePageState with the logged in user ID
  _HomePageState createState() => _HomePageState(currentUserId: this.currentUserId);
}

class _HomePageState extends State<HomePage> {

  final String currentUserId;
  _HomePageState({Key key, @required this.currentUserId});

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //index to store the currently selected item in bottom navigation bar
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          //create an indexed stack to handle navigation with bottom navigation bar
          child: IndexedStack(
            index: _currentIndex,
            children: <Widget>[
              //generate the body depending on which item is selected
              //in bottom navigation bar
              NavigationStack(child: Profile(currentUserId: this.currentUserId)),
              NavigationStack(child: Courses(currentUserId: this.currentUserId)),
              NavigationStack(child: Notes(currentUserId: this.currentUserId)),
            ],
          ),
        ),
        //UI for bottom navigation bar
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
