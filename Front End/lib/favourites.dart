import 'package:flutter/cupertino%20(1).dart';
import 'package:flutter/material%20(1).dart';
import 'card_hero.dart';
import 'main.dart';
import 'package:multi_select_item/multi_select_item.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

List favourites = [];

class Favourites extends StatefulWidget {
  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  List<bool> starred = [];
  List<bool> expanded = [];
  SearchBar searchBar;
  List _favourites;

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(title: new Text('Saved'), centerTitle: true, actions: [
      IconButton(
        icon: Icon(Icons.filter_alt_outlined),
        onPressed: () {},
      ),
      searchBar.getSearchAction(context),
    ]);
  }

  _FavouritesState() {
    searchBar = new SearchBar(
        inBar: false,
        setState: setState,
        onChanged: onChanged,
        onCleared: onCleared,
        onClosed: onClosed,
        onSubmitted: print,
        closeOnSubmit: false,
        clearOnSubmit: false,
        buildDefaultAppBar: buildAppBar);
  }

  void onCleared() {
    _favourites = favourites;
  }

  void onClosed() {
    _favourites = favourites;
  }

  void onChanged(String value) {
    List newList = [];
    for (int i = 0; i < favourites.length; i++) {
      if (favourites[i].title.toLowerCase().contains(value.toLowerCase())) {
        newList.add(favourites[i]);
      } else {
        newList.remove(favourites[i]);
      }
    }
    setState(() {
      _favourites = newList;
    });
  }

  @override
  void initState() {
    super.initState();
    _favourites = favourites;
    expanded = new List<bool>.filled(favourites.length, false);
    starred = new List<bool>.filled(favourites.length, false);
  }

  Icon getIconStarred(index) {
    return starred[index] == true
        ? Icon(Icons.star_rounded)
        : Icon(Icons.star_border_rounded);
  }

  Icon getIconExpanded(index) {
    return expanded[index] == true
        ? Icon(Icons.expand_less)
        : Icon(Icons.expand_more);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar.build(context),
      body: _favourites.length > 0
          ? ListView.separated(
              itemCount: _favourites.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  margin: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                  child: ExpansionTile(
                    onExpansionChanged: (bool) {
                      setState(() {
                        expanded[index] = bool;
                      });
                    },
                    children: [
                      ConstrainedBox(
                        constraints: new BoxConstraints(maxHeight: 300),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            _favourites[index].summary,
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ButtonBar(
                            children: [
                              MaterialButton(
                                onPressed: () async {
                                    await _showMyDialog(index);
                                    setState(() {

                                    });
                                },
                                child: Text("Remove", style: TextStyle(color: Colors.red),),
                              ),
                              MaterialButton(
                                child: Text("View Full Details"),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return new CardHero(
                                          job: _favourites[index],
                                        );
                                      },
                                      fullscreenDialog: true,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          MaterialButton(
                            color: Colors.purple,
                            child: Text("Apply"),
                            onPressed: () {
                              launchURL(_favourites[index].titleURL);
                            },
                          ),
                        ],
                      ),
                    ],
                    leading: IconButton(
                      icon: getIconStarred(index),
                      onPressed: () {
                        setState(() {
                          starred[index] = !starred[index];
                        });
                      },
                    ),
                    tilePadding: EdgeInsets.all(10),
                    title: Text(
                      _favourites[index].title,
                      style: TextStyle(fontSize: 21),
                    ),
                    subtitle: Text(_favourites[index].field1 +
                        " " +
                        _favourites[index].field2),
                    trailing: getIconExpanded(index),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Container(
                  height: 5,
                );
              },
            )
          : Center(
              child: Text("No Saved Jobs"),
            ),
    );
  }

  Future<void> _showMyDialog(index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Unsave Job'),
                Text('Are you sure you want to remove this job from your saved jobs?'),
              ],
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              child: Text('Yes'),
              onPressed: () {
                favourites.removeAt(index);
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
