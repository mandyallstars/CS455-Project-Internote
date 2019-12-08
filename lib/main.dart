import 'package:flutter/material.dart';
import 'package:inter_note/loginpage.dart';
import 'home_widget.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AppState();
  }
}

class AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: MaterialApp(
          title: 'Internote',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primaryColor: Colors.blueAccent),
          home: LoginPage(),
          routes: <String, WidgetBuilder> {
            '/homePage': (BuildContext context) => HomePage(),
            '/landingPage': (BuildContext context) => LoginPage()
          }
        ));
  }
}
