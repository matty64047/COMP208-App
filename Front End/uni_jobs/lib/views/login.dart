import 'package:flutter/material.dart';
import '../User.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Consumer<User>(builder: (context, user, child) {
      return Scaffold(
        body: Center(
          child: IconButton(
            icon: Icon(Icons.login),
            onPressed: () {
              user.logIn("m.p.connoll@gmail.com", "matthew123");
            },
          ),
        ),
      );
    });
  }
}
