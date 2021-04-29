// @dart=2.9

import 'dart:async';
import 'package:flutter/material.dart';
import '../Job.dart';
import '../HTTP.dart';
import '../User.dart';
import 'package:provider/provider.dart';
import '../widgets.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

User user = User();

class Saved extends StatefulWidget {
  @override
  _SavedState createState() => _SavedState();
}

class _SavedState extends State<Saved> {
  final streamController = StreamController<List<Job>>();
  List<Job> favourites = [];
  final key = GlobalKey<AnimatedListState>();

  @override
  void dispose() {
    super.dispose();
    streamController.close();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      user = Provider.of<User>(context, listen: false);
      getFavouritesList();
    });
  }

  Future getFavouritesList() async {
    favourites = await getRatings(email: user.email, password: user.password);
    if (!streamController.isClosed) streamController.sink.add(favourites);
  }

  void onCleared() {
    streamController.sink.add(favourites);
  }

  void onClosed() {
    streamController.sink.add(favourites);
  }

  void onChanged(String value) {
    List<Job> newList = [];
    for (int i = 0; i < favourites.length; i++) {
      if (favourites[i].title.toLowerCase().contains(value.toLowerCase()) ||
          favourites[i].salary.toLowerCase().contains(value.toLowerCase())) {
        newList.add(favourites[i]);
      } else {
        newList.remove(favourites[i]);
      }
    }
    streamController.sink.add(newList);
  }

  TextEditingController textEditingController = new TextEditingController();
  SearchBar searchBar;

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text('Saved'),
        actions: [searchBar.getSearchAction(context)]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              if (textEditingController.text == "") {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              } else if (textEditingController.text != null) {
                textEditingController.clear();
                onCleared();
              }
            },
          )
        ],
        title: TextFormField(
          textAlignVertical: TextAlignVertical.top,
          decoration: InputDecoration(
            labelText: "Search...",
            icon: Icon(Icons.search),
          ),
          controller: textEditingController,
          onChanged: onChanged,
        ),
      ),
      body: StreamBuilder(
        stream: streamController.stream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0)
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/no_results.png"),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          "No results, try saving a few more jobs from the home page",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              );

            return ListView.builder(
              physics: BouncingScrollPhysics(),
              key: key,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Job job = snapshot.data[index];
                return Dismissible(
                  onDismissed: (direction) {
                    deleteRating(
                        email: user.email,
                        password: user.password,
                        jobID: job.id);
                  },
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Confirm"),
                          content: const Text(
                              "Are you sure you wish to delete this item?"),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text("DELETE")),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("CANCEL"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  key: UniqueKey(),
                  child: savedJobCard(context, job),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        },
      ),
    );
  }
}
