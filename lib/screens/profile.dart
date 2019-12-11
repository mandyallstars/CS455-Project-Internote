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

  //takes in user ID of the logged in user as argument
  Profile({Key key, @required this.currentUserId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProfileState(currentUserId: this.currentUserId);
  }
}

class ProfileState extends State<Profile> {
  final String currentUserId;

  //takes in user ID of the logged in user as argument
  ProfileState({Key key, @required this.currentUserId});

  //google sign in object to handle sign out later
  final GoogleSignIn googleSignIn = GoogleSignIn();

  //variabe to impelement minimum padding/margin where applicable
  final _minimumPadding = 5.0;

  FocusNode _nameFocusNode;

  bool isLoading = false;

  //function to handle sign out
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

    //remove everything from navigation stack
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: <Widget>[
          InkResponse(
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
                )),
            onTap: () {
              //signs out the user when user presses Sign Out button
              handleSignOut();
            },
          ),
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
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              //show progress indicator if there is no data for user
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
                  //show Cached image of the user if there is a photoUrl in the profile,
                  //else show a placeholder
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
                      : getProfileImageAsset(), //placeholder image asset
                ),
                //getProfileImageAsset(),
                Divider(color: Colors.black54),
                TextFormField(
                  //Text form field to display and change user name in profile
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
                //display the information for the currently selected school
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
                //display the  courses for currently selected school in list form
                getThisSchoolCourses(document['current_school_id'])
              ],
            );
          }
        },
      ),
    );
  }

  //function to display the UI for tappable school information
  InkWell getCurrentSchoolInfo() {
    return InkWell(
      customBorder: Border(
        //supposed to show border around the child but not working
          top: BorderSide(width: 5.0, color: Colors.black),
          bottom: BorderSide(width: 5.0, color: Colors.black)),
      child: Container(
        child: Padding(
          padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
          //UI elements are layed out using Row which displays child elements horizontally
          child: Row(
            children: <Widget>[
              //leading school icon
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
              //Displays the current selected school for user. Displays Add School if there is no school in profile
              Expanded(
                  child: Container(
                margin: EdgeInsets.only(right: _minimumPadding * 2),
                child: FutureBuilder(
                  future: getSchoolName(), //retirves currently selected school
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
              //trailing icon to indicate the user can tap on this to go into sub page
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
        //go to school page when tapped on this UI
        navigateToSchoolList('Edit School', this.currentUserId);
      },
    );
  }

  //returns the currently selected school for the user
  Future<String> getSchoolName() async {
    final userSchoolResult = await Firestore.instance
        .collection('users')
        .document(this.currentUserId)
        .get();

    if (userSchoolResult['current_school_id'] == '00') {
      //returns Add School if no school in profile
      return "Add School";
    } else {
      final currentSchoolName = await Firestore.instance
          .collection('schools')
          .document(userSchoolResult['current_school_id'])
          .get();
      return currentSchoolName['school_name'];
    }
  }

  //function to display UI of the courses in logged in user's profile for the currently selected school
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
                      //supposed to display this text if there are no courses but not working
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
                  //builds each item of the list of courses
                  itemBuilder: (context, index) =>
                      buildCourseItem(context, snapshot.data.documents[index]));
            }
          }),
    );
  }

  //function to build a single list item of courses
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

  //function to return the placeholder image for profile picture
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

  //function to navigate to the School Selection/Adding page
  void navigateToSchoolList(String appBarTitle, String loggedInUserId) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SchoolList(appBarTitle, loggedInUserId);
    }));
  }
}
