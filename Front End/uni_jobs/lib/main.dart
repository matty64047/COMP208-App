// @dart=2.9

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_jobs/User.dart';
import 'package:uni_jobs/views/home.dart';
import 'Login/login_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (BuildContext context) => User(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(255, 136, 148, 1),
        backgroundColor: Colors.grey[50]
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, child) {
        if (user.isLoggedIn) {
          return Home();
        }
        else return LoginScreen();
      },
    );
  }
}
