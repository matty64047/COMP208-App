// @dart=2.9

import 'dart:async';
import 'package:spring_button/spring_button.dart';
import 'package:flutter/material.dart';
import 'package:uni_jobs/HTTP.dart';
import 'package:uni_jobs/widgets.dart';
import '../User.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import '../Job.dart';
import "package:collection/collection.dart";

class Jobs extends StatefulWidget {
  @override
  _JobsState createState() => _JobsState();
}

class _JobsState extends State<Jobs> with TickerProviderStateMixin {
  int currentCardIndex = 0;
  double leftSwipe = 0, rightSwipe = 0;
  double value = 0;
  CardController controller = new CardController();
  final streamController = StreamController<List>();
  TabController _tabController;
  List params = [
    {"request_type": "recommended"},
    {"request_type": "most_popular"},
    {"request_type": "all"}
  ];
  List titles = ["Recommended", "Most Popular", "Filter"];
  String title = "";
  Map<String, String> param = {};
  User user = User();

  void onChanged(double newValue) {
    setState(() {
      value = newValue;
    });
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

  Future getJobsList() async {
    List<Job> jobs =
        await getJobs(email: user.email, password: user.password, param: param);
    if (!streamController.isClosed) streamController.sink.add(jobs);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      user = Provider.of<User>(context, listen: false);
      getJobsList();
    });
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
      } else {
        setState(() {
          title = titles[_tabController.index];
        });
        currentCardIndex = 0;
        param = params[_tabController.index];
        if (_tabController.index == 2) {
          _settingModalBottomSheet(context);
        } else {
          streamController.addError(Exception());
        }
      }
    });
    param = params[0];
    title = titles[0];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(builder: (context, user, child) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(90),
          child: Material(
            elevation: 10,
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).padding.top + 10,
                ),
                Container(
                  width: 300,
                  child: TabBar(
                    labelColor: Colors.white,
                    unselectedLabelColor: Theme.of(context).primaryColor,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle),
                    controller: _tabController,
                    tabs: [
                      Tab(
                        icon: Icon(
                          Icons.bolt,
                          size: 35,
                        ),
                      ),
                      Tab(
                        icon: Icon(
                          Icons.trending_up,
                          size: 35,
                        ),
                      ),
                      Tab(
                        icon: Icon(
                          Icons.lightbulb_outline,
                          size: 35,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w200),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          /*decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(""),
                  fit: BoxFit.fitWidth
              )
          ),*/
          child: StreamBuilder(
            stream: streamController.stream,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                getJobsList();
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.connectionState == ConnectionState.done) {}
              if (snapshot.hasError) {
                return Center(
                  child: IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      getJobsList();
                    },
                  ),
                );
              }
              return new Container(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.77,
                  child: new TinderSwapCard(
                    swipeUp: false,
                    swipeDown: false,
                    orientation: AmassOrientation.BOTTOM,
                    totalNum: snapshot.data.length,
                    stackNum: 2,
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
                                      return fullScreen(context, snapshot.data[index]);
                                    },
                                    fullscreenDialog: true,
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  Center(
                                      child: jobCard(
                                          context, snapshot.data[index])),
                                  Opacity(
                                    opacity: getOpacity(index, rightSwipe),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(3, 226, 107, 0.8),
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
                                          color:
                                              Color.fromRGBO(255, 72, 72, 0.8),
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
                                      "Apply",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                //scaleCoefficient: 1,
                                onTap: () {
                                  rateJob(
                                      email: user.email,
                                      password: user.password,
                                      rating: 2,
                                      jobID: snapshot
                                          .data[index].id); //favourite Job
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
                      if (orientation == CardSwipeOrientation.RIGHT) {
                        rateJob(
                            email: user.email,
                            password: user.password,
                            rating: 1,
                            jobID: job.id); //like job
                      }
                      if (orientation == CardSwipeOrientation.LEFT) {
                        rateJob(
                            email: user.email,
                            password: user.password,
                            rating: -1,
                            jobID: job.id); //dislike job
                      }
                      if (orientation != CardSwipeOrientation.RECOVER)
                        currentCardIndex = index + 1;
                      if (index == snapshot.data.length - 1) {
                        streamController.sink.addError(Exception());
                      }
                      leftSwipe = 0;
                      rightSwipe = 0;
                    },
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: false,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: FutureBuilder(
                future: getJobs(
                    email: user.email, password: user.password, param: param),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Container();
                  } else {
                    List<Job> finalJobsList = [];
                    Map<String, List<Job>> newMap = groupBy(snapshot.data as List<Job>, (obj) => obj.company);
                    List companies = newMap.keys.toList();
                    companies.sort();
                    List isSelected = new List.filled(companies.length, false,
                        growable: false);
                    return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        children: [
                          Expanded(
                            child: ListView(
                              physics: BouncingScrollPhysics(),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new Wrap(
                                    alignment: WrapAlignment.center,
                                    children: List<Widget>.generate(
                                        companies.length, (int index) {
                                      return ChoiceChip(
                                        selected: isSelected[index],
                                        onSelected: (selected) {
                                          setState(() {
                                            isSelected[index] =
                                                !isSelected[index];
                                          });
                                        },
                                        backgroundColor: Colors.transparent,
                                        shape: StadiumBorder(
                                            side: BorderSide(width: 0.1)),
                                        label: Text(
                                          companies[index],
                                          style: TextStyle(fontSize: 11),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary:
                                  Theme.of(context).primaryColor, // background
                              onPrimary: Colors.white, // foreground
                            ),
                            onPressed: () {
                              for (int i = 0; i < isSelected.length; i++) {
                                if (isSelected[i]) {
                                  finalJobsList = finalJobsList+newMap[companies[i]];
                                }
                              }
                              streamController.sink.add(finalJobsList);
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              child: Text(
                                "Apply",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      );
                    });
                  }
                }),
          );
        });
  }
}
