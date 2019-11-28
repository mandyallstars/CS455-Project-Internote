import 'package:flutter/material.dart';
import 'placeholder_widget.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    PlaceholderWidget(Colors.white),
    PlaceholderWidget(Colors.deepOrange),
    PlaceholderWidget(Colors.green)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Flutter App'),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
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


  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

}


