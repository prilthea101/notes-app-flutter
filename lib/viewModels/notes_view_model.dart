import '../models/note.dart';
import '../repositories/notes_repository.dart';

class NotesViewModel {
  final NotesRepository _repository;

  NotesViewModel(this._repository);

  Future<List<Note>> fetchNotes() async {
    return await _repository.getAllNotes();
  }

  Future<void> addNote({required String title, required String content}) async {
    final now = DateTime.now();

    final note = Note(
      title: title,
      content: content,
      createdAt: now,
      updatedAt: now,
    );

    await _repository.insertNote(note);
  }

  Future<void> updateNote(Note note) async {
    final updatedNote = note.copyWith(updatedAt: DateTime.now());

    await _repository.updateNote(updatedNote);
  }

  Future<void> deleteNote(int id) async {
    await _repository.deleteNote(id);
  }
}
