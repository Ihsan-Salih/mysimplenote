// models/note.dart
class Note {
  final int? id; // Unique identifier for the note
  final String title; // Title of the note
  final String content; // Content of the note
  final int priority; // Priority of the note (0 for low, 1 for high)

  // Constructor to initialize the note
  Note({
    this.id,
    required this.title,
    required this.content,
    required this.priority,
  });

  // Convert a Note object to a Map to store in the database
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Optional id, needed when updating
      'title': title,
      'content': content,
      'priority': priority,
    };
  }

  // Convert a Map from the database into a Note object
  static Note fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'], // Get id from the map
      title: map['title'],
      content: map['content'],
      priority: map['priority'],
    );
  }
}
