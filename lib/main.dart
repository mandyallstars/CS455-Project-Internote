//import the required packages
import 'package:flutter/material.dart';
import 'package:inter_note/loginpage.dart';

//all flutter apps start with main function that calls runApp
void main() => runApp(App());

//App extends a stateful widget and creates a state
class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

//Appstate extends the App class
class AppState extends State<App> {
  //override is used to point out that this method will override ancestor class's method
  @override
  Widget build(BuildContext context) {
    //enclosing the whole app in GestureDetector widget to
    // enable removing focus (and disabling keyboard) when user
    // taps out of a focus widget such as a text field or text form field
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        //material app widget wraps all the sub widgets to build the application
        child: MaterialApp(
          title: 'Internote',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primaryColor: Colors.blueAccent),
          //first call is made to login page to Googlr sign in
          home: LoginPage(),
        ));
  }
}
