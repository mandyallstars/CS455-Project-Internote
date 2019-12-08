import 'dart:async';
import 'dart:async' as prefix1;
import 'dart:convert';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:inter_note/screens/profileScreens/school_select.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inter_note/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  final String currentUserId;

  Profile({Key key, @required this.currentUserId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProfileState(currentUserId: this.currentUserId);
  }
}

class ProfileState extends State<Profile> {
  final String currentUserId;

  ProfileState({Key key, @required this.currentUserId});

  final GoogleSignIn googleSignIn = GoogleSignIn();

  final _minimumPadding = 5.0;

  //final TextEditingController _nameController = TextEditingController();
  FocusNode _nameFocusNode;

  int _thisSchoolCoursesCount = 10;

  bool isLoading = false;

//  @override
//  void initState() {
//    super.initState();
//  }

//  @override
//  void dispose() {
//    // Clean up the focus node when the Form is disposed.
//    _nameFocusNode.dispose();
//
//    super.dispose();
//  }

  Future<Null> handleSignOut() async {
    this.setState(() {
      isLoading = true;
    });

    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();

    this.setState(() {
      isLoading = false;
    });

    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: <Widget>[
          InkResponse(
              onTap: () {
                handleSignOut();
                ;
              },
              child: new Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.exit_to_app, size: 30),
                      Container(
                        margin: EdgeInsets.only(left: _minimumPadding),
                      ),
                      Center(
                        child: Text("Sign Out", style: TextStyle(fontSize: 20)),
                      ),
                    ],
                  ))),
        ],
      ),
      body: getProfilePage(),
    );
  }

  Container getProfilePage() {
    return Container(
      margin: EdgeInsets.all(_minimumPadding * 2),
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(this.currentUserId)
            .snapshots(),
        //stream: Firestore.instance.collection('users').where('id', isEqualTo: this.currentUserId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          } else {
            DocumentSnapshot document = snapshot.data;
            String userDisplayName = document['displayname'];
            return ListView(
              children: <Widget>[
                Material(
                  child: document['photoUrl'] != null
                      ? CachedNetworkImage(
                          placeholder: (context, url) => Container(
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.0,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blue),
                                ),
                                width: 125,
                                height: 125,
                                padding: EdgeInsets.all(15.0),
                              ),
                          imageUrl: document['photoUrl'],
                          width: 125,
                          height: 125)
                      : getProfileImageAsset(),
                ),
                //getProfileImageAsset(),
                Divider(color: Colors.black54),
                TextFormField(
                  initialValue: userDisplayName,
                  focusNode: _nameFocusNode,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      labelText: "Name",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () =>
                            FocusScope.of(context).requestFocus(_nameFocusNode),
                      )),
                  onChanged: (nameValue) {
                    Firestore.instance
                        .collection('users')
                        .document(this.currentUserId)
                        .updateData({
                      'displayname': nameValue,
                    });
                  },
                ),
                Divider(color: Colors.white),
                getCurrentSchoolInfo(),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: Text(
                      "Courses",
                      textAlign: TextAlign.left,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                          fontSize: 40.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    )),
                getThisSchoolCourses()
              ],
            );
          }
        },
      ),
    );
  }

  InkWell getCurrentSchoolInfo() {
    return InkWell(
      customBorder: Border(
          top: BorderSide(width: 5.0, color: Colors.black),
          bottom: BorderSide(width: 5.0, color: Colors.black)),
      child: Container(
        child: Padding(
          padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.school,
                size: 20,
              ),
              Container(
                margin: EdgeInsets.only(left: _minimumPadding * 2),
                child: Text(
                  "School",
                  style: TextStyle(color: Colors.black, fontSize: 25),
                  textDirection: TextDirection.ltr,
                ),
              ),
              Expanded(
                  child: Container(
                margin: EdgeInsets.only(right: _minimumPadding * 2),
                child: FutureBuilder(
                  future: getSchoolName(),
                  initialData: "Add School",
                  builder: (BuildContext context, AsyncSnapshot<String> text) {
                    return Text(
                      text.data ?? "Add School",
                      style: TextStyle(color: Colors.blueGrey, fontSize: 18),
                      textDirection: TextDirection.rtl,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
              )),
              Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        navigateToSchoolList('Edit School', this.currentUserId);
      },
    );
  }

  Future<String> getSchoolName() async {
//    final QuerySnapshot userSchoolResult = await Firestore.instance
//        .collection('user_school_info')
//        .where('user_id', isEqualTo: this.currentUserId)
//        .where('currently_selected', isEqualTo: true)
//        .getDocuments();

    final userSchoolResult = await Firestore.instance.collection('users').document(this.currentUserId).get();

//    final List<DocumentSnapshot> userSchoolDocument =
//        userSchoolResult.documents;
    if (userSchoolResult['current_school_id'] == '00') {
      return "Add School";
    } else {
//      final currentSchoolName = userSchoolResult['school_name'];
//      return currentSchoolName;
      final currentSchoolName = await Firestore.instance.collection('schools').document(userSchoolResult['current_school_id']).get();
      return currentSchoolName['school_name'];
    }
  }

//  Future<String> getCurrentSchoolID() async {
//    final QuerySnapshot userSchoolResult = await Firestore.instance
//        .collection('user_school_info')
//        .where('user_id', isEqualTo: this.currentUserId)
//        .where('currently_selected', isEqualTo: true)
//        .getDocuments();
//
//    final List<DocumentSnapshot> userSchoolDocument =
//        userSchoolResult.documents;
//    if (userSchoolDocument.length == 0) {
//      return "0";
//    } else {
//      String currentSchoolID = userSchoolDocument[0]['school_id'];
//      return currentSchoolID;
//    }
//}

  ListView getThisSchoolCourses() {



    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: _thisSchoolCoursesCount,
      itemBuilder: (BuildContext context, int position) {
        return ListTile(
          title: Text(
            "Course Title Placeholder",
            style: TextStyle(color: Colors.black, fontSize: 20.0),
            textDirection: TextDirection.ltr,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }

  Widget getProfileImageAsset() {
    AssetImage assetImage = AssetImage('images/profilePhotoPlaceholder.png');

    Image image = Image(
      image: assetImage,
      width: 125,
      height: 125,
    );

    return Container(
      child: image,
    );
  }

  void navigateToSchoolList(String appBarTitle, String loggedInUserId) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SchoolList(appBarTitle, loggedInUserId);
    }));
  }
}
