// lib/database/database_helper.dart
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Define the Question model
class Question {
  final int? id;
  final String title;
  final String description;

  Question({this.id, required this.title, required this.description});

  // Convert a Question object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }

  // Convert a Map object into a Question object
  static Question fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'],
      title: map['title'],
      description: map['description'],
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'questions.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE questions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT
      )
      ''',
    );
  }

  Future<int> insertQuestion(Question question) async {
    Database db = await database;
    return await db.insert('questions', question.toMap());
  }

  Future<List<Question>> getQuestions() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('questions');
    return List.generate(maps.length, (i) {
      return Question.fromMap(maps[i]);
    });
  }

  Future<int> updateQuestion(Question question) async {
    Database db = await database;
    return await db.update(
      'questions',
      question.toMap(),
      where: 'id = ?',
      whereArgs: [question.id],
    );
  }

  Future<int> deleteQuestion(int id) async {
    Database db = await database;
    return await db.delete(
      'questions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
