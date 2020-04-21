import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'item.dart';

class Activity extends StatefulWidget {
  Activity({this.activities, this.type});

  final List<Item> activities;
  final String type;
  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  final FlutterTts _flutterTts = FlutterTts();

  List<String> events = [
    "Outdoor Activity",
    "Indoor Activity",
    "Personal Acitvity",
    "Kitchen Activity"
  ];

  Future _speak(message) async {
    await _flutterTts.setLanguage('en-IN');
    await _flutterTts.speak(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: GridView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                children: widget.activities.map(
                  (activity) {
                    return GestureDetector(
                      child: Card(
                        margin: EdgeInsets.all(15.0),
                        child: _createActivity(activity),
                        elevation: 15.0,
                      ),
                      onTap: () {
                        // _translateText(category);
                        _speak(activity.act);
                      },
                    );
                  },
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _createActivity(Item item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Container(
            child: Stack(
              children: <Widget>[
                Image.asset(item.img, width: 80.0, height: 80.0),
              ],
            ),
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          item.act,
          style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
