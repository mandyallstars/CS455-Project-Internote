import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inter_note/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

//GoogleSignIn _googleSignIn = GoogleSignIn(
//  scopes: <String>[
//    'email',
//    'https://www.googleapis.com/auth/contacts.readonly',
//  ],
//);

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final _minimumPadding = 5.0;

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences prefs;

  bool isLoading = false;
  bool isLoggedIn = false;

  FirebaseUser currentUser;

  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async {
    this.setState(() {
      isLoading = true;
    });

    prefs = await SharedPreferences.getInstance();

    isLoggedIn = await googleSignIn.isSignedIn();
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

  Widget _buildBody() {
    return Column(
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: getLogoImageAsset(),
          ),
          Container(
              child: Padding(
                  padding: EdgeInsets.all(_minimumPadding * 2),
                  child: Container(
                    margin: EdgeInsets.only(
                        left: _minimumPadding * 10,
                        right: _minimumPadding * 10),
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
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.white,
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: _buildBody(),
        ));
  }

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
