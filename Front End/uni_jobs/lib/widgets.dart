// @dart=2.9

import 'package:flutter/material.dart';
import 'Job.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';

List<Color> colours = [Colors.purpleAccent, Colors.red, Colors.blue];

Widget jobCard(BuildContext context, Job job) {
  DecorationImage image = DecorationImage(
      colorFilter: ColorFilter.mode(
          colours[job.id % 3].withOpacity(0.4), BlendMode.srcOver),
      fit: BoxFit.fitWidth,
      image: AssetImage("assets/images/background.jpg"));
  List chips = [];
  Widget icon = Center(child: Text("J", style: TextStyle(fontSize: 50)));
  double imageHeight = 190;
  if (job.daysAgo.length > 1) {
    chips.add(job.daysAgo);
  }
  if (job.salary.length > 1) {
    chips.add(job.salary);
  }
  if (job.ratingCount != null) {
    chips.add(job.ratingCount.toString() + " reviews");
  }
  if (job.workType.length > 1) {
    List workTypes = job.workType.split(",");
    for (String workType in workTypes) {
      chips.add(workType);
    }
  }
  if (job.company.length > 1) {
    icon = Center(child: Text(job.company[0], style: TextStyle(fontSize: 50)));
  }
  if (job.image.length > 1) {
    icon = Image.network(
      job.logo,
      fit: BoxFit.fill,
    );
  }
  if (job.logo.length > 1) {
    image =
        DecorationImage(fit: BoxFit.fitHeight, image: NetworkImage(job.image));
  }
  Widget ratingBar = Container();
  if (job.rating.length > 0) {
    ratingBar = RatingBar.builder(
      initialRating: double.parse(job.rating),
      minRating: 0,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 15,
      itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        print(rating);
      },
    );
  }
  return Container(
    height: double.infinity,
    width: double.infinity,
    child: Stack(
      children: [
        Positioned(
          top: 0,
          child: Container(
            height: imageHeight,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                image: image),
            alignment: Alignment.bottomLeft,
            child: Container(
                width: 350,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: AutoSizeText(
                  job.company.toUpperCase(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                )),
          ),
        ),
        Positioned(
          top: imageHeight + 10,
          left: 10,
          right: 10,
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AutoSizeText(
                    job.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Visibility(
                  visible: true,
                  child: DefaultTextStyle(
                    style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                    child: Wrap(
                      spacing: 3.0,
                      alignment: WrapAlignment.center,
                      children: [
                        Visibility(
                          visible: job.company.length > 0,
                          child: Icon(
                            Icons.work_outline,
                            color: Colors.blue[300],
                            size: 15,
                          ),
                        ),
                        Text(job.company),
                        Visibility(
                          visible: job.location.length > 0,
                          child: Icon(
                            Icons.push_pin,
                            color: Colors.red[300],
                            size: 15,
                          ),
                        ),
                        Text(job.location),
                        ratingBar
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 210,
                  child: Html(
                    data: job.description,
                  ),
                ),
                Wrap(
                  spacing: 3.0,
                  runSpacing: 0.0,
                  alignment: WrapAlignment.center,
                  children: List<Widget>.generate(chips.length, (int index) {
                    return Chip(
                      backgroundColor: Colors.transparent,
                      shape: StadiumBorder(side: BorderSide(width: 0.1)),
                      label: Text(
                        chips[index],
                        style: TextStyle(fontSize: 11),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 20,
          top: 20,
          child: Material(
            elevation: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              height: 80,
              width: 80,
              child: icon,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget savedJobCard(BuildContext context, Job job) {
  Widget icon = Container(
    height: 60,
    width: 60,
  );
  if (job.logo.length > 1) {
    icon = Image.network(job.logo);
  }
  return Card(
    child: ListTile(
      contentPadding: EdgeInsets.all(8),
      title: Text(
        job.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(job.company + " | " + job.location),
      leading: icon,
      trailing: Text(job.salary),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return fullScreen(context, job);
            },
            fullscreenDialog: true,
          ),
        );
      },
      onLongPress: () {},
    ),
  );
}

Widget fullScreen(BuildContext context, Job job) {
  Image image = Image(
      //colorFilter: ColorFilter.mode(colours[job.id % 3].withOpacity(0.4), BlendMode.srcOver),
      fit: BoxFit.fitWidth,
      image: AssetImage("assets/images/background.jpg"));
  List chips = [];
  Widget icon = Center(child: Text("J", style: TextStyle(fontSize: 50)));
  if (job.daysAgo.length > 1) {
    chips.add(job.daysAgo);
  }
  if (job.salary.length > 1) {
    chips.add(job.salary);
  }
  if (job.ratingCount != null) {
    chips.add(job.ratingCount.toString() + " reviews");
  }
  if (job.workType.length > 1) {
    List workTypes = job.workType.split(",");
    for (String workType in workTypes) {
      chips.add(workType);
    }
  }
  if (job.company.length > 1) {
    icon = Center(child: Text(job.company[0], style: TextStyle(fontSize: 50)));
  }
  if (job.image.length > 1) {
    icon = Image.network(
      job.logo,
      fit: BoxFit.fill,
    );
  }
  if (job.logo.length > 1) {
    image = Image(fit: BoxFit.fitHeight, image: NetworkImage(job.image));
  }
  Widget ratingBar = Container();
  if (job.rating.length > 0) {
    ratingBar = RatingBar.builder(
      initialRating: double.parse(job.rating),
      minRating: 0,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 15,
      itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        print(rating);
      },
    );
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  return Scaffold(
      body: NestedScrollView(
        //physics: BouncingScrollPhysics(),
    headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
      return <Widget>[
        SliverAppBar(
          actions: [
            IconButton(
              tooltip: "Open in browser",
              icon: Icon(Icons.open_in_browser),
              onPressed: () {
                _launchURL(job.titleURL);
              },
            ),
          ],
          backgroundColor: Colors.white,
          expandedHeight: 200.0,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              /*title: Text(
                job.company.toUpperCase(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                ),
              ),*/
              background: image),
        ),
      ];
    },
    body: Container(
      height: double.infinity,
      width: double.infinity,
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AutoSizeText(
                      job.title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Visibility(
                    visible: true,
                    child: DefaultTextStyle(
                      style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                      child: Wrap(
                        spacing: 3.0,
                        alignment: WrapAlignment.center,
                        children: [
                          Visibility(
                            visible: job.company.length > 0,
                            child: Icon(
                              Icons.work_outline,
                              color: Colors.blue[300],
                              size: 15,
                            ),
                          ),
                          Text(job.company),
                          Visibility(
                            visible: job.location.length > 0,
                            child: Icon(
                              Icons.push_pin,
                              color: Colors.red[300],
                              size: 15,
                            ),
                          ),
                          Text(job.location),
                          ratingBar
                        ],
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 3.0,
                    runSpacing: 0.0,
                    alignment: WrapAlignment.center,
                    children: List<Widget>.generate(chips.length, (int index) {
                      return Chip(
                        backgroundColor: Colors.transparent,
                        shape: StadiumBorder(side: BorderSide(width: 0.1)),
                        label: Text(
                          chips[index],
                          style: TextStyle(fontSize: 11),
                        ),
                      );
                    }),
                  ),
                  Container(
                    child: Html(
                      data: job.description,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  ));
}
