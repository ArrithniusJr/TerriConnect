import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:projectmp/model/note_model.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = "Notes.db";

  //Method to return the database
  static Future<Database> _getDB() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
        onCreate: (db, version) async => await db.execute(
            "CREATE TABLE Note(id INTEGER PRIMARY KEY, title TEXT NOT NULL, description TEXT NOT NULL);"),
        version: _version);
  }

  static Future<int> addNote(Note note) async {
    final db = await _getDB();
    return await db.insert(
      "Note",
      note.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //update method
  static Future<int> updateNote(Note note) async {
    final db = await _getDB();
    return await db.update("Note", note.toJson(),
        where: 'id = ?',
        whereArgs: [note.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //delete method
  static Future<int> deleteNote(Note note) async {
    final db = await _getDB();
    return await db.delete(
      "Note",
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  //return the notes
  static Future<List<Note>?> receiveNotes() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("Note");

    if (maps.isEmpty) {
      return null;
    }
    return List.generate(maps.length, (index) => Note.fromJson(maps[index]));
  }
}
