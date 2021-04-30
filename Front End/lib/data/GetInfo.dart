import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Database.dart';
import 'Job.dart';
import 'User.dart';
import 'package:path/path.dart';

class AuthenticationException implements Exception {
  String cause;
  AuthenticationException(this.cause);
}

Future<dynamic> sendPost(data, {authenticate = true, url}) async {
  //String body = json.encode(data);
  if (authenticate) {
    dynamic user = userFromQuery(await DBProvider.db.getUser());
    data["user_id"] = user.id.toString();
    data["password"] = user.password;
  }
  http.Response response = await http.post(
    join('https://comp208.matt-connolly.link/', url),
    //headers: {"Content-Type": "application/json"},
    body: data,
  );
  if (!jsonDecode(response.body)["error"])
    return jsonDecode(response.body)["response"];
  else
    throw AuthenticationException(jsonDecode(response.body)["response"]);
}

Future<dynamic> favourite(jobID) async {
  try {
    dynamic response = await sendPost(
        {"job_id": jobID.toString()}, url: "favourite");
    return response;
  }
  on AuthenticationException catch (e) {
    print(e.cause);
  }
}

Future<dynamic> like(jobID) async {
  try {
    dynamic response = await sendPost(
        {"job_id": jobID.toString()}, url: "like");
    return response;
  }
  on AuthenticationException catch (e) {
    print(e.cause);
  }
  catch (e) {

  }
}

Future<dynamic> dislike(jobID) async {
  try {
    dynamic response = await sendPost(
        {"job_id": jobID.toString()}, url: "dislike");
    return response;
  }
  on AuthenticationException catch (e) {
    print(e.cause);
  }
  catch (e) {

  }
}

Future<dynamic> getFavourites() async {
  dynamic response = await sendPost({}, url: "get_favourites");
  List<Job> jobs = new List<Job>();
  for (dynamic job_json in response) {
    Job job = jobFromJson(job_json);
    jobs.add(job);
  }
  return jobs;
}

Future<dynamic> unFavourite(jobID) async {
  try {
    dynamic response = await sendPost(
        {"job_id": jobID.toString()}, url: "unfavourite");
    return response;
  }
  on AuthenticationException catch (e) {
    print(e.cause);
  }
}

Future<dynamic> getJobs() async {
  dynamic response = await sendPost({}, url: "get_jobs");
  List<Job> jobs = new List<Job>();
  for (dynamic job_json in response) {
    Job job = jobFromJson(job_json);
    jobs.add(job);
  }
  print(jobs.length);
  return jobs;
}

Future<dynamic> getUser(email, password) async {
  dynamic body = {"email": email, "password": password};
  dynamic response = await sendPost(body, url: "get_user", authenticate: false);
  User user = userFromJson(response);
  DBProvider.db.newUser(user);
  return response;
}

Future<dynamic> newUser({email, password, university, firstName, lastName}) async {
  dynamic user = {
    "email": email,
    "password": password,
    "university": university,
    "first_name": firstName,
    "last_name": lastName
  };
  dynamic response = await sendPost(
      user, url: "new_user", authenticate: false);
  print(response);
  return response;
}
