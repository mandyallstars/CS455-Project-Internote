import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AddCourse extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddCourseState();
  }
}

class AddCourseState extends State<AddCourse> {
  final _minimumPadding = 5.0;

  final TextEditingController _searchBarController = TextEditingController();
  final TextEditingController _semesterController = TextEditingController();
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

  final _formKey = GlobalKey<FormState>();

  var _semesterValue = ["Spring Summer", "Fall", "Winter"];

  var _amPmValue = ["AM", "PM"];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Course"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.clear),
            iconSize: 40,
            onPressed: () {
              debugPrint("User Pressed Clear Button");
            },
          ),
        ],
      ),
      body: getCourseAddForm(),
//      floatingActionButton: FloatingActionButton.extended(
//        icon: Icon(Icons.add),
//        label: Text('Add Course'),
//        onPressed: () {
//          debugPrint("Add Course Button Pressed");
//        },
//      ),
    );
  }

  Container getCourseAddForm() {
    return Container(
      margin: EdgeInsets.all(_minimumPadding * 2),
      child: ListView(
        children: <Widget>[
          Padding(
            padding:
                EdgeInsets.only(top: _minimumPadding, bottom: _minimumPadding),
            child: TextField(
              controller: _searchBarController,
              style: TextStyle(fontSize: 15.0),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  prefixIcon: IconButton(
                    icon: Icon(Icons.search),
                  ),
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
                            child: DropdownButton(
                              isExpanded: true,
                              elevation: 10,
                              items: _semesterValue
                                  .map((String semesterDropDownItem) {
                                return DropdownMenuItem<String>(
                                  value: semesterDropDownItem,
                                  child: Text(semesterDropDownItem,
                                      style: TextStyle(fontSize: 25.0)),
                                );
                              }).toList(),
                              value: 'Fall',
                              onChanged: (semesterDropDownItem) {
                                setState(() {
                                  debugPrint(
                                      "User selected $semesterDropDownItem");
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
                            child: TextFormField(
                              maxLength: 4,
                              maxLengthEnforced: true,
                              keyboardType: TextInputType.numberWithOptions(
                                  signed: false, decimal: false),
                              controller: _semesterYearController,
                              decoration: InputDecoration(
                                  labelText: "Year E.g. 2019",
                                  counter: Offstage()),
                            ),
                          ),
                        ],
                      )),
                  TextFormField(
                    controller: _courseNameController,
                    decoration: InputDecoration(labelText: "Course Name"),
                  ),
                  TextFormField(
                    controller: _courseNumberController,
                    decoration:
                        InputDecoration(labelText: "Course Number E.g. CS 100"),
                  ),
                  TextFormField(
                    controller: _courseSectionController,
                    decoration: InputDecoration(
                        labelText: "Course Section E.g. 001 or A"),
                  ),
                  TextFormField(
                    controller: _instructorNameController,
                    decoration: InputDecoration(
                        labelText: "Instructor's Name E.g. John Smith"),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          maxLength: 2,
                          maxLengthEnforced: true,
                          keyboardType: TextInputType.numberWithOptions(
                              signed: false, decimal: false),
                          controller: _timeFromHourController,
                          decoration: InputDecoration(
                              labelText: "01", counter: Offstage()),
                        ),
                      ),
                      Text(" : "),
                      Expanded(
                        child: TextFormField(
                          maxLength: 2,
                          maxLengthEnforced: true,
                          keyboardType: TextInputType.numberWithOptions(
                              signed: false, decimal: false),
                          controller: _timeFromMinuteController,
                          decoration: InputDecoration(
                              labelText: "15", counter: Offstage()),
                        ),
                      ),
                      Expanded(
                        child: DropdownButton(
                          isExpanded: true,
                          elevation: 10,
                          items: _amPmValue.map((String amPmItem) {
                            return DropdownMenuItem<String>(
                              value: amPmItem,
                              child: Text(amPmItem,
                                  style: TextStyle(fontSize: 15.0)),
                            );
                          }).toList(),
                          value: 'PM',
                          onChanged: (semesterDropDownItem) {
                            setState(() {
                              debugPrint("User selected $semesterDropDownItem");
                            });
                          },
                        ),
                      ),
                      Text(" to ",
                          style: TextStyle(color: Colors.black, fontSize: 20)),
                      Expanded(
                        child: TextFormField(
                          maxLength: 2,
                          maxLengthEnforced: true,
                          keyboardType: TextInputType.numberWithOptions(
                              signed: false, decimal: false),
                          controller: _timeToHourController,
                          decoration: InputDecoration(
                              labelText: "01", counter: Offstage()),
                        ),
                      ),
                      Text(" : "),
                      Expanded(
                        child: TextFormField(
                          maxLength: 2,
                          maxLengthEnforced: true,
                          keyboardType: TextInputType.numberWithOptions(
                              signed: false, decimal: false),
                          controller: _timeToMinuteController,
                          decoration: InputDecoration(
                              labelText: "15", counter: Offstage()),
                        ),
                      ),
                      Expanded(
                        child: DropdownButton(
                          isExpanded: true,
                          elevation: 10,
                          items: _amPmValue.map((String amPmItem) {
                            return DropdownMenuItem<String>(
                              value: amPmItem,
                              child: Text(amPmItem,
                                  style: TextStyle(fontSize: 15.0)),
                            );
                          }).toList(),
                          value: 'PM',
                          onChanged: (semesterDropDownItem) {
                            setState(() {
                              debugPrint("User selected $semesterDropDownItem");
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.white),
                  Container(
                    margin: EdgeInsets.only(left: 100, right: 100),
                    child: RaisedButton(
                      //padding: EdgeInsets.only(left: 40, right: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text("ADD COURSE"),
                      color: Colors.blue,
                      textColor: Colors.white,
                      splashColor: Colors.green,
                      onPressed: () {
                        debugPrint("ADD COURSE button Pressed");
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
}
