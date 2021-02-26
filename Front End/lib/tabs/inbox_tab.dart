import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../views/conversation_view.dart';
import '../data/jobs.dart' as jobs;

class Inbox extends StatefulWidget {
  @override
  _InboxState createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  List<String> items = List.filled(1, "Starbucks");
  RefreshController controller = RefreshController(initialRefresh: false);

  void _onRefresh() async{
    // monitor network fetch
    jobs.getJobs();
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    controller.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    items.add((items.length+1).toString());
    if(mounted)
      setState(() {

      });
    controller.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: ClassicHeader(),
      footer: ClassicFooter(
        loadStyle: LoadStyle.ShowWhenLoading,
        completeDuration: Duration(milliseconds: 500),
      ),
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      controller: controller,
      child: ListView.builder(
        //itemExtent: items.length,
        IndexedWidgetBuilder: (context, index) {
          return Dismissible(
            Key: Key("hello"),
            onDismissed: (direction) {
              // Remove the item from the data source.
              setState(() {
                items.removeAt(index);
              });

              // Show a snackbar. This snackbar could also contain "Undo" actions.
              Scaffold
                  .of(context)
                  .showSnackBar(SnackBar(content: Text("dismissed")));
            },
            child: ListTile(
              title: Text("Feature Coming Soon"),
              subtitle: Text("This feature is still a work in progress and is not yet ready for general use"),
              leading: Icon(Icons.account_circle, size: 50,),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Conversation()),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
