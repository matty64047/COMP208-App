import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/tabs/home_tab.dart';
import 'package:flutter_app/tabs/inbox_tab.dart';
import 'package:flutter_app/tabs/pinboard_tab.dart';
import '../widgets/widgets.dart';

class Default extends StatefulWidget {
  @override
  _DefaultState createState() => _DefaultState();
}

class _DefaultState extends State<Default> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: appBarAlt(context),
        body: Container(
          decoration: BoxDecoration(
            //color: Colors.white,
              borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(40.0),
                  topRight: const Radius.circular(40.0))),
          child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              Home(),
              Inbox(),
              PinBoard(),
            ],
          ),
        ),
      ),
    );
  }
}
