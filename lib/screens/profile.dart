import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:inter_note/screens/profileScreens/school_select.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
                getThisSchoolCourses(document['current_school_id'])
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

    final userSchoolResult = await Firestore.instance
        .collection('users')
        .document(this.currentUserId)
        .get();

    if (userSchoolResult['current_school_id'] == '00') {
      return "Add School";
    } else {

      final currentSchoolName = await Firestore.instance
          .collection('schools')
          .document(userSchoolResult['current_school_id'])
          .get();
      return currentSchoolName['school_name'];
    }
  }


  Container getThisSchoolCourses(String currentSchoolID) {
    return Container(
      child: StreamBuilder(
          stream: Firestore.instance
              .collection('user_course_info')
              .where('user_id', isEqualTo: this.currentUserId)
              .where('school_id', isEqualTo: currentSchoolID)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                children: <Widget>[
                  ListTile(
                    title: Text(
                      "Add courses to this school in Courses tab",
                      style: TextStyle(color: Colors.blueGrey, fontSize: 15.0),
                      textDirection: TextDirection.ltr,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              );
            } else {
              return ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: snapshot.data.documents.length,
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.black,
                    thickness: 0.2,
                  ),
                  itemBuilder: (context, index) =>
                      buildCourseItem(context, snapshot.data.documents[index]));
            }
          }),
    );
  }

  Widget buildCourseItem(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      title: Text(
        document['course_number'],
        style: TextStyle(color: Colors.black, fontSize: 20.0),
        textDirection: TextDirection.ltr,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        document['course_name'],
        style: TextStyle(color: Colors.black, fontSize: 15.0),
        textDirection: TextDirection.ltr,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
      ),
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
