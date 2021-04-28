// @dart=2.9

import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'jobs.dart';
import 'account.dart';
import 'saved.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  int _currentIndex = 0;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            //image: DecorationImage(image: AssetImage("assets/images/background.jpg"), fit: BoxFit.fitHeight)
            ),
        child: SizedBox.expand(
          child: PageView(
            physics: new NeverScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: <Widget>[Jobs(), Saved(), Account()],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        //backgroundColor: Colors.transparent,
        containerHeight: 60,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        selectedIndex: _currentIndex,
        showElevation: true,
        // use this to remove appBar's elevation
        onItemSelected: (index) => setState(() {
          _currentIndex = index;
          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 300), curve: Curves.ease);
        }),
        items: [
          BottomNavyBarItem(
            textAlign: TextAlign.center,
            inactiveColor: Colors.grey,
            icon: Icon(Icons.anchor_outlined),
            title: Text('Home'),
            activeColor: Colors.red,
          ),
          BottomNavyBarItem(
              textAlign: TextAlign.center,
              inactiveColor: Colors.grey,
              icon: Icon(Icons.bookmark_border_outlined),
              title: Text('Saved'),
              activeColor: Colors.purpleAccent
          ),
          BottomNavyBarItem(
              textAlign: TextAlign.center,
              inactiveColor: Colors.grey,
              icon: Icon(Icons.people),
              title: Text('Account'),
              activeColor: Colors.pink
          ),
        ],
      ),
    );
  }
}
