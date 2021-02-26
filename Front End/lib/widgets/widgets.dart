import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/views/account_view.dart';
import 'package:flutter_app/views/job_view.dart';

// App Bar
PreferredSize customAppBar(BuildContext context) {
  double statusBarHeight = MediaQuery.of(context).padding.top;
  return PreferredSize(
    preferredSize: Size.fromHeight(120),
    child: Container(
      //padding: EdgeInsets.only(top: 25),
      child: Column(
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black54,
                    blurRadius: 5.0,
                    offset: Offset(0.0, 0.75))
              ],
            ),
            child: Container(
              padding: EdgeInsets.only(top: statusBarHeight),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset("assets/download.png"),
                  Text(
                    "B    R    I    D    G    E",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  InkWell(
                    child: IconButton(
                      icon: Icon(Icons.account_circle),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountPage()),
                        );
                      },
                      splashColor: Colors.transparent,
                      splashRadius: 1,
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20),
            child: Theme(
              data: ThemeData(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent),
              child: TabBar(
                unselectedLabelColor: Colors.black,
                labelColor: Colors.orange,
                indicatorColor: Colors.transparent,
                tabs: [
                  Text("HOME"),
                  Text("INBOX"),
                  Text("PINBOARD"),
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}

// App Bar v2
AppBar appBarAlt(BuildContext context) {
  return AppBar(
    centerTitle: true,
    title: Text(
      "B    R    I    D    G    E",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    actions: [
      IconButton(
        icon: Icon(Icons.account_circle),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AccountPage()),
          );
        },
      ),
    ],
    leading: Container(
        padding: EdgeInsets.only(left: 10),
        child: Image.asset("assets/download.png")),
    bottom: TabBar(
      tabs: [
        Tab(text: "HOME"),
        Tab(text: "INBOX"),
        Tab(text: "PINBOARD"),
      ],
    ),
  );
}

//Job Card
Widget jobCard(context, fit) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Job()),
      );
    },
    child: Card(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 170,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: fit,
            image: AssetImage("assets/welcome0.jpg"),
          ),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Opacity(
              opacity: 0.6,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 9.0, sigmaY: 9.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 70,
              child: Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Starbucks",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Text(
                      "It returns the truncated remainder after dividing\nthe two numbers.",
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
