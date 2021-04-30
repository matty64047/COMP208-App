import 'dart:async';
import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'Start/Onboarding.dart';
import 'package:test_flutter/data/Database.dart';
import 'Start/Home.dart';

void main() => runApp(MaterialApp(home: Example()));

class Example extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
        backgroundColor: Colors.grey[200],
      ),
      home: DefaultBottomBarController(
        child: MyHomePage(),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

final streamController = StreamController<bool>();

Future checkUser() async {
  dynamic user = await DBProvider.db.getUser();
  if (user!=false) {
    streamController.sink.add(true);
  }
  else streamController.sink.add(false);
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: streamController.stream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          if (snapshot.data) {
            return Home();
          }
          else return Onboarding();
        }
        else return Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
          child: Center(
            child: Icon(Icons.anchor_outlined, color: Colors.black, size: 70,)
          ),
        );
      },

    );
  }

}