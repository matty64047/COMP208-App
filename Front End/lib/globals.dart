import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

CardController controller;
List jobs = [];
var account;

Future<List> getJobs() async {
  http.Response response = await http.get('http://192.168.43.75:5000/jobs');
  if (response.statusCode == 200) {
    List jobs = jsonDecode(response.body);
    return jobs;
  } else
    print("Error");
  throw Exception("Couldn't connect to server");
}

Future<dynamic> getAccount() async {
  http.Response response = await http.get('http://192.168.43.75:5000/user?id=user_1');
  if (response.statusCode == 200) {
    dynamic account = jsonDecode(response.body);
    return account;
  } else
    print("Error");
  throw Exception("Couldn't connect to server");
}

void appStart() async {
  jobs = await getJobs();
  account = await getAccount();
}
