import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inter_note/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';


//Stateful widget - creates a state of _loginPageState
class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}


class _LoginPageState extends State<LoginPage> {
  //value used for minimum padding and margin where applicable
  final _minimumPadding = 5.0;

  //creating new objects for google sign in,
  //firebase auth and SharedPrefereces
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences prefs;

  //booleans to check whether data is loading is whether the user is logged in
  bool isLoading = false;
  bool isLoggedIn = false;

  //new FirebaseUser object
  FirebaseUser currentUser;

  //check whether the user is signed in whether the page is launched
  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  //function to check whether the user is signed in
  void isSignedIn() async {
    this.setState(() {
      isLoading = true;
    });

    prefs = await SharedPreferences.getInstance();

    isLoggedIn = await googleSignIn.isSignedIn();
    //if the user is signed in already,
    //generate the home page widget to replace login page
    if (isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                HomePage(currentUserId: prefs.getString('id'))),
      );
    }

    this.setState(() {
      isLoading = false;
    });
  }

  Future<Null> handleSignIn() async {
    prefs = await SharedPreferences.getInstance();

    this.setState(() {
      isLoading = true;
    });

    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    FirebaseUser firebaseUser =
        (await firebaseAuth.signInWithCredential(credential)).user;

    if (firebaseUser != null) {
      // Check is already signed up
      final QuerySnapshot result = await Firestore.instance
          .collection('users')
          .where('id', isEqualTo: firebaseUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        // Update data to server if new user
        Firestore.instance
            .collection('users')
            .document(firebaseUser.uid)
            .setData({
          'displayname': firebaseUser.displayName,
          'photoUrl': firebaseUser.photoUrl,
          'id': firebaseUser.uid,
          'username': firebaseUser.email,
          'current_school_id': "00",
          'createdAt': DateTime.now(),
        });

        // Write data to local
        currentUser = firebaseUser;
        await prefs.setString('id', currentUser.uid);
        await prefs.setString('displayname', currentUser.displayName);
        await prefs.setString('photoUrl', currentUser.photoUrl);
        await prefs.setString('current_school_id', "00");
      } else {

       // stream: Firestore.instance.collection('users').document(this.currentUserId).snapshots();

        Firestore.instance.collection('users').document('$firebaseUser.uid').updateData(
            {
              'photoUrl': firebaseUser.photoUrl,
            });
        currentUser = firebaseUser;
        // Write data to local
        await prefs.setString('id', documents[0]['id']);
        await prefs.setString('displayname', documents[0]['displayname']);
        await prefs.setString('photoUrl', currentUser.photoUrl);
        await prefs.setString('current_school_id', "00");
      }
      Fluttertoast.showToast(msg: "Sign In Success");
      this.setState(() {
        isLoading = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(currentUserId: firebaseUser.uid)));
    } else {
      Fluttertoast.showToast(msg: "Sign In Fail");
      this.setState(() {
        isLoading = false;
      });
    }
  }

  //function to build body
  Widget _buildBody() {
    //builds the body using the Column widget which lays out the child widgets vertically
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            //gets the logo image
            child: getLogoImageAsset(),
          ),
          //this Container widget nests the children widget to display the Google Sign in Button
          Container(
              child: Padding(
                  padding: EdgeInsets.all(_minimumPadding * 2),
                  child: Container(
                    margin: EdgeInsets.only(
                        left: _minimumPadding * 10,
                        right: _minimumPadding * 10),
                    //package:flutter_auth_buttons/flutter_auth_buttons.dart is being used to generate
                    child: GoogleSignInButton(
                      darkMode: true,
                      onPressed: () {
                        handleSignIn();
                      },
                    ),
                  ))),
          Container(
            padding: EdgeInsets.all(_minimumPadding * 10),
          )
        ],
      );
  }

  @override
  Widget build(BuildContext context) {
    //build method builds the body of this widget by calling custom _buildBody function which fills the screen
    return Scaffold(
        backgroundColor: Colors.white,
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: _buildBody(),
        ));
  }

  //function to return the logo image of the  application
  Widget getLogoImageAsset() {
    AssetImage assetImage = AssetImage('images/internoteLogo.png');

    Image image = Image(
      image: assetImage,
      width: 568,
      height: 300,
    );

    return Container(
      child: image,
    );
  }
}
