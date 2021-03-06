import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:test_flutter/data/User.dart';
import '../Views/AccountView.dart';
import '../Views/CardView.dart';
import '../Views/SavedView.dart';

double sliderValue = 0;
var dropdownValue = 'Choose a city';
var value = 0;

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin{
  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
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
            physics:new NeverScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: <Widget>[
              CardView(),
              Saved(),
              ProfilePage()
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        containerHeight: 60,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        selectedIndex: _currentIndex,
        showElevation: true, // use this to remove appBar's elevation
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
      )
    );
  }
}
