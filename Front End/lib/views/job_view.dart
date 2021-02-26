import 'package:flutter/material.dart';
import 'package:flutter_app/globals.dart' as globals;
import '../data/jobs.dart' as jobs;

class Job extends StatefulWidget {
  @override
  _JobState createState() => _JobState();
}

class _JobState extends State<Job> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Starbucks"),
      ),
      body: Column(
        children: [
          Container(
            //child: Image.network(jobs.job.photo),
          ),
        ],
      ),
    );
  }
}
