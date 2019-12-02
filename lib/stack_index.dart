import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Destination {
  const Destination(this.title, this.icon, this.color);
  final String title;
  final IconData icon;
  final Color color;
}

const List<Destination> allDestinations = <Destination>[
  Destination('Profile', Icons.person, Colors.white),
  Destination('Courses', Icons.school, Colors.blue),
  Destination('Notes', Icons.description, Colors.purple),
];

class RootPage extends StatelessWidget {
  const RootPage({Key key, this.destination}) : super(key: key);

  final Destination destination;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(destination.title, style: TextStyle(color: Colors.black),),
        backgroundColor: destination.color,
      ),
      backgroundColor: destination.color,
      body: SizedBox.expand(
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, "/list");
          },
        ),
      ),
    );
  }
}

class ListPage extends StatelessWidget {
  const ListPage({Key key, this.destination}) : super(key: key);

  final Destination destination;

  @override
  Widget build(BuildContext context) {
    const List<int> shades = <int>[50, 100, 200, 300, 400, 500, 600, 700, 800, 900];
    // TODO: implement build
    return Scaffold (
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(destination.title, style: TextStyle(color: Colors.black)),
        backgroundColor: destination.color,
      ),
      backgroundColor: destination.color,
      body: SizedBox.expand(
        child: ListView.builder(
          itemCount: shades.length,
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 128,
              child: Card(
                color: destination.color,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "/text");
                  },
                  child: Center(
                    child: Text('Item $index', style: TextStyle(color: Colors.black)),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class TextPage extends StatefulWidget {
  const TextPage({Key key, this.destination}) : super(key: key);

  final Destination destination;

  @override
  _TextPageState createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController (
      text: 'sample text: ${widget.destination.title}',
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(widget.destination.title, style: TextStyle(color: Colors.black),),
        backgroundColor: widget.destination.color,
      ),
      backgroundColor: widget.destination.color,
      body: Container(
        padding: const EdgeInsets.all(32.0),
        alignment: Alignment.center,
        child: TextField(controller: _textController, style: TextStyle(color: Colors.black),),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

}

class DestinationView extends StatefulWidget {
  const DestinationView({Key key, this.destination}) : super(key: key);
  final Destination destination;

  @override
  _DestinationViewState createState() => _DestinationViewState();
}

class _DestinationViewState extends State<DestinationView> {

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            switch(settings.name) {
              case '/':
                return RootPage(destination: widget.destination);
              case '/list':
                return ListPage(destination: widget.destination);
              case '/text':
                return TextPage(destination: widget.destination);
            }
          },
        );
      },
    );
  }
}

/*void main() {
  runApp(MaterialApp(home: HomePage(), debugShowCheckedModeBanner: false));
}*/