import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCourse extends StatefulWidget {
  String appBarTitle;
  String loggedInUserId;
  String courseId;

  AddCourse(this.appBarTitle, this.loggedInUserId, this.courseId);

  @override
  State<StatefulWidget> createState() {
    //creates state for AddCourseState with title, logged in user ID and course ID as arguments
    return AddCourseState(appBarTitle, this.loggedInUserId, this.courseId);
  }
}

class AddCourseState extends State<AddCourse> {
  String appBarTitle;
  String loggedInUserId;
  String courseId;

  AddCourseState(this.appBarTitle, this.loggedInUserId, this.courseId);

  //variabe to impelement minimum padding/margin where applicable
  final _minimumPadding = 5.0;

  //controllers for form elements in this page UI
  final TextEditingController _searchBarController = TextEditingController();
  final TextEditingController _semesterYearController = TextEditingController();
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _courseNumberController = TextEditingController();
  final TextEditingController _courseSectionController =
      TextEditingController();
  final TextEditingController _instructorNameController =
      TextEditingController();
  final TextEditingController _timeFromHourController = TextEditingController();
  final TextEditingController _timeFromMinuteController =
      TextEditingController();
  final TextEditingController _timeToHourController = TextEditingController();
  final TextEditingController _timeToMinuteController = TextEditingController();

  //global key for the form on this page
  final _formKey = GlobalKey<FormState>();

  //varaibles for dropdown buttons
  var semesterValue;
  var amPmValueFrom;
  var amPmValueTo;

  //Array for drop down buttons
  var _amPmValue = ["AM", "PM"];
  var _semesterArray = ["Spring Summer", "Fall", "Winter"];

  //called when the page is created
  @override
  void initState() {
    super.initState();
    setCourseInfo();
  }

  //function to initialize the form elements with the course info is the user
  // is trying to edit a course that is already in the profile
  Future<void> setCourseInfo() async {
    if (this.courseId != 'New') {
      //returns the document for the course ID passed to this page
      final courseDoc = await Firestore.instance
          .collection('courses')
          .document(this.courseId)
          .get();

      _semesterYearController.text = courseDoc['semester_year'];
      _courseNameController.text = courseDoc['course_name'];
      _courseNumberController.text = courseDoc['course_number'];
      _courseSectionController.text = courseDoc['course_section'];
      _instructorNameController.text = courseDoc['instructor_name'];
      _timeFromHourController.text =
          courseDoc['time_from'].toString().split(':')[0];
      _timeFromMinuteController.text =
          courseDoc['time_from'].toString().split(':')[1].split(' ')[0];
      _timeToHourController.text =
          courseDoc['time_to'].toString().split(':')[0];
      _timeToMinuteController.text =
          courseDoc['time_to'].toString().split(':')[1].split(' ')[0];
      amPmValueFrom =
          courseDoc['time_from'].toString().split(':')[1].split(' ')[1];
      amPmValueTo = courseDoc['time_to'].toString().split(':')[1].split(' ')[1];
      semesterValue = courseDoc['semester'];
    }
  }

  @override
  Widget build(BuildContext context) {
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
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.clear),
              iconSize: 40,
              onPressed: () {
                //user returns to previous page if clear button is pressed in top right corner
                navigateToPreviousScreen();
              },
            ),
          ],
        ),
        body: getCourseAddForm(),
      ),
    );
  }

  //function to build the page form
  Container getCourseAddForm() {
    return Container(
      margin: EdgeInsets.all(_minimumPadding * 2),
      child: ListView(
        children: <Widget>[
          Padding(
            // widget for search bar. search bar does not work
            padding:
                EdgeInsets.only(top: _minimumPadding, bottom: _minimumPadding),
            child: TextField(
              controller: _searchBarController,
              style: TextStyle(fontSize: 15.0),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback(
                          (_) => _searchBarController.clear());
                    },
                  ),
                  hintText: "Search...",
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 32.0),
                      borderRadius: BorderRadius.circular(20.0)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey[300], width: 32.0),
                      borderRadius: BorderRadius.circular(20.0))),
            ),
          ),
          Form(
            //form starts below the search bar
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(_minimumPadding * 2),
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(
                          top: _minimumPadding, bottom: _minimumPadding),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            //dropdown button to select the semester
                            child: DropdownButton(
                              value: semesterValue,
                              isExpanded: true,
                              elevation: 10,
                              iconEnabledColor: Colors.black,
                              items: _semesterArray
                                  .map((String semesterDropDownItem) {
                                return DropdownMenuItem<String>(
                                  value: semesterDropDownItem,
                                  child: Text(semesterDropDownItem,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 20.0)),
                                );
                              }).toList(),
                              hint: Text('Semester',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20)),
                              onChanged: (semesterDropDownItem) {
                                setState(() {
                                  semesterValue = semesterDropDownItem;
                                });
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: _minimumPadding * 2,
                                right: _minimumPadding * 2),
                          ),
                          Expanded(
                            //to input the semester year
                            child: TextFormField(
                              maxLength: 4,
                              maxLengthEnforced: true,
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.numberWithOptions(
                                  signed: false, decimal: false),
                              controller: _semesterYearController,
                              decoration: InputDecoration(
                                labelText: "Year E.g. 2019",
                                counter: Offstage(),
                              ),
                              //validator ensures that the field is not left empty
                              validator: (value) {
                                if (value.isEmpty) {
                                  return '*Required';
                                }
                              },
                            ),
                          ),
                        ],
                      )),
                  //to input Course Name
                  //subsequent fields are self-explanatory
                  TextFormField(
                    controller: _courseNameController,
                    decoration: InputDecoration(labelText: "Course Name"),
                    style: TextStyle(fontSize: 20),
                    //validator ensures that the field is not left empty
                    //subsequent validators are self-explanatory
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Required';
                      }
                    },
                  ),
                  TextFormField(
                    controller: _courseNumberController,
                    decoration:
                        InputDecoration(labelText: "Course Number E.g. CS 100"),
                    style: TextStyle(fontSize: 20),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Required';
                      }
                    },
                  ),
                  TextFormField(
                    controller: _courseSectionController,
                    decoration: InputDecoration(
                        labelText: "Course Section E.g. 001 or A"),
                    style: TextStyle(fontSize: 20),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Required. Enter 001 if no section.';
                      }
                    },
                  ),
                  TextFormField(
                    controller: _instructorNameController,
                    decoration: InputDecoration(
                        labelText: "Instructor's Name E.g. John Smith"),
                    style: TextStyle(fontSize: 20),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Required";
                      }
                    },
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          //field to input start time hour
                          maxLength: 2,
                          maxLengthEnforced: true,
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.numberWithOptions(
                              signed: false, decimal: false),
                          controller: _timeFromHourController,
                          decoration: InputDecoration(
                              hintText: "01", counter: Offstage()),
                          validator: (value) {
                            if (value.isEmpty) {
                              return '*Req';
                            }
                          },
                        ),
                      ),
                      Text(" : ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25)),
                      Expanded(
                        //field to input start time minutes
                        child: TextFormField(
                          maxLength: 2,
                          maxLengthEnforced: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                          keyboardType: TextInputType.numberWithOptions(
                              signed: false, decimal: false),
                          controller: _timeFromMinuteController,
                          decoration: InputDecoration(
                              hintText: "15", counter: Offstage()),
                          validator: (value) {
                            if (value.isEmpty) {
                              return '*Req';
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: DropdownButton(
                          //dropdown button to select time of the day
                          value: amPmValueFrom,
                          isExpanded: true,
                          elevation: 10,
                          items: _amPmValue.map((String amPmItem) {
                            return DropdownMenuItem<String>(
                              value: amPmItem,
                              child: Text(
                                amPmItem,
                                style: TextStyle(fontSize: 15),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }).toList(),
                          hint: Text(
                            "PM",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15),
                          ),
                          onChanged: (amPmItem) {
                            setState(() {
                              amPmValueFrom = amPmItem;
                            });
                          },
                        ),
                      ),
                      Text(" to ",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 20)),
                      Expanded(
                        child: TextFormField(
                          //field to input start time hour
                          maxLength: 2,
                          maxLengthEnforced: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                          keyboardType: TextInputType.numberWithOptions(
                              signed: false, decimal: false),
                          controller: _timeToHourController,
                          decoration: InputDecoration(
                              hintText: "01", counter: Offstage()),
                          validator: (value) {
                            if (value.isEmpty) {
                              return '*Req';
                            }
                          },
                        ),
                      ),
                      Text(" : ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      Expanded(
                        child: TextFormField(
                          //field to input start time minutes
                          maxLength: 2,
                          maxLengthEnforced: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                          keyboardType: TextInputType.numberWithOptions(
                              signed: false, decimal: false),
                          controller: _timeToMinuteController,
                          decoration: InputDecoration(
                              hintText: "15", counter: Offstage()),
                          validator: (value) {
                            if (value.isEmpty) {
                              return '*Req';
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: DropdownButton(
                          //dropdown button to select time of the day
                          value: amPmValueTo,
                          isExpanded: true,
                          elevation: 10,
                          items: _amPmValue.map((String amPmItem) {
                            return DropdownMenuItem<String>(
                              value: amPmItem,
                              child: Text(
                                amPmItem,
                                style: TextStyle(fontSize: 15),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }).toList(),
                          hint: Text(
                            "PM",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15),
                          ),
                          onChanged: (amPmItem) {
                            setState(() {
                              amPmValueTo = amPmItem;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: _minimumPadding * 20,
                        right: _minimumPadding * 20),
                    child: RaisedButton(
                      //padding: EdgeInsets.only(left: 40, right: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        "ADD COURSE",
                        style: TextStyle(fontSize: 17),
                      ),
                      color: Colors.blue,
                      textColor: Colors.white,
                      splashColor: Colors.green,
                      onPressed: () {
                        if (amPmValueFrom == null ||
                            amPmValueTo == null ||
                            semesterValue == null) {
                          //indicate to user if dropdown button values are not selected
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(
                            'Select drop down values',
                            textAlign: TextAlign.center,
                          )));
                        } else if (_formKey.currentState.validate()) {
                          //otherwise if form is valid(as per validators), then add the course to user
                          addCourseToUser();
                          Navigator.of(context).pop();
                        } else {
                          //otherwise if form is not valid, indicate to user
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(
                            'Enter Valid Values',
                            textAlign: TextAlign.center,
                          )));
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //function to add course to the user profile for current school
  Future<void> addCourseToUser() async {

    //retrieves current user's document
    final currentUserDoc = await Firestore.instance
        .collection('users')
        .document(this.loggedInUserId)
        .get();

    //stores current schools ID
    var currentSchoolId = currentUserDoc['current_school_id'];

    //queries course collection with information that user entered
    final QuerySnapshot doesCourseExist = await Firestore.instance
        .collection('courses')
        .where('school_id', isEqualTo: currentSchoolId)
        .where('course_name', isEqualTo: _courseNameController.text)
        .where('course_number', isEqualTo: _courseNumberController.text)
        .where('course_section', isEqualTo: _courseSectionController.text)
        .where('semester', isEqualTo: semesterValue)
        .where('semester_year', isEqualTo: _semesterYearController.text)
        .where('instructor_name', isEqualTo: _instructorNameController.text)
        .where('time_from',
            isEqualTo: _timeFromHourController.text +
                ":" +
                _timeFromMinuteController.text +
                " $amPmValueFrom")
        .where('time_to',
            isEqualTo: _timeToHourController.text +
                ":" +
                _timeToMinuteController.text +
                " $amPmValueTo")
        .getDocuments();

    final List<DocumentSnapshot> doesCourseExistDoc = doesCourseExist.documents;

    //checks to see the course info that user entered already exists or not
    if (doesCourseExistDoc.length == 0) {

      //if the course does not exist at all, add course info to the overall courses collection
      //and also add course info to the user's course collection
      DocumentReference docRef =
          await Firestore.instance.collection('courses').add({
        'school_id': currentSchoolId,
        'course_name': _courseNameController.text,
        'course_number': _courseNumberController.text,
        'course_section': _courseSectionController.text,
        'semester': semesterValue,
        'semester_year': _semesterYearController.text,
        'instructor_name': _instructorNameController.text,
        'time_from': _timeFromHourController.text +
            ":" +
            _timeFromMinuteController.text +
            " $amPmValueFrom",
        'time_to': _timeToHourController.text +
            ":" +
            _timeToMinuteController.text +
            " $amPmValueTo"
      });

      //adding course info to user's course collection
      Firestore.instance.collection('user_course_info').add({
        'user_id': this.loggedInUserId,
        'school_id': currentSchoolId,
        'course_id': docRef.documentID,
        'course_name': _courseNameController.text,
        'course_number': _courseNumberController.text
      });
    } else {
      // else if the course with entered information already exists,
      //then run the following code

      var courseId = doesCourseExistDoc[0].documentID;

      //querying user's course collection with the information that user entered
      final QuerySnapshot doesCourseExistForUser = await Firestore.instance
          .collection('user_course_info')
          .where('user_id', isEqualTo: this.loggedInUserId)
          .where('course_number', isEqualTo: _courseNumberController.text)
          .where('course_name', isEqualTo: _courseNameController.text)
          .getDocuments();

      final List<DocumentSnapshot> doesCourseExistForUserDoc =
          doesCourseExistForUser.documents;

      //check to see if the user already has a course with entered info for the currently selected school
      if (doesCourseExistForUserDoc.length == 0) {

        //if the course with information entered does not exist for user for currently selected school,
        //then add the the course to user's course collection
        Firestore.instance.collection('user_course_info').add({
          'user_id': this.loggedInUserId,
          'school_id': currentSchoolId,
          'course_id': courseId,
          'course_name': doesCourseExistDoc[0]['course_name'],
          'course_number': doesCourseExistDoc[0]['course_number']
        });

        //check if this was a new course that the user was adding or trying to edit an existing course
        if (this.courseId != 'New') {

          //if the user was editing an existing course, then run the following code

          //add the course with new info to the user's course collection
          final QuerySnapshot getThisCourseForUser = await Firestore.instance
              .collection('user_course_info')
              .where('user_id', isEqualTo: this.loggedInUserId)
              .where('school_id', isEqualTo: currentSchoolId)
              .where('course_id', isEqualTo: this.courseId)
              .getDocuments();

          final List<DocumentSnapshot> getThisCourseForUserDoc =
              getThisCourseForUser.documents;

          //delete the course that the user was editing from user's course collection
          // but it still remains in the overall collection of courses for this school
          Firestore.instance
              .collection('user_course_info')
              .document(getThisCourseForUserDoc[0].documentID)
              .delete();
        }
      }
    }
  }

  void navigateToPreviousScreen() {
    Navigator.of(context).pop();
  }
}
