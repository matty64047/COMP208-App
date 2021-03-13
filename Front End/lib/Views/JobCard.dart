import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_flutter/data/GetInfo.dart';
import '../data/Job.dart';

List<Color> colours = [Colors.purpleAccent, Colors.red, Colors.blue];

Widget jobCard(BuildContext context, Job job) {
  double imageHeight = 250;
  return Container(
    //height: double.infinity,
    //width: double.infinity,
    child: Stack(
      children: [
        Positioned(
          top: 40,
          right: 30,
          child: Text(
            job.titleURL,
            style: TextStyle(color: Colors.white),
          ),
        ),
        Positioned(
          bottom: 40,
          left: 30,
          child: Text(
            job.date,
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Positioned(
          top: imageHeight,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            width: 380,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job.title,
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20, height: 1),
                ),
                Text(
                  job.titleURL,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Container(
                  height: 20,
                ),
                Text(job.salary, style: TextStyle(color: Colors.grey[700]),),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          child: Container(
            height: imageHeight,
            width: MediaQuery.of(context).size.width * 0.915,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5), topRight: Radius.circular(5)),
              image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      colours[job.id % 3].withOpacity(0.4), BlendMode.srcOver),
                  fit: BoxFit.fitWidth,
                  image: AssetImage("assets/images/background.jpg")),
            ),
            alignment: Alignment.bottomLeft,
            child: Container(
                width: 350,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Text(
                  job.company.toUpperCase(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                )),
          ),
        )
      ],
    ),
  );
}

Widget savedJobCard(BuildContext context, Job job) {
  double imageHeight = MediaQuery.of(context).size.height*0.1;
  return Card(
    child: Container(
      //height: double.infinity,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*0.25,
      child: Stack(
        children: [
          Positioned(
            top: 40,
            right: 30,
            child: Text(
              job.titleURL,
              style: TextStyle(color: Colors.white),
            ),
          ),
          Positioned(
            bottom: 15,
            left: 15,
            child: Text(
              job.date,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Positioned(
            top: imageHeight,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
              width: 380,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job.title,
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20, height: 1),
                  ),
                  Text(
                    job.titleURL,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
              height: imageHeight,
              width: MediaQuery.of(context).size.width*0.983,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        colours[job.id % 3].withOpacity(0.4), BlendMode.srcOver),
                    fit: BoxFit.fitWidth,
                    image: AssetImage("assets/images/background.jpg")),
              ),
              alignment: Alignment.bottomLeft,
              child: Container(
                  width: 350,
                  padding: EdgeInsets.only(left: 10, bottom: 3),
                  child: Text(
                    job.company.toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  )),
            ),
          )
        ],
      ),
    ),
  );
}

Widget savedJobCardAlt(BuildContext context, Job job) {
  return Padding(
    padding: const EdgeInsets.only(left: 10, right: 10),
    child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
            //minVerticalPadding: 10,
            isThreeLine: true,
            dense: false,
            leading: Image.asset(
              "assets/images/tiptrans-logo-sq-fb.png",
            ),
            title: Text(job.title),
            subtitle: Text(job.titleURL),
            trailing: PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.more_vert),
              onSelected: (selection) {
                if (selection == 'Delete') {
                  unFavourite(job.id);
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                    value: 'Delete',
                    child: ListTile(
                        leading: Icon(Icons.delete), title: Text('Delete')))
              ],
            ))),
  );
}

class FullScreenJob extends StatelessWidget {
  final Job job;

  FullScreenJob({Key key, @required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Hero(
        tag: job.title,
        child: Center(
          child: Text(
            job.title,
            style: TextStyle(),
          ),
        ),
      ),
    );
  }
}
