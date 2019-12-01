import 'package:flutter/material.dart';

class NotesBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NotesBodyState();
  }
}

class NotesBodyState extends State<NotesBody> {
  static var lectureNumber = [
    'N/A',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
    '31',
    '32',
    '33',
    '34',
    '35',
    '36',
    '37',
    '38',
    '39',
    '40',
    '41',
    '42',
    '43',
    '44',
    '45',
    '46',
    '47',
    '48',
    '49',
    '50',
    '51',
    '52',
    '53',
    '54',
    '55',
    '56',
    '57',
    '58',
    '59',
    '60',
    '61',
    '62',
    '63',
    '64',
    '65',
    '66',
    '67',
    '68',
    '69',
    '70',
    '71',
    '72',
    '73',
    '74',
    '75',
    '76',
    '77',
    '78',
    '79',
    '80',
    '81',
    '82',
    '83',
    '84',
    '85',
    '86',
    '87',
    '88',
    '89',
    '90',
    '91',
    '92',
    '93',
    '94',
    '95',
    '96',
    '97',
    '98',
    '99',
    '100',
    '101',
    '102',
    '103',
    '104',
    '105',
    '106',
    '107',
    '108',
    '109',
    '110',
    '111',
    '112',
    '113',
    '114',
    '115',
    '116',
    '117',
    '118',
    '119',
    '120',
    '121',
    '122',
    '123',
    '124',
    '125',
    '126',
    '127',
    '128',
    '129',
    '130',
    '131',
    '132',
    '133',
    '134',
    '135',
    '136',
    '137',
    '138',
    '139',
    '140',
    '141',
    '142',
    '143',
    '144',
    '145',
    '146',
    '147',
    '148',
    '149',
    '150',
    '151',
    '152',
    '153',
    '154',
    '155',
    '156',
    '157',
    '158',
    '159',
    '160',
    '161',
    '162',
    '163',
    '164',
    '165',
    '166',
    '167',
    '168',
    '169',
    '170',
    '171',
    '172',
    '173',
    '174',
    '175',
    '176',
    '177',
    '178',
    '179',
    '180',
    '181',
    '182',
    '183',
    '184',
    '185',
    '186',
    '187',
    '188',
    '189',
    '190',
    '191',
    '192',
    '193',
    '194',
    '195',
    '196',
    '197',
    '198',
    '199',
    '200'
  ];

  TextEditingController noteTitleController = TextEditingController();
  TextEditingController _noteContentController = TextEditingController();
  final _noteContentFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Note Body Placeholder"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              debugPrint("User Pressed Save Button");
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              debugPrint("User Pressed Delete Button");
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: getNotesBody(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint("FAB Camera pressed");
        },
        tooltip: 'Add Photo',
        child: Icon(Icons.monochrome_photos, color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }

  ListView getNotesBody() {
    return ListView(
      children: <Widget>[
        Padding(
          padding:
              EdgeInsets.only(top: 2.0, bottom: 2.0, left: 2.0, right: 2.0),
          child: Text(
            "Last Modified Placeholder",
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.grey,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15.0, right: 10.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  "Lecture",
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: DropdownButton(
                  items: lectureNumber.map((String lectureDropDownItem) {
                    return DropdownMenuItem<String>(
                      value: lectureDropDownItem,
                      child: Text(lectureDropDownItem),
                    );
                  }).toList(),
                  value: 'N/A',
                  onChanged: (lectureDropDownValue) {
                    setState(() {
                      debugPrint("User selected $lectureDropDownValue");
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding:
              EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
          child: TextField(
              controller: noteTitleController,
              decoration: InputDecoration(
                  labelText: "Topic",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0))),
              onChanged: (noteTitleValue) {
                debugPrint("User entered $noteTitleValue");
              },
            ),
        ),
        Divider(color: Colors.black54),
        Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: EditableText(
            controller: _noteContentController,
            focusNode: _noteContentFocus,
            maxLines: 1000,
            style: TextStyle(color: Colors.black, fontSize: 20),
            backgroundCursorColor: Colors.black,
            cursorColor: Colors.blue,
            selectionColor: Colors.blueAccent,
            paintCursorAboveText: true,
            onChanged: (noteBodyValue) {
              debugPrint("User entered $noteBodyValue");
            },
          ),
        ),
      ],
    );
  }
}
