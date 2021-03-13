import 'package:flutter/material.dart';
import 'package:fancy_on_boarding/fancy_on_boarding.dart';
import '../main.dart';
import '../data/GetInfo.dart';
import '../data/User.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final _signUpKey = GlobalKey<FormState>();
  final _loginKey = GlobalKey<FormState>();
  String email, password, university, firstName, lastName;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: TabBarView(
          children: [
            Container(
              padding: EdgeInsets.all(30),
              child: Form(
                key: _signUpKey,
                child: ListView(
                  children: [
                    Container(
                      child: Text("Sign Up"),
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Email"),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        email = value;
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Password"),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        password = value;
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "First Name"),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        firstName = value;
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Last Name"),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        lastName = value;
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "University"),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        university = value;
                        return null;
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, otherwise false.
                        if (_signUpKey.currentState.validate()) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _signUpDialog(context));
                        }
                      },
                      child: Text('Submit'),
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(30),
              child: Form(
                key: _loginKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Login"),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Email"),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        email = value;
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Password"),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        password = value;
                        return null;
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, otherwise false.
                        if (_loginKey.currentState.validate()) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _loginDialog(context));
                        }
                      },
                      child: Text('Submit'),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _signUpDialog(BuildContext context) {
    return new AlertDialog(
      content: FutureBuilder(
        future: newUser(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName,
            university: university),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data);
          }
          if (snapshot.hasError) {
            AuthenticationException error = snapshot.error;
            return Text(error.cause);
          } else
            return Container(
                padding: EdgeInsets.all(20),
                child: Center(child: new CircularProgressIndicator()));
        },
      ),
    );
  }

  Widget _loginDialog(BuildContext context) {
    return new AlertDialog(
      content: FutureBuilder(
        future: getUser(email, password),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            checkUser();
            Navigator.of(context).pop();
          }
          if (snapshot.hasError) {
            AuthenticationException error = snapshot.error;
            return Text(error.cause);
          } else
            return Container(
                padding: EdgeInsets.all(20),
                child: Center(child: new CircularProgressIndicator()));
        },
      ),
    );
  }
}
