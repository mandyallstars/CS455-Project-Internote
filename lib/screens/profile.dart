import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:inter_note/screens/profileScreens/school_select.dart';

class Profile extends StatefulWidget {

  const Profile({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProfileState();
  }
}

class ProfileState extends State<Profile> {
  final _minimumPadding = 5.0;

  final TextEditingController _nameController = TextEditingController();
  FocusNode _nameFocusNode;

  int _thisSchoolCoursesCount = 10;

  @override
  void initState() {
    super.initState();

    _nameFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _nameFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: getProfilePage(),
    );
  }

  Container getProfilePage() {
    return Container(
      margin: EdgeInsets.all(_minimumPadding * 2),
      child: ListView(
        children: <Widget>[
          getProfileImageAsset(),
          Divider(color: Colors.black54),
          TextField(
            controller: _nameController,
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
              debugPrint("User entered $nameValue");
            },
          ),
          Divider(color: Colors.white),
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
          getThisSchoolCourses()
        ],
      ),
    );
  }

  InkWell getCurrentSchoolInfo() {
    return InkWell(
      customBorder: Border(
          top: BorderSide(width: 5.0, color: Colors.black),
          bottom: BorderSide(width: 5.0, color: Colors.black)),
      child: Container(
        child: Padding(
          padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: Row(
            children: <Widget>[
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
              Expanded(
                  child: Container(
                margin: EdgeInsets.only(right: _minimumPadding),
                child: Text(
                  "University of Saskatchewan",
                  style: TextStyle(color: Colors.blueGrey, fontSize: 18),
                  textDirection: TextDirection.rtl,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                ),
              )),
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
        debugPrint("School tapped");
        navigateToSchoolList('Edit School');
      },
    );
  }

  ListView getThisSchoolCourses() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: _thisSchoolCoursesCount,
      itemBuilder: (BuildContext context, int position) {
        return ListTile(
          title: Text(
            "Course Title Placeholder",
            style: TextStyle(color: Colors.black, fontSize: 20.0),
            textDirection: TextDirection.ltr,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }

  Widget getProfileImageAsset() {
    AssetImage assetImage = AssetImage('images/profilePhotoPlaceholder.png');

    Image image = Image(
      image: assetImage,
      width: 260.0,
      height: 260.0,
    );

    return Container(
      child: image,
    );
  }

  void navigateToSchoolList(String appBarTitle) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SchoolList(appBarTitle);
    }));
  }

}
