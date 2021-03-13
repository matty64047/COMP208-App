import 'dart:convert';

User userFromJson(jsonData) {
  //final jsonData = json.decode(str);
  return User.fromMap(jsonData);
}

User userFromQuery(queryRow) {
  return User.fromQuery(queryRow);
}

String userToJson(User data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class User {
  int id;
  String firstName, lastName, password, email, university, type;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.university,
    this.type
  });

  factory User.fromMap(Map<String, dynamic> json) => new User(
    id: json["_id"],
    firstName: json["FirstName"],
    lastName: json["LastName"],
    email: json["Email"],
    password: json["Password"],
    type: json["Type"],
    university: json["Address"],
  );

  factory User.fromQuery(Map<String, dynamic> query) => new User(
    id: query["id"],
    firstName: query["first_name"],
    lastName: query["last_name"],
    email: query["email"],
    password: query["password"],
    type: query["type"],
    university: query["university"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "email" : email,
    "password" : password,
    "type" : type,
    "university" : university
  };
}