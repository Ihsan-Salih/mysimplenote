import 'package:flutter/material.dart';
import '../models/note.dart';
import '../models/database/db_helper.dart';

class NoteController {
  final BuildContext _context; 
  final Function(List<Note>) updateNotesList; 

  // Constructor to initialize context and the callback for updating the notes list
  NoteController(this._context, this.updateNotesList);

  // Function to show a dialog for adding or updating a note
  Future<void> addOrUpdateNoteDialog(Note? note) async {
    // Controllers for managing input fields (title and content) with existing values if editing
    final titleController = TextEditingController(text: note?.title ?? '');
    final contentController = TextEditingController(text: note?.content ?? '');
    bool isHighPriority = note?.priority == 1; // Check if the note is high priority

    // Display the dialog for adding or editing a note
    await showDialog(
      context: _context,
      builder: (context) {
        return StatefulBuilder( // Allows dialog state changes (e.g priority toggle)
          builder: (context, setState) {
            return AlertDialog(
              title: Text(note == null ? 'Add Note' : 'Edit Note'), // Set title based on operation
              content: SingleChildScrollView( // Make the content scrollable if needed
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Ensure the column takes minimal space
                  children: <Widget>[
                    // TextField for note title
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10), // Add space between fields
                    // TextField for note content
                    TextField(
                      controller: contentController,
                      decoration: const InputDecoration(
                        labelText: 'Content',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3, // Allow content to span multiple lines
                    ),
                    const SizedBox(height: 10),
                    // Row with a switch for high priority
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("High Priority"), // Label for priority switch
                        Switch(
                          value: isHighPriority, // Toggle value for priority
                          onChanged: (value) {
                            setState(() {
                              isHighPriority = value; // Update the priority when switched
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                // Cancel button to close
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                ),
                // Add/Update button to save the note changes
                ElevatedButton(
                  child: Text(note == null ? 'Add' : 'Update'), // Button text depends on operation
                  onPressed: () async {
                    final title = titleController.text; // Get title text
                    final content = contentController.text; // Get content text
                    if (title.isNotEmpty && content.isNotEmpty) { // Ensure fields are not empty
                      final newNote = Note(
                        id: note?.id, // Use existing ID for update or null for new note
                        title: title, // Set the title for the note
                        content: content, // Set the content for the note
                        priority: isHighPriority ? 1 : 0, // Set priority based on switch
                      );
                      if (note == null) {
                        // Create a new note in the database if no note is provided
                        await DBHelper.instance.create(newNote);
                      } else {
                        // Update the existing note if editing
                        await DBHelper.instance.update(newNote);
                      }
                      await refreshNotes(); // Refresh the notes list after operation
                      Navigator.pop(context); // Close the dialog
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Function to refresh and fetch the list of notes from the database
  Future<void> refreshNotes() async {
    final notes = await DBHelper.instance.readAllNotes(); // Fetch all notes from DB
    notes.sort((a, b) => b.priority.compareTo(a.priority)); // Sort notes by priority (descending)
    updateNotesList(notes); // Call the callback to update the notes list
  }

  // Function to show a dialog for confirming note deletion
  Future<void> deleteNoteDialog(Note note) async {
    await showDialog(
      context: _context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Note'), // Title for the delete confirmation
          content: const Text('Are you sure you want to delete this note?'), // Confirmation message
          actions: <Widget>[
            // Cancel button to close the dialog without deleting
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
            ),
            // Delete button to actually remove the note
            ElevatedButton(
              child: const Text('Delete'),
              onPressed: () async {
                await DBHelper.instance.delete(note.id!); // Delete the note from DB
                await refreshNotes(); // Refresh the notes list to reflect the deletion
                Navigator.pop(context); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
