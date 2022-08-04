import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  // Initillizing Variables
  static final _dbName = 'myDatabase.db';
  static final _dbVersion = 1;
  static final _tabelName = 'myTable';
  static final _columnName = 'column';
  static final _columnId = '_id';


  // Making this class singleton
  DatabaseHelper._privateConstructore();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructore();

  // Initialize Database
  Database? _database;
  Future<Database> getDatabase()async{
    if(_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase()async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path  = join(directory.path , _dbName);

    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  _onCreate(Database db, int version){
    db.query(
      '''
      CREATE TABLE $_tabelName(
      $_columnId INTEGER PRIMARY KEY,
      $_columnName TEXT NOT NULL
      )
      '''
    );
  }



  // CRUD Operation
  Future<int> insert(Map<String, dynamic> row)async{
    Database db= await instance.getDatabase();
    return await db.insert(_tabelName, row);
  }

  Future<List<Map<String , dynamic>>> queryAll()async{
    Database db = await instance.getDatabase();
    return db.query(_tabelName);
  }

  Future<int> update(Map<String, dynamic> row)async{
    Database db = await instance.getDatabase();
    return db.update(
        _tabelName,
        row ,
        where:' $_columnId = ? ' ,
        whereArgs: [1]
    );
  }
}