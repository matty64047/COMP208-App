import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:bridge/card_hero.dart';
import 'package:flutter/gestures%20(1).dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/cupertino%20(1).dart';
import 'package:flutter/rendering%20(1).dart';
import 'package:flutter/services%20(1).dart';
import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'favourites.dart' as Favourites;
import 'package:overlay_support/overlay_support.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

void main() {
  runApp(MyApp());
}

double sliderValue = 0;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        title: 'Bridge',
        theme: ThemeData(
          primaryColor: Colors.white,
          backgroundColor: Colors.grey[200],
        ),
        home: MyHomePage(title: 'Bridge'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Job>> jobList;
  int _focusedIndex = 0;
  ScrollController scrollController;
  List colours = [
    [Color(0xFFcc2b5e), Color(0xFF753a88)],
    [Color(0xFFeb3349), Color(0xFFf45c43)],
    [Color(0xFFeecda3), Color(0xFFef629f)],
    [Color(0xFF02aab0), Color(0xFF00cdac)],
    [Color(0xFF7b4397), Color(0xFFdc2430)],
    [Color(0xFF43cea2), Color(0xFF185a9d)],
    [Color(0xFFff512f), Color(0xFFdd2476)],
    [Color(0xFF4568dc), Color(0xFFb06ab3)],
    [Color(0xFFc33764), Color(0xFF1d2671)]
  ];
  final _random = new Random();
  List card_colours;
  final _streamController = StreamController<List<Job>>();
  SlidableController _slidableController;
  String dropdownValue = 'Choose a city';
  int _value = 1;

  Future getJobsList() async {
    final response = await http.get('http://192.168.0.2:5000');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List<Job> list = new List();
      var jsonList = jsonDecode(response.body) as List;
      jsonList.forEach((e) {
        list.add(Job.fromJson(e));
      });
      for (var i = 0; i < list.length; i++) {
        card_colours.add(colours[_random.nextInt(colours.length)]);
      }
      _streamController.sink.add(list);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      _streamController.sink.addError("No data, trying again");
      throw Exception("Couldn't connect to server");
    }
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  Future<void> _onItemFocus(int index) async {
    setState(() {
      _focusedIndex = index;
    });
    if (await Vibration.hasCustomVibrationsSupport()) {
      Vibration.vibrate(duration: 20, amplitude: 10);
    } else {}
  }

  @override
  void initState() {
    super.initState();
    getJobsList();
    scrollController = new ScrollController();
    _slidableController = new SlidableController();
    scrollController.addListener(() {});
    card_colours = [];
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
              ),
            ),
            Positioned(
              top: 115,
              left: 20,
              child: Text(
                "Hi Matt,\nFind your Student Job",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            StreamBuilder(
              stream: _streamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Stack(
                    children: [
                      Container(
                        child: ScrollConfiguration(
                          behavior: MyBehavior(),
                          child: ScrollSnapList(
                            initialIndex: 1,
                            listController: scrollController,
                            onItemFocus: _onItemFocus,
                            //selectedItemAnchor: SelectedItemAnchor.START,
                            itemSize:
                                MediaQuery.of(context).size.width * 0.8 + 30,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                padding: EdgeInsets.all(15),
                                child: Dismissible(
                                  direction: DismissDirection.vertical,
                                  onDismissed:
                                      (DismissDirection direction) async {
                                    if (direction == DismissDirection.down) {
                                      print("Add to favorite");
                                      Favourites.favourites
                                          .add(snapshot.data[index]);
                                    } else {
                                      print('Remove item');
                                    }
                                    if (await Vibration
                                        .hasCustomVibrationsSupport()) {
                                      Vibration.vibrate(
                                          duration: 50, amplitude: 30);
                                    } else {}
                                    setState(() {
                                      snapshot.data.removeAt(index);
                                      card_colours.removeAt(index);
                                    });
                                  },
                                  key: UniqueKey(),
                                  child: Hero(
                                    tag: "card$index",
                                    child: Container(
                                      padding:
                                          EdgeInsets.only(top: 190, bottom: 85),
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return new CardHero(
                                                    job: snapshot.data[index],
                                                  );
                                                },
                                                fullscreenDialog: true,
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: Stack(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(20),
                                                  decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                          begin:
                                                              Alignment.topLeft,
                                                          end: Alignment
                                                              .bottomRight,
                                                          colors: card_colours[
                                                              index]),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Visibility(
                                                            visible: snapshot
                                                                    .data[index]
                                                                    .titleURL
                                                                    .length >
                                                                0,
                                                            //TODO: change for icon url
                                                            child: Container(
                                                              width: 80,
                                                              height: 80,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                image:
                                                                    DecorationImage(
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        image:
                                                                            NetworkImage(
                                                                          "https://image.shutterstock.com/image-photo/kiev-ukraine-march-31-2015-260nw-275940803.jpg",
                                                                        )),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 10),
                                                            child: Visibility(
                                                              visible: snapshot
                                                                      .data[
                                                                          index]
                                                                      .salary
                                                                      .length >
                                                                  0,
                                                              child: Text(
                                                                snapshot
                                                                    .data[index]
                                                                    .salary,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                            .grey[
                                                                        100]),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Visibility(
                                                        visible: snapshot
                                                                .data[index]
                                                                .title
                                                                .length >
                                                            0,
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 10,
                                                                  bottom: 5),
                                                          child: Text(
                                                            snapshot.data[index]
                                                                .title,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 30,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ),
                                                      Wrap(children: [
                                                        Text(
                                                          snapshot.data[index]
                                                              .field1,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey[200],
                                                              fontSize: 15),
                                                        ),
                                                        Visibility(
                                                          visible: snapshot
                                                                      .data[
                                                                          index]
                                                                      .field1
                                                                      .length >
                                                                  0 &&
                                                              snapshot
                                                                      .data[
                                                                          index]
                                                                      .field2
                                                                      .length >
                                                                  0,
                                                          child: Text(
                                                            " | ",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        Text(
                                                          snapshot.data[index]
                                                              .field2,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey[200],
                                                              fontSize: 15),
                                                        ),
                                                      ]),
                                                      Visibility(
                                                        visible: snapshot
                                                                .data[index]
                                                                .summary
                                                                .length >
                                                            0,
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 10,
                                                                  bottom: 10),
                                                          child: Text(
                                                            snapshot.data[index]
                                                                .summary,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey[300],
                                                                fontSize: 13),
                                                          ),
                                                        ),
                                                      ),
                                                      Wrap(
                                                        children: [
                                                          new Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(5.0),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .white)),
                                                            child: Text(
                                                                snapshot
                                                                    .data[index]
                                                                    .date,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                          ),
                                                          new Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(5.0),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .white)),
                                                            child: Text(
                                                                snapshot
                                                                    .data[index]
                                                                    .date,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                          ),
                                                          new Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(5.0),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .white)),
                                                            child: Text(
                                                                snapshot
                                                                    .data[index]
                                                                    .date,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Opacity(
                                                  opacity: 0,
                                                  child: Center(
                                                      child: Container(
                                                          child: Text(
                                                    "Save",
                                                  ))),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: snapshot.data.length,
                            reverse: false,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 60,
                        bottom: 15,
                        right: 60,
                        child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ButtonBar(
                              alignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.arrow_back),
                                  onPressed: () {
                                    scrollController.animateTo(
                                        scrollController.offset -
                                            (MediaQuery.of(context).size.width *
                                                    0.8 +
                                                30),
                                        curve: Curves.ease,
                                        duration: Duration(milliseconds: 300));
                                  },
                                ),
                                IconButton(
                                    icon: Icon(Icons.close),
                                    color: Colors.red,
                                    onPressed: () async {
                                      showOverlay((context, t) {
                                        return Opacity(
                                          opacity: t,
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                left: 110,
                                                right: 110,
                                                bottom: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.885,
                                                top: 50),
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(0)),
                                              child: Center(
                                                child: Text("Removed"),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                          duration: Duration(seconds: 1),
                                          curve: Curves.ease);
                                      if (await Vibration
                                          .hasCustomVibrationsSupport()) {
                                        Vibration.vibrate(
                                            duration: 50, amplitude: 30);
                                      } else {}
                                      setState(() {
                                        snapshot.data.removeAt(_focusedIndex);
                                        card_colours.removeAt(_focusedIndex);
                                      });
                                    }),
                                IconButton(
                                    icon: Icon(Icons.favorite_border),
                                    color: Colors.green,
                                    onPressed: () async {
                                      showOverlay((context, t) {
                                        return Opacity(
                                          opacity: t,
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                left: 110,
                                                right: 110,
                                                bottom: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.885,
                                                top: 50),
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(0)),
                                              child: Center(
                                                child: Text("Saved"),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                          duration: Duration(seconds: 1),
                                          curve: Curves.ease);
                                      /*SnackBar snackBar = SnackBar(
                                            behavior: SnackBarBehavior.floating,
                                            content: Text('Job Saved for Later'));
                                        Scaffold.of(context)
                                            .showSnackBar(snackBar);*/
                                      if (await Vibration
                                          .hasCustomVibrationsSupport()) {
                                        Vibration.vibrate(
                                            duration: 50, amplitude: 30);
                                      } else {}
                                      setState(() {
                                        snapshot.data.removeAt(_focusedIndex);
                                        card_colours.removeAt(_focusedIndex);
                                        Favourites.favourites
                                            .add(snapshot.data[_focusedIndex]);
                                      });
                                    }),
                                IconButton(
                                  icon: Icon(Icons.arrow_forward),
                                  onPressed: () {
                                    scrollController.animateTo(
                                        scrollController.offset +
                                            (MediaQuery.of(context).size.width *
                                                    0.8 +
                                                30),
                                        curve: Curves.ease,
                                        duration: Duration(milliseconds: 300));
                                  },
                                ),
                              ],
                            )),
                      )
                    ],
                  );
                } else if (snapshot.hasError) {
                  /*Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(snapshot.error.toString()),
                    ));*/
                  print("Error");
                  return Center(
                    child: IconButton(
                      iconSize: 70,
                      icon: Icon(Icons.refresh),
                      onPressed: () {
                        getJobsList();
                      },
                    ),
                  );
                }
                // By default, show a loading spinner.
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                    strokeWidth: 6,
                  ),
                );
              },
            ),
            Positioned(
              top: 30,
              width: MediaQuery.of(context).size.width,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        /*padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                            shape: BoxShape.circle
                          ),*/
                        child: IconButton(
                          iconSize: 40,
                          //color: Color(0xFFFF7F50),
                          icon: Icon(Icons.sort),
                          onPressed: () {
                            displayModalBottomSheet(context);
                          },
                        ),
                      ),
                      IconButton(
                        iconSize: 40,
                        //color: Color(0xFFFF7F50),
                        icon: Icon(Icons.favorite_border),
                        onPressed: () {
                          Navigator.of(context).push(_createRoute());
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void displayModalBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return Form(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
                      alignment: Alignment.center,
                      height: 5,
                      width: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[400]),
                    ),
                  ),
                  StatefulBuilder(
                    builder: (BuildContext context,
                        void Function(void Function()) setState) {
                      return Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 20, left: 20),
                        child: new DropdownButton<String>(
                          value: dropdownValue,
                          elevation: 16,
                          style: TextStyle(color: Colors.black),
                          underline: Container(
                            height: 2,
                            color: Colors.blue,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValue = newValue;
                            });
                          },
                          items: <String>['Choose a city', 'Liverpool']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                  StatefulBuilder(
                    builder: (context, setState) {
                      return new ListTile(
                        leading: Text("Radius"),
                        trailing: Text(sliderValue.toString()),
                        title: Slider(
                          label: "Radius",
                          min: 0,
                          max: 100,
                          divisions: 5,
                          value: sliderValue,
                          onChanged: (double value) {
                            setState(
                              () {
                                sliderValue = value;
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                  StatefulBuilder(
                    builder: (context, setState) {
                      return Center(
                        child: new Wrap(
                          children: List<Widget>.generate(
                            3,
                            (int index) {
                              return Container(
                                padding: EdgeInsets.all(5),
                                child: ChoiceChip(
                                  elevation: 2,
                                  selectedColor: Colors.deepPurple,
                                  label: Container(
                                    padding: EdgeInsets.all(5),
                                      child: Text(
                                    'Item $index',
                                    style: TextStyle(fontSize: 20, color: Colors.deepPurpleAccent),
                                  )),
                                  selected: _value == index,
                                  onSelected: (bool selected) {
                                    setState(() {
                                      _value = selected ? index : null;
                                    });
                                  },
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class Job {
  final String title;
  final String titleURL;
  final String salary;
  final String summary;
  final String date;
  final String field1;
  final String field2;

  Job(
      {this.title,
      this.titleURL,
      this.salary,
      this.summary,
      this.date,
      this.field1,
      this.field2});

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      title: json['Title'].replaceAll("\n", ""),
      titleURL: json['Title_URL'].replaceAll("\n", ""),
      salary: json['Salary'].replaceAll("\n", ""),
      summary: json['Summary'].replaceAll("\n", ""),
      date: json['Date'].replaceAll("\n", ""),
      field1: json['Field1'].replaceAll("\n", ""),
      field2: json['Field2'].replaceAll("\n", ""),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        Favourites.Favourites(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.elasticInOut;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
