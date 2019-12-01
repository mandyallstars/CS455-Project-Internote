import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProfileState();
  }
}

class ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: getProfilePage(),
    );
  }

  Container getProfilePage() {
    return Container(
      
    );
  }
}