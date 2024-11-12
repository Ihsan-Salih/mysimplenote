import 'package:flutter/material.dart';
import '../controllers/note_controller.dart';
import '../models/note.dart';

class HomeScreen extends StatefulWidget {
  // Constructor for the HomeScreen widget. The 'super.key' is used for the key parameter.
  const HomeScreen({super.key}); 

  @override
  
  HomeScreenState createState() => HomeScreenState(); // Public state class for the HomeScreen widget
}

class HomeScreenState extends State<HomeScreen> { // The state class that manages the state of HomeScreen
  late NoteController _noteController; // The controller responsible for managing notes
  bool isLoading = false; // A flag to indicate if data is loading
  List<Note> notes = []; // A list to hold the notes

  @override
  void initState() {
    super.initState();  // Calls the initState method of the parent class
    // Initializes the NoteController and passes a callback function to update the note list
    _noteController = NoteController(context, updateNotesList);
    // Refreshes the notes list by fetching data from the database
    _noteController.refreshNotes();
  }

  // Callback function to update the notes list when data changes
  void updateNotesList(List<Note> updatedNotes) {
    setState(() {
      notes = updatedNotes;  // Updates the notes state and triggers a UI rebuild
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MySimpleNote'),  // Displays the title in the AppBar
        backgroundColor: Colors.blueAccent,  // Sets the background color of the AppBar
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())  // Displays loading indicator while loading
          : ListView.builder(  // Displays the list of notes using ListView
              itemCount: notes.length,  // Number of items in the list
              itemBuilder: (context, index) {
                final note = notes[index];  // Fetches the note at the current index
                return ListTile(
                  title: Text(note.title),  // Displays the title of the note
                  subtitle: Text(note.content),  // Displays the content of the note
                  leading: Container(  // Customizes the leading widget of the ListTile (for priority indicator)
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: note.priority == 1 ? Colors.red : Colors.grey,  // Red if high priority
                      shape: BoxShape.rectangle,  // Uses rectangular shape for the priority indicator
                      borderRadius: BorderRadius.circular(4),  
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),  // Icon to delete the note
                    onPressed: () => _noteController.deleteNoteDialog(note),  // Deletes the note when pressed
                  ),
                  onTap: () => _noteController.addOrUpdateNoteDialog(note),  // Opens dialog to update note on tap
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,  // Sets the background color 
        onPressed: () => _noteController.addOrUpdateNoteDialog(null),  // Opens dialog to add a new note
        child: const Icon(Icons.add),  // Adds an icon inside the floatingActionButton to indicate adding a note
      ),
    );
  }
}
