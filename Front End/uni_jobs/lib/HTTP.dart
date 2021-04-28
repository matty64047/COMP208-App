import 'package:http/http.dart';
import 'dart:convert';
import 'Job.dart';

final String url = "192.168.0.42:5000";

Future<bool> verifyLogin({email, password}) async {
  String basicAuth =  'Basic ' + base64Encode(utf8.encode('$email:$password'));
  Map<String, String> headers = {'authorization': basicAuth};
  Response r = await get(Uri.http(url, "/api/users"), headers: headers);
  if (r.statusCode == 200) return true;
  else return false;
}

Future getUser({email, password}) async {
  String basicAuth =  'Basic ' + base64Encode(utf8.encode('$email:$password'));
  Map<String, String> headers = {'authorization': basicAuth};
  Response r = await get(Uri.http(url, "/api/users"), headers: headers);
  return jsonDecode(r.body);
}

Future<bool> createUser({email, password, firstName, lastName, university}) async {
  Map data = {};
  data["email"] = email;
  data["password"] = password;
  data["first_name"] = firstName;
  data["last_name"] = lastName;
  data["university"] = university;
  Response r = await post(Uri.http(url, "/api/users/create"), body: data);
  if (r.statusCode==200) return true;
  else return false;
}

Future<bool> changeUserDetails({email, password, data}) async {
  String basicAuth =  'Basic ' + base64Encode(utf8.encode('$email:$password'));
  Map<String, String> headers = {'authorization': basicAuth};
  Response r = await post(Uri.http(url, "/api/ratings"), headers: headers, body: data);
  if (r.statusCode==200) return true;
  else return false;
}

Future<List<Job>> getJobs({email, password, param}) async {
  String basicAuth =  'Basic ' + base64Encode(utf8.encode('$email:$password'));
  Map<String, String> headers = {'authorization': basicAuth};
  Response r = await get(Uri.http(url, "/api/jobs", param), headers: headers);
  if (r.statusCode==200) {
    List<Job> jobList = [];
    dynamic json = jsonDecode(r.body);
    for (dynamic job_json in json) {
      Job job = Job.fromMap(job_json);
      jobList.add(job);
    }
    return jobList;
  }
  else throw Exception(r.body);
}

rateJob({email, password, jobID, rating}) async {
  String basicAuth =  'Basic ' + base64Encode(utf8.encode('$email:$password'));
  Map data = {
    "job_id": jobID.toString(),
    "rating": rating.toString(),
  };
  Map<String, String> headers = {'authorization': basicAuth};
  Response r = await post(Uri.http(url, "/api/ratings"), headers: headers, body: data);
  return r;
}

deleteRating({email, password, jobID}) async {
  String basicAuth =  'Basic ' + base64Encode(utf8.encode('$email:$password'));
  Map data = {
    "job_id": jobID.toString(),
  };
  Map<String, String> headers = {'authorization': basicAuth};
  Response r = await delete(Uri.http(url, "/api/ratings"), headers: headers, body: data);
  return r;
}

getRatings({email, password}) async {
  String basicAuth =  'Basic ' + base64Encode(utf8.encode('$email:$password'));
  Map<String, String> headers = {'authorization': basicAuth};
  Response r = await get(Uri.http(url, "/api/ratings"), headers: headers);
  if (r.statusCode==200) {
    List<Job> jobList = [];
    dynamic json = jsonDecode(r.body);
    for (dynamic job_json in json) {
      Job job = Job.fromMap(job_json);
      jobList.add(job);
    }
    return jobList;
  }
  else throw Exception(r.body);
}

deleteUser({email, password}) async {
  String basicAuth =  'Basic ' + base64Encode(utf8.encode('$email:$password'));
  Map<String, String> headers = {'authorization': basicAuth};
  Response r = await delete(Uri.http(url, "/api/users"), headers: headers);
  return r;
}