import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List> getJobs() async {
  http.Response response = await http.get('http://192.168.43.75:5000/jobs');
  if (response.statusCode == 200) {
    List jobs = jsonDecode(response.body);
    return jobs;
  } else
    print("Error");
    throw Exception("Couldn't connect to server");
}
