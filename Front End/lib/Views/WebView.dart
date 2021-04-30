import 'package:test_flutter/data/Job.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CardHero extends StatefulWidget {
  final Job job;

  const CardHero({Key key, this.job})
      : super(key: key);

  @override
  _CardHeroState createState() => _CardHeroState();
}

class _CardHeroState extends State<CardHero> {
  Job job;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    job = widget.job;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: "card",
        child: Scaffold(
          appBar: AppBar(
            actions: [
              MaterialButton(
                onPressed: () {
                  launchURL(job.summary);
                },
                child: Text("Open in Browser"),
              ),
              /*IconButton(onPressed: () {}, icon: Icon(Icons.favorite_border)),
              IconButton(onPressed: () {}, icon: Icon(Icons.delete)),*/
            ],
          ),
/*floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              _launchURL(job.titleURL);
            },
            heroTag: null,
            label: Text('Apply'),
            icon: Icon(Icons.send),
            backgroundColor: Colors.pink,
          ),*/
          body: Stack(children: <Widget>[
            WebView(
              //key: UniqueKey(),
              initialUrl: job.summary,
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (finish) {
                setState(() {
                  isLoading = false;
                });
              },
            ),
            isLoading
                ? Center(
              child: CircularProgressIndicator(),
            )
                : Stack(),
          ]),
        ));
  }
}

launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
