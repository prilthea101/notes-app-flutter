import 'package:flutter/material.dart';
import '../models/note.dart';

class EditNotePage extends StatelessWidget {
  final Note? note;

  const EditNotePage({super.key, this.note});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: note?.title ?? '');
    final contentController = TextEditingController(text: note?.content ?? '');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          note == null ? 'New Note' : 'Edit Note',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final newNote =
              note?.copyWith(
                title: titleController.text,
                content: contentController.text,
                updatedAt: DateTime.now(),
              ) ??
              Note(
                title: titleController.text,
                content: contentController.text,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );

          Navigator.pop(context, newNote);
        },
        child: const Icon(Icons.save),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  hintText: 'Content',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
