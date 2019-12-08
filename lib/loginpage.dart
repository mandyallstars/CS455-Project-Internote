import 'dart:async';
import 'dart:convert' show json;
import "package:http/http.dart" as http;

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
          'createdAt': DateTime.now(),
        });

        // Write data to local
        currentUser = firebaseUser;
        await prefs.setString('id', currentUser.uid);
        await prefs.setString('displayname', currentUser.displayName);
        await prefs.setString('photoUrl', currentUser.photoUrl);
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
        //await prefs.setString('photoUrl', documents[0]['photoUrl']);
        await prefs.setString('photoUrl', currentUser.photoUrl);
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

//  GoogleSignInAccount _currentUser;
//  String _contactText;
//
//  @override
//  void initState() {
//    super.initState();
//    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
//      setState(() {
//        _currentUser = account;
//      });
//      if (_currentUser != null) {
//        _handleGetContact();
//      }
//    });
//    _googleSignIn.signInSilently();
//  }

//  Future<void> _handleGetContact() async {
//    setState(() {
//      _contactText = "Loading contact info...";
//    });
//    final http.Response response = await http.get(
//      'https://people.googleapis.com/v1/people/me/connections'
//      '?requestMask.includeField=person.names',
//      headers: await _currentUser.authHeaders,
//    );
//    if (response.statusCode != 200) {
//      setState(() {
//        _contactText = "People API gave a ${response.statusCode} "
//            "response. Check logs for details.";
//      });
//      print('People API ${response.statusCode} response: ${response.body}');
//      return;
//    }
//    final Map<String, dynamic> data = json.decode(response.body);
//    final String namedContact = _pickFirstNamedContact(data);
//    setState(() {
//      if (namedContact != null) {
//        _contactText = "I see you know $namedContact!";
//      } else {
//        _contactText = "No contacts to display.";
//      }
//    });
//  }

//  String _pickFirstNamedContact(Map<String, dynamic> data) {
//    final List<dynamic> connections = data['connections'];
//    final Map<String, dynamic> contact = connections?.firstWhere(
//      (dynamic contact) => contact['names'] != null,
//      orElse: () => null,
//    );
//    if (contact != null) {
//      final Map<String, dynamic> name = contact['names'].firstWhere(
//        (dynamic name) => name['displayName'] != null,
//        orElse: () => null,
//      );
//      if (name != null) {
//        return name['displayName'];
//      }
//    }
//    return null;
//  }

//  Future<void> _handleSignIn() async {
//    try {
//      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
//      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//      final AuthCredential credential = GoogleAuthProvider.getCredential(
//          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
//      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//      FirebaseUser firebaseUser =
//          (await firebaseAuth.signInWithCredential(credential)).user;
//
//      if (firebaseUser != null) {
//        //check is already signed up
//        final QuerySnapshot result = await Firestore.instance
//            .collection('users')
//            .where('id', isEqualTo: firebaseUser.uid)
//            .getDocuments();
//        final List<DocumentSnapshot> documents = result.documents;
//        if (documents.length == 0) {
//          // Update data to server if new user
//          Firestore.instance
//              .collection('users')
//              .document(firebaseUser.uid)
//              .setData({
//            'username': firebaseUser.email,
//            'displayname': firebaseUser.displayName,
//            'photoUrl': firebaseUser.photoUrl,
//            'id': firebaseUser.uid,
//          });
//        }
//      }
//    } catch (error) {
//      print(error);
//    }
//  }

//  Future<void> _handleSignOut() async {
//    _googleSignIn.disconnect();
//  }

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
