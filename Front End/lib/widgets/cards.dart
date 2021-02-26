import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/widgets.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:flutter_app/globals.dart' as globals;

class CardStack extends StatefulWidget {

  @override
  _ExampleHomePageState createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<CardStack>
    with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    //controller.triggerLeft()

    return new Center(
      child: Container(
        //height: MediaQuery.of(context).size.height * 0.6,
        child: new TinderSwapCard(
          //swipeUp: true,
          //swipeDown: true,
          orientation: AmassOrientation.BOTTOM,
          totalNum: globals.jobs.length,
          stackNum: 3,
          swipeEdge: 4.0,
          maxWidth: 350,
          maxHeight: 500,
          minWidth: 300,
          minHeight: 450,
          cardBuilder: (context, index) => Card(
            child: jobCard(context, BoxFit.fitHeight)
          ),
          cardController: globals.controller = CardController(),
          swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
            /// Get swiping card's alignment
            if (align.x < 0) {
              //print("Left");
            } else if (align.x > 0) {
              //print("Right");
            }
          },
          swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {
            print(orientation.toString());

            /// Get orientation & index of swiped card
          },
        ),
      ),
    );
  }
}
