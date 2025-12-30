import '../models/note.dart';

abstract class NotesRepository {
  Future<List<Note>> getAllNotes();

  Future<int> insertNote(Note note);

  Future<int> updateNote(Note note);

  Future<int> deleteNote(int id);
}
