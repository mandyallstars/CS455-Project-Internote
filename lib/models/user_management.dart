import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class userManagement {
  storeUser(user, context) {
    Firestore.instance.collection('/users').add({}).then(() {
      
    }).catchError((e) {
      print(e);
    })
  }
}