import 'package:flutter/material.dart';
import '../models/note.dart';
import '../repositories/sqflite_notes_repository.dart';
import '../viewmodels/notes_view_model.dart';
import 'edit_note_page.dart';
import 'package:intl/intl.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late final NotesViewModel viewModel;
  List<Note> notes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    viewModel = NotesViewModel(SqfliteNotesRepository());
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final fetchedNotes = await viewModel.fetchNotes();
    setState(() {
      notes = fetchedNotes;
      isLoading = false;
    });
  }

  Future<void> _openEditor({Note? note}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditNotePage(note: note)),
    );

    if (result != null) {
      if (note == null) {
        await viewModel.addNote(title: result.title, content: result.content);
      } else {
        await viewModel.updateNote(result);
      }
      _loadNotes();
    }
  }

  Future<void> _deleteNote(Note note) async {
    if (note.id == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Delete Note'),
            content: const Text('Are you sure you want to delete this note?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirm == true) {
      await viewModel.deleteNote(note.id!);
      _loadNotes();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Note deleted')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 229, 229, 229),
      appBar: AppBar(
        title: const Text(
          'My Notes',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(color: Colors.grey, height: 2.0),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditor(),
        child: const Icon(Icons.add),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : notes.isEmpty
              ? const Center(child: Text('No notes yet'))
              : Padding(
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (_, i) {
                    final note = notes[i];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          note.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 6),
                            Text(
                              note.content,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Updated: ${DateFormat.yMMMd().add_jm().format(note.updatedAt)}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        onTap: () => _openEditor(note: note),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteNote(note),
                        ),
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
