import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SchoolList extends StatefulWidget {
  String appBarTitle;
  String loggedInUserId;

  SchoolList(this.appBarTitle, this.loggedInUserId);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SchoolListState(this.appBarTitle, this.loggedInUserId);
  }
}

class _SchoolListState extends State<SchoolList> {
  String appBarTitle;
  String loggedInUserId;

  _SchoolListState(this.appBarTitle, this.loggedInUserId);

  final _minimumPadding = 5.0;

  final _formKey = GlobalKey<FormState>();

  TextEditingController _schoolNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () {
        navigateToPreviousScreen();
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                navigateToPreviousScreen();
              },
            )),
        body: getSchoolPage(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(_minimumPadding * 1.5),
                          child: TextFormField(
                            controller: _schoolNameController,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                            decoration:
                                InputDecoration(hintText: "School Name"),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(_minimumPadding * 1.5),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Text("ADD",
                                      style: TextStyle(fontSize: 17)),
                                  color: Colors.blue,
                                  textColor: Colors.white,
                                  splashColor: Colors.green,
                                  onPressed: () {
                                    addSchoolToUser(_schoolNameController.text);
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(2.0),
                              ),
                              Expanded(
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Text("CANCEL",
                                      style: TextStyle(fontSize: 17)),
                                  color: Colors.blueGrey,
                                  textColor: Colors.white,
                                  splashColor: Colors.red,
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
          tooltip: 'Add School',
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Container getSchoolPage() {
    return Container(
      child: StreamBuilder(
          stream: Firestore.instance.collection('user_school_info').where('user_id', isEqualTo: this.loggedInUserId).snapshots(),
          //snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                color: Colors.white,
              );
            } else {
              return ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  color: Colors.black,
                  thickness: 0.2,
                ),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                  padding: EdgeInsets.only(top: _minimumPadding, bottom: _minimumPadding),
                  itemBuilder: (context, index) => buildSchoolItem(context, snapshot.data.documents[index]),
                itemCount: snapshot.data.documents.length,
              );
            }
          }),
      margin: EdgeInsets.all(_minimumPadding * 2),
    );
  }

  Future<void> addSchoolToUser(String schoolName) async {
    final QuerySnapshot doesSchoolExist = await Firestore.instance
        .collection('schools')
        .where('school_name', isEqualTo: schoolName)
        .getDocuments();

    final List<DocumentSnapshot> schoolExistDocument = doesSchoolExist.documents;
    if (schoolExistDocument.length == 0) {
      DocumentReference docRef = await Firestore.instance.collection('schools').add({
        'school_name': _schoolNameController.text,
      });
      Firestore.instance.collection('user_school_info').add({
        'user_id': this.loggedInUserId,
        'school_id': docRef.documentID,
        'school_name': _schoolNameController.text,
        'currently_selected': false
      });
    } else {
      final QuerySnapshot doesSchoolExistForUser = await Firestore.instance
          .collection('user_school_info')
          .where('school_name', isEqualTo: schoolName)
          .getDocuments();

      final List<DocumentSnapshot> schoolExistUserDocument = doesSchoolExistForUser.documents;
      if(schoolExistUserDocument.length == 0) {
        Firestore.instance.collection('user_school_info').add({
          'user_id': this.loggedInUserId,
          'school_id': schoolExistDocument[0].documentID,
          'school_name': _schoolNameController.text,
          'currently_selected': false
        });
      }
    }
  }


  Widget buildSchoolItem(BuildContext context, DocumentSnapshot document) {

    final bool selectedSchool = document['currently_selected'];

    return ListTile(
      title: Text(
        document['school_name'],
        style: TextStyle(color: Colors.black, fontSize: 20.0),
        textDirection: TextDirection.ltr,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Icon(
        selectedSchool ? Icons.check : null,
        color: selectedSchool ? Colors.green : null,
        size: 30,
      ),
      onTap: () {
        setState(() {
          setCurrentSchool(document);
        });
      },
    );

  }

  Future<void> setCurrentSchool(DocumentSnapshot document) async {
    final QuerySnapshot allSchoolsForUser = await Firestore.instance
        .collection('user_school_info')
        .where('user_id', isEqualTo: this.loggedInUserId)
        .getDocuments();

    final List<DocumentSnapshot> allSchoolsForUserDocument =
        allSchoolsForUser.documents;
    if(allSchoolsForUserDocument.length != 0) {
      allSchoolsForUserDocument.forEach((doc) {
        Firestore.instance.collection('user_school_info').document(doc.documentID).updateData(
            {
              'currently_selected': false,
            });
      });
      Firestore.instance.collection('user_school_info').document(document.documentID).updateData(
          {
            'currently_selected': true,
          });
      final currentSchoolDoc = await Firestore.instance.collection('user_school_info').document(document.documentID).get();
      Firestore.instance.collection('users').document(this.loggedInUserId).updateData({
        'current_school_id': currentSchoolDoc['school_id'],
      });


    }

  }

  void navigateToPreviousScreen() {
    Navigator.pop(context);
  }
}
