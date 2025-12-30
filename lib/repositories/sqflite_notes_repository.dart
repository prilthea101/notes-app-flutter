import 'package:sqflite/sqflite.dart';
import '../data/database_helper.dart';
import '../models/note.dart';
import 'notes_repository.dart';

class SqfliteNotesRepository implements NotesRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  static const String _tableName = 'notes';

  @override
  Future<List<Note>> getAllNotes() async {
    final Database db = await _dbHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: 'updated_at DESC',
    );

    return maps.map((map) => Note.fromMap(map)).toList();
  }

  @override
  Future<int> insertNote(Note note) async {
    final Database db = await _dbHelper.database;

    return await db.insert(
      _tableName,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<int> updateNote(Note note) async {
    final Database db = await _dbHelper.database;

    return await db.update(
      _tableName,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  @override
  Future<int> deleteNote(int id) async {
    final Database db = await _dbHelper.database;

    return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}
