import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SchoolList extends StatefulWidget {
  String appBarTitle;

  SchoolList(this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SchoolListState(this.appBarTitle);
  }
}

class _SchoolListState extends State<SchoolList> {
  String appBarTitle;

  _SchoolListState(this.appBarTitle);

  final _minimumPadding = 5.0;

  final _formKey = GlobalKey<FormState>();

  int _schoolsInProfile = 3;

  String currentSelectedSchool = "Default";

  String schoolName = "School Placeholder";

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
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                            decoration:
                                InputDecoration(hintText: "School Name"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
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
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
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
                                    debugPrint("Cancel Button Pressed");
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
        margin: EdgeInsets.all(_minimumPadding * 2),
        child: ListView(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(
                    top: _minimumPadding, bottom: _minimumPadding),
                child: Text(
                  "School",
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                      fontSize: 40.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                )),
            getSchoolList(schoolName)
          ],
        ));
  }

  ListView getSchoolList(String schoolName) {
    final bool selectedSchool = currentSelectedSchool.contains(schoolName);

    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: _schoolsInProfile,
        itemBuilder: (BuildContext context, int position) {
          return ListTile(
            title: Text(
              schoolName,
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
                currentSelectedSchool = this.schoolName;
              });
            },
          );
        });
  }

  void navigateToPreviousScreen() {
    Navigator.pop(context);
  }
}
