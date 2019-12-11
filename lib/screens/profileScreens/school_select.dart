import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SchoolList extends StatefulWidget {
  String appBarTitle;
  String loggedInUserId;

  SchoolList(this.appBarTitle, this.loggedInUserId);

  @override
  State<StatefulWidget> createState() {
    //creates a state for _SchoolListState with title and ID of the logged in user as argument
    return _SchoolListState(this.appBarTitle, this.loggedInUserId);
  }
}

class _SchoolListState extends State<SchoolList> {
  String appBarTitle;
  String loggedInUserId;

  _SchoolListState(this.appBarTitle, this.loggedInUserId);

  final _minimumPadding = 5.0;

  //global key in this file for the form
  final _formKey = GlobalKey<FormState>();

  //text controller for the school name
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
        //body shows current schools in user profile
        body: getSchoolPage(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //when user taps on + button, alert dialog is created to get new school name
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
                          //text form field to get school name input
                          child: TextFormField(
                            controller: _schoolNameController,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                            decoration:
                                InputDecoration(hintText: "School Name"),
                            //validator validates the field - value is the value currently in the field
                            validator: (value) {
                              if(value.isEmpty) {
                                return '*Required';
                              }
                            },
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
                                    //school only added to the user if form is validated
                                    if(_formKey.currentState.validate()) {
                                      addSchoolToUser(_schoolNameController.text);
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    }
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

  //function to display the current schools in the user profile
  Container getSchoolPage() {
    return Container(
      child: StreamBuilder(
          stream: Firestore.instance.collection('user_school_info').where('user_id', isEqualTo: this.loggedInUserId).snapshots(),
          //snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              //display blank container if there is no school
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
                  //builds the school items in the profile
                  itemBuilder: (context, index) => buildSchoolItem(context, snapshot.data.documents[index]),
                itemCount: snapshot.data.documents.length,
              );
            }
          }),
      margin: EdgeInsets.all(_minimumPadding * 2),
    );
  }

  //function to add the school to user profile
  Future<void> addSchoolToUser(String schoolName) async {

    final thisUserDoc = await Firestore.instance.collection('users').document(this.loggedInUserId).get();

    final QuerySnapshot doesSchoolExist = await Firestore.instance
        .collection('schools')
        .where('school_name', isEqualTo: schoolName)
        .getDocuments();

    final List<DocumentSnapshot> schoolExistDocument = doesSchoolExist.documents;

    //check if the school exists in the main school list at all
    if (schoolExistDocument.length == 0) {

      //add school to main school list if does not exist
      DocumentReference docRef = await Firestore.instance.collection('schools').add({
        'school_name': _schoolNameController.text,
      });

      //if user does not have any schools in profile,
      // make this the currently selected school for user
      if(thisUserDoc['current_school_id'] == '00') {
        Firestore.instance.collection('user_school_info').add({
          'user_id': this.loggedInUserId,
          'school_id': docRef.documentID,
          'school_name': _schoolNameController.text,
          'currently_selected': true
        });

        Firestore.instance.collection('users').document(this.loggedInUserId).updateData({
          'current_school_id': docRef.documentID,
        });

      } else {
        //if user already has a current school in profile,
        //then just add school to profile and
        //leave the onus of selecting it as current school on user
        Firestore.instance.collection('user_school_info').add({
          'user_id': this.loggedInUserId,
          'school_id': docRef.documentID,
          'school_name': _schoolNameController.text,
          'currently_selected': false
        });
      }

    } else {

      //this code is invoked if the school already exists in the school list
      final QuerySnapshot doesSchoolExistForUser = await Firestore.instance
          .collection('user_school_info')
          .where('user_id', isEqualTo: this.loggedInUserId)
          .where('school_name', isEqualTo: schoolName)
          .getDocuments();

      final List<DocumentSnapshot> schoolExistUserDocument = doesSchoolExistForUser.documents;

      //check if the school already exists for  the user
      if(schoolExistUserDocument.length == 0) {

        if(thisUserDoc['current_school_id'] == '00') {
          //if user does not have any schools in profile,
          //make this the currently selected school for user
          Firestore.instance.collection('user_school_info').add({
            'user_id': this.loggedInUserId,
            'school_id': schoolExistDocument[0].documentID,
            'school_name': _schoolNameController.text,
            'currently_selected': true
          });

          Firestore.instance.collection('users').document(this.loggedInUserId).updateData({
            'current_school_id': schoolExistDocument[0].documentID,
          });

        } else {
          //if user already has a current school in profile,
          //then just add school to profile and
          //leave the onus of selecting it as current school on user
          Firestore.instance.collection('user_school_info').add({
            'user_id': this.loggedInUserId,
            'school_id': schoolExistDocument[0].documentID,
            'school_name': _schoolNameController.text,
            'currently_selected': false
          });
        }

      } else {
        //if same school exists for the  user, then display a snackbar with info
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
              'Same school already exists in profile',
              textAlign: TextAlign.center,
            )));
      }
    }
  }


  //function to build a single item with school name
  Widget buildSchoolItem(BuildContext context, DocumentSnapshot document) {

    //checks if the document being passed has currently selected as true or not
    final bool selectedSchool = document['currently_selected'];

    return ListTile(
      title: Text(
        document['school_name'],
        style: TextStyle(color: Colors.black, fontSize: 20.0),
        textDirection: TextDirection.ltr,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
      ),
      //trailing icon is green check mark if the school is currently selected by user,
      //otherwise no trailing icon
      trailing: Icon(
        selectedSchool ? Icons.check : null,
        color: selectedSchool ? Colors.green : null,
        size: 30,
      ),
      onTap: () {
        setState(() {
          //change the currently selected for user to the school that user taps on
          setCurrentSchool(document);
        });
      },
    );

  }

  //function to change the currently selected school for user
  Future<void> setCurrentSchool(DocumentSnapshot document) async {
    //gets a list of all schools for the user in the profile as list of the firestore documents
    final QuerySnapshot allSchoolsForUser = await Firestore.instance
        .collection('user_school_info')
        .where('user_id', isEqualTo: this.loggedInUserId)
        .getDocuments();

    final List<DocumentSnapshot> allSchoolsForUserDocument =
        allSchoolsForUser.documents;
    //if there are any schools in the profile then the following code is run
    if(allSchoolsForUserDocument.length != 0) {
      //first currently selected for all the schools in user profile is set to false
      allSchoolsForUserDocument.forEach((doc) {
        Firestore.instance.collection('user_school_info').document(doc.documentID).updateData(
            {
              'currently_selected': false,
            });
      });

      //current selected is set to true for the school that the user tapped on
      Firestore.instance.collection('user_school_info').document(document.documentID).updateData(
          {
            'currently_selected': true,
          });
      final currentSchoolDoc = await Firestore.instance.collection('user_school_info').document(document.documentID).get();

      //current school id in the users profile is changed to the school that user tapped on
      Firestore.instance.collection('users').document(this.loggedInUserId).updateData({
        'current_school_id': currentSchoolDoc['school_id'],
      });


    }

  }

  void navigateToPreviousScreen() {
    Navigator.pop(context);
  }
}
