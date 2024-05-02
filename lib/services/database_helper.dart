import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/model/task.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  Future<Database> initDb() async {
    String path = join(await getDatabasesPath(), 'tasks.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, isCompleted INTEGER)');
  }

  Future<int> insertTask(Task task) async {
    Database? db = await this.db;
    return await db!.insert('tasks', task.toMap());
  }

  Future<List<Task>> getTasks() async {
    Database? db = await this.db;
    List<Map<String, dynamic>> maps = await db!.query('tasks');
    return List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['id'],
        title: maps[i]['title'],
        isCompleted: maps[i]['isCompleted'] == 1 ? true : false,
      );
    });
  }

  Future<int> updateTask(Task task) async {
    Database? db = await this.db;
    return await db!.update('tasks', task.toMap(),
        where: 'id = ?', whereArgs: [task.id]);
  }

  Future<int> deleteTask(int id) async {
    Database? db = await this.db;
    return await db!.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}