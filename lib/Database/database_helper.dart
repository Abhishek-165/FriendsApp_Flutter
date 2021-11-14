import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _dbname = "friends.db";
  static final _dbversion = 1;
  static final _tableUser = "user";

  static final _tableFriends = "user_friend";
  static final columnId = '_id';
  static final columnFName = "_fname";
  static final columnLName = "_lname";
  static final columnEmail = "_email";
  static final columnPhone = "_phone";
  static final columnPassword = "_password";

  static final refNo = "_referenceNo";

// making it a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database == null) _database = await _initateDatabase();
    return _database;
  }

  _initateDatabase() async {
    String path = join('/data/user/0/com.example.friends/app_flutter', _dbname);
    return await openDatabase(path, version: _dbversion, onCreate: _onCreate);
  }

  // create a table in the database

  Future _onCreate(Database db, int version) async {
    await db.execute('''
            CREATE TABLE $_tableUser(
              $columnId INTEGER PRIMARY KEY,
              $columnFName TEXT Not NULL,
              $columnLName TEXT Not NULL,
              $columnEmail TEXT Not NULL,
              $columnPhone TEXT Not NULL,
              $columnPassword TEXT Not NULL
              )
              ''');

    await db.execute('''
            CREATE TABLE $_tableFriends(
              $columnId INTEGER PRIMARY KEY,
              $columnFName TEXT Not NULL,
              $columnLName TEXT Not NULL,
              $columnEmail TEXT Not NULL,
              $columnPhone TEXT Not NULL,
              $refNo TEXT Not NULL
              )
              ''');
  }

  // insert a row in the table

  // ignore: unused_element
  Future insertUser(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableUser, row);
  }

  Future insertFriend(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableFriends, row);
  }

  // returns all the data in the form of list

  Future getuser(phone, password) async {
    Database db = await instance.database;
    return await db.rawQuery(
        'SELECT * FROM user WHERE _phone =? AND _password = ?',
        [phone, password]);
  }

  Future getFriends(String phone) async {
    Database db = await instance.database;
    //return await database.rawUpdate('UPDATE taskdetails SET columnstatus = ${value} WHERE id = ${id}');
    return await db
        .rawQuery('SELECT * FROM user_friend WHERE _referenceNo =?', [phone]);
  }

  Future updateFriend(
      String fname, String lname, String email, String phone) async {
    Database db = await instance.database;
    return await db.rawUpdate(
        'UPDATE user_friend SET _fname =?,_lname=?,_email=? WHERE _phone = ?',
        [fname, lname, email, phone]);
  }

  Future<List<Map<String, dynamic>>> queryAllUser() async {
    Database db = await instance.database;
    return await db.query(_tableUser);
  }

  Future<List<Map<String, dynamic>>> queryAllFriend() async {
    Database db = await instance.database;
    return await db.query(_tableUser);
  }

  Future deleteQuery(String phone) async {
    Database db = await instance.database;
    return await db
        .rawDelete('DELETE FROM user_friend WHERE _phone=?', [phone]);
  }
}
