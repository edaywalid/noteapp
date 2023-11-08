import 'dart:io';

import 'package:note_application/model/NoteModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class NoteDB {
  static const dbName = 'mynotes.db';
  static const dbVersion = 1;
  static const tableName = 'notes';

  NoteDB._internal();
  static final NoteDB instance = NoteDB._internal();


  Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase()async{
    String dbpath = await getDatabasesPath();
    String path = join(dbpath, dbName);

    return await openDatabase(path, version: dbVersion, onCreate: _onCreate);
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT NOT NULL ,
        date TEXT NOT NULL
      )
    ''');

  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(tableName, row);
  }


  Future<NoteModel> readNote(int id )async{
    Database? db = await instance.database ;
    return db!.query(tableName, where: 'id = ?', whereArgs: [id]).then((maps) {
      if (maps.isNotEmpty) {
        return NoteModel.fromMap(maps.first);
      } else {
        throw Exception('ID $id not found');
      }
    });
  }

  Future<List<NoteModel>> queryAll() async {
    Database? db = await instance.database;
    List<Map<String, dynamic>> maps = await db!.query(tableName);
    return List.generate(maps.length, (index) => NoteModel.fromMap(maps[index]));
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row['id'];
    return await db!.update(tableName, row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database? db = await instance.database;
    return await db!.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAll() async {
    Database? db = await instance.database;
    return await db!.delete(tableName);
  }

  Future close() async {
    Database? db = await instance.database;
    db!.close();
  }



  Future<void> deleteNotesDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final dbPath = directory.path + '/notes.db';
    final dbFile = File(dbPath);

    if (await dbFile.exists()) {
      await dbFile.delete();
      print("Database 'notes.db' deleted successfully.");
    } else {
      print("Database 'notes.db' does not exist.");
    }
  }

  Future<void> dropTable() async {
    Database? db = await instance.database;
    await db?.execute('DROP TABLE IF EXISTS $tableName');
  }


}
