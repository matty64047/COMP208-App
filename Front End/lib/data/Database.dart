import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database _database;

  Future<Database> get database async {
    if(_database != null)
      return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    return await openDatabase(
        join(await getDatabasesPath(), 'bridge.db'),
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE users (
              email TEXT PRIMARY KEY, password TEXT, type TEXT, university TEXT, first_name TEXT, last_name TEXT, id INT
            )
          ''');
        },
        version: 1
    );
  }

  newUser(user) async {
    final db = await database;
    try {
      var res = await db.rawInsert('''
        INSERT INTO users (
          email, password, type, university, first_name, last_name, id
        ) VALUES (?, ?, ?, ?, ?, ?, ?)
      ''', [
        user.email,
        user.password,
        user.type,
        user.university,
        user.firstName,
        user.lastName,
        user.id
      ]);
      return res;
    }
    on DatabaseException {
      deleteUser();
      var res = await newUser(user);
      return res;
    }
  }

  Future<dynamic> getUser() async {
    final db = await database;
    var res = await db.query("users");
    if(res.length == 0) {
      print("No Users");
      return false;
    } else {
      var resMap = res[0];
      return resMap.isNotEmpty ? resMap: Null;
    }
  }


  deleteUser() async {
    final db = await database;
    //var res = await db.rawInsert('''DELETE FROM users''');
    var res = await db.delete("users");
    return res;
  }

}
