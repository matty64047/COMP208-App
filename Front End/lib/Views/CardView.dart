import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'JobCard.dart';
import '../data/GetInfo.dart';
import '../data/Job.dart';
import 'package:spring_button/spring_button.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'WebView.dart';

class CardView extends StatefulWidget {
  @override
  _CardViewState createState() => _CardViewState();
}

class _CardViewState extends State<CardView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool filtersExpanded = false;
  int currentCardIndex = 0;
  double leftSwipe = 0, rightSwipe = 0;
  double value = 0;
  int _value = 0;

  void onChanged(double newValue) {
    setState(() {
      value = newValue;
    });
  }

  double getHeight() {
    if (filtersExpanded)
      return (MediaQuery.of(context).size.height * 0.8);
    else
      return 80;
  }

  Icon getIcon() {
    if (filtersExpanded)
      return Icon(Icons.expand_less);
    else
      return Icon(Icons.expand_more);
  }

  Future getJobsList() async {
    List<Job> jobs = await getJobs();
    if (!streamController.isClosed) streamController.sink.add(jobs);
  }

  CardController controller;
  final streamController = StreamController<List<Job>>();

  @override
  void initState() {
    super.initState();
    getJobsList();
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  double getOpacity(index, double) {
    if (index == currentCardIndex)
      return double;
    else
      return 0;
  }

  void _onRefresh() async {
    await getJobsList();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Padding(
      padding: EdgeInsets.only(top: 10),
      /*child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        header: ClassicHeader(),
        controller: _refreshController,*/
      child: Container(
        height: MediaQuery.of(context).size.height * 0.95,
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Card(
                child: AnimatedContainer(
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  height: getHeight(),
                  duration: Duration(milliseconds: 500),
                  curve: Curves.ease,
                  child: Stack(
                    children: [
                      Positioned(
                        child: AnimatedOpacity(
                          opacity: filtersExpanded ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 100),
                          child: Image.asset("assets/images/filter.jpg", height: 150, width: 150,),
                        ),
                        bottom: 0,
                        left: 10,
                        //right: 10,
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Filters",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              IconButton(
                                icon: getIcon(),
                                onPressed: () {
                                  setState(() {
                                    filtersExpanded = !filtersExpanded;
                                  });
                                },
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 6, bottom: 5),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Select job filters",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15),
                            ),
                          ),
                          Expanded(
                            child: AnimatedOpacity(
                              opacity: filtersExpanded ? 1.0 : 0.0,
                              duration: Duration(milliseconds: 300),
                              child: Container(
                                height: 300,
                                child: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    Slider(value: value, onChanged: onChanged),
                                    Wrap(
                                      spacing: 9,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      alignment: WrapAlignment.center,
                                      children: List<Widget>.generate(
                                        10,
                                        (int index) {
                                          return FilterChip(
                                            labelStyle: TextStyle(fontSize: 15),
                                            selectedColor:
                                                Colors.deepPurpleAccent,
                                            label: Text('Item $index'),
                                            selected: _value == index,
                                            onSelected: (bool selected) {
                                              setState(() {
                                                _value =
                                                    selected ? index : null;
                                              });
                                            },
                                          );
                                        },
                                      ).toList(),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            StreamBuilder(
              stream: streamController.stream,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return new Container(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.75,
                      child: new TinderSwapCard(
                        swipeUp: false,
                        swipeDown: false,
                        orientation: AmassOrientation.BOTTOM,
                        totalNum: snapshot.data.length,
                        stackNum: 3,
                        //swipeEdge: 4.0,
                        animDuration: 200,
                        maxWidth: MediaQuery.of(context).size.width * 0.95,
                        maxHeight: MediaQuery.of(context).size.height * 0.75,
                        minWidth: MediaQuery.of(context).size.width * 0.9,
                        minHeight: MediaQuery.of(context).size.height * 0.7,
                        cardBuilder: (context, index) => Hero(
                          tag: snapshot.data[index].title,
                          child: Card(
                            child: Stack(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return CardHero(
                                              job: snapshot.data[index]);
                                        },
                                        fullscreenDialog: true,
                                      ),
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      jobCard(context, snapshot.data[index]),
                                      Opacity(
                                        opacity: getOpacity(index, rightSwipe),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          height: double.infinity,
                                          width: double.infinity,
                                        ),
                                      ),
                                      Opacity(
                                        opacity: getOpacity(index, leftSwipe),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          height: double.infinity,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  right: 20,
                                  //left: 20,
                                  child: SpringButton(
                                    SpringButtonType.OnlyScale,
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      color: Colors.deepPurpleAccent,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15.0, horizontal: 30),
                                        child: Text(
                                          "Save Job",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    //scaleCoefficient: 1,
                                    onTap: () {
                                      favourite(snapshot.data[index].id);
                                      controller.triggerRight();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        cardController: controller = CardController(),
                        swipeUpdateCallback:
                            (DragUpdateDetails details, Alignment align) {
                          /// Get swiping card's alignment
                          if (align.x.abs() > 3 && align.x < 0) {
                            if (align.x.abs() / 20 > 1)
                              leftSwipe = 1;
                            else
                              leftSwipe = (align.x.abs() - 3) / 20;
                          } else if (align.x.abs() > 3 && align.x > 0) {
                            if (align.x.abs() / 20 > 1)
                              rightSwipe = 1;
                            else
                              rightSwipe = (align.x.abs() - 3) / 20;
                          } else {
                            leftSwipe = 0;
                            rightSwipe = 0;
                          }
                        },
                        swipeCompleteCallback:
                            (CardSwipeOrientation orientation, int index) {
                          Job job = snapshot.data[index];
                          if (orientation == CardSwipeOrientation.RIGHT)
                            like(job.id);
                          if (orientation == CardSwipeOrientation.LEFT)
                            dislike(job.id);
                          if (orientation != CardSwipeOrientation.RECOVER)
                            currentCardIndex = index + 1;
                          if (snapshot.data.length < 3) getJobsList();
                          leftSwipe = 0;
                          rightSwipe = 0;
                        },
                      ),
                    ),
                  );
                }
                if (snapshot.hasError)
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
      //),
    );
  }
}
