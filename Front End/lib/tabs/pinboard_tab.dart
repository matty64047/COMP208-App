import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/widgets.dart';
import '../views/job_view.dart';

class PinBoard extends StatefulWidget {
  @override
  _PinBoardState createState() => _PinBoardState();
}

class _PinBoardState extends State<PinBoard> {
  double _sigmaX = 0.5; // from 0-10
  double _sigmaY = 0.5; // from 0-10
  double _opacity = 0.1; // from 0-1.0

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 0),
      child: ListView.separated(
        separatorBuilder: (context, index) {
          if (index.remainder(5) == 0) {
            return Divider(
              indent: 10,
              endIndent: 10,
              thickness: 2,
            );
          } else
            return Container();
        },
        itemCount: 10,
        itemBuilder: (context, index) {
          if (index == 0)
            return Text(
              "This is where all the jobs you favourite will appear.\nFrom here you can apply to jobs and check your application status.",
              style: TextStyle(),
              textAlign: TextAlign.center,
            );
          else
            return jobCard(context, BoxFit.fitWidth);
        },
      ),
    );
  }
}
