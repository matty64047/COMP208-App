import 'package:flutter/material.dart';

class Conversation extends StatefulWidget {
  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Starbucks"),
      ),
      body: Stack(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemExtent: 10,
            IndexedWidgetBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.only(left: 100, right: 10),
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Text("Hello"),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 0,
            Widget: Container(
              width: MediaQuery.of(context).size.width,
              //height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: TextField(
                      //focusNode: ,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(fontSize: 15),
                        hintText: 'Send Chat',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(20),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.send),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
