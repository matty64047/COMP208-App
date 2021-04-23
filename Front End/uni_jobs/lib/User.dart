import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'HTTP.dart';

class User extends ChangeNotifier {
  bool isLoggedIn = false;
  String email, password, firstName, lastName, university;

  User() {
    getUserDetails();
  }

  getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      isLoggedIn = prefs.getBool("isLoggedIn");
    }
    catch (e) {
      await prefs.setBool("isLoggedIn", false);
    }
    if (isLoggedIn) {
      email = prefs.get("email");
      password = prefs.get("password");
      dynamic json = await getUser(email: email, password: password);
      this.firstName = json["first_name"];
      this.lastName = json["last_name"];
      this.university = json["university"];
    }
    notifyListeners();
  }

  logIn(email, password) async {
    bool correctDetails =  await verifyLogin(email:email, password:password);
    if (correctDetails) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("email", email);
      await prefs.setString("password", password);
      await prefs.setBool("isLoggedIn", true);
      this.email = email;
      this.password = password;
      isLoggedIn = true;
      notifyListeners();
    }
    else return false;
  }

  logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await prefs.setBool('isLoggedIn', false);
    isLoggedIn = false;
    email = null;
    password = null;
    notifyListeners();
  }

}
