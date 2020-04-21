import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';
import 'activities.dart';
import 'item.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Express Me',
      color: Colors.black,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          primaryColor: debugDefaultTargetPlatformOverride == TargetPlatform.iOS
              ? Colors.grey[50]
              : null),
      home: MyHomePage(title: 'Express Me'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String trTxt = "";
  String languageChoice = 'en-IN';

  final GoogleTranslator _translator = GoogleTranslator();
  List<String> events = [
    "Outdoor Activity",
    "Indoor Activity",
    "Personal Acitvity",
    "Kitchen Activity"
  ];
  final FlutterTts _flutterTts = FlutterTts();

  final List<Item> outdoor = [
    Item('Take a Walk', 'assets/outdoor/outdoor_1.png'),
    Item('Water Plants', 'assets/outdoor/outdoor_2.png'),
    Item('Take dog for a round', 'assets/outdoor/outdoor_3.png'),
    Item('Play with Ball', 'assets/outdoor/outdoor_4.png'),
    Item('Visit Garden', 'assets/outdoor/outdoor_5.png'),
    Item('Set up a picnic in lawn', 'assets/outdoor/outdoor_6.png')
  ];

  final List<Item> indoor = [
    Item('Listen to Music', 'assets/indoor/indoor_1.png'),
    Item('Watch TV', 'assets/indoor/indoor_2.png'),
    Item('Play with puzzle', 'assets/indoor/indoor_3.png'),
    Item('Take a bath', 'assets/indoor/indoor_4.png'),
    Item('Brush Teeth', 'assets/indoor/indoor_5.png'),
    Item('Read Newspaper', 'assets/indoor/indoor_6.png'),
  ];

  final List<Item> personal = [
    Item('Comb hair', 'assets/personal/personal_1.png'),
    Item('Shave', 'assets/personal/personal_2.png')
  ];
  final List<Item> kitchen = [
    Item('Prepare Food', 'assets/kitchen/kitchen_1.png'),
    Item('Prepare Tea', 'assets/kitchen/kitchen_2.png'),
    Item('Bake Bread', 'assets/kitchen/kitchen_3.png')
  ];

  void _translateText(category) {
    _translator.translate(category, to: 'hi').then((output) {
      setState(() {
        trTxt = output;
      });
      print(trTxt);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('Girish Thatte'),
              accountEmail: Text('girishthatte35@gmail.com'),
              // currentAccountPicture: CircleAvatar(
              //   backgroundImage: NetworkImage(widget.firebaseUser.photoUrl),
              // ),
            ),
            ListTile(
              title: Text('Reminders'),
              leading: Icon(
                FontAwesomeIcons.clock,
                size: 28,
                color: Colors.red[600],
              ),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => MyRecipePage(
                //       firebaseUser: widget.firebaseUser,
                //     ),
                //   ),
                // );
              },
            ),
            ListTile(
              title: Text('Account'),
              leading: Icon(
                Icons.account_box,
                size: 28,
                color: Colors.deepPurple,
              ),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) =>
                //         Profile(firebaseUser: widget.firebaseUser),
                //   ),
                // );
              },
            ),
            ListTile(
              title: Text('Settings'),
              leading: Icon(
                Icons.settings,
                size: 28,
                color: Colors.grey[700],
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              title: Text('Logout'),
              leading: Icon(
                FontAwesomeIcons.signOutAlt,
                size: 24,
                color: Colors.deepPurple,
              ),
              onTap: () {
                // logoutDialog(context);
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.pinkAccent[100],
        child: Container(
          margin: EdgeInsets.only(top: 100.0),
          child: GridView(
            physics: BouncingScrollPhysics(),
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            children: events.map(
              (category) {
                return GestureDetector(
                  child: Card(
                    margin: EdgeInsets.all(15.0),
                    child: getItemsByTitle(category),
                    // color: Colors.amberAccent,
                    elevation: 15.0,
                  ),
                  onTap: () {
                    // _translateText(category);
                    _speak('You clicked ' + category);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Activity(
                            activities: _dataSender(category), type: category),
                      ),
                    );
                  },
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }

  Column getItemsByTitle(String category) {
    String img = "assets/";
    if (category == 'Outdoor Activity')
      img += 'outdoor/outdoor.jpg';
    else if (category == 'Indoor Activity')
      img += 'indoor/indoor.jpg';
    else if (category == 'Personal Acitvity')
      img += 'personal/personal.png';
    else
      img += 'kitchen/kitchen.png';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Container(
            child: Stack(
              children: <Widget>[
                Image.asset(img, width: 80.0, height: 80.0),
              ],
            ),
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          category,
          style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Future _speak(message) async {
    // print(await _flutterTts.getLanguages);
    // print(await _flutterTts.getVoices);
    await _flutterTts.setLanguage(languageChoice);
    await _flutterTts.speak(message);
  }

  List<Item> _dataSender(category) {
    List<Item> activities;
    if (category == 'Outdoor Activity')
      activities = outdoor;
    else if (category == 'Indoor Activity')
      activities = indoor;
    else if (category == 'Personal Acitvity')
      activities = personal;
    else
      activities = kitchen;
    return activities;
  }
}
