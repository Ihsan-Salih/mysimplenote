import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '/models/note.dart';

class DBHelper {
  // Singleton instance to ensure only one instance of DBHelper is used
  static final DBHelper instance = DBHelper._init();
  
  // The database object, initially null until initialized
  static Database? _database;

  // Private constructor to prevent direct instantiation
  DBHelper._init();

  // Getter for the database, initializes it if not already done
  Future<Database> get database async {
    if (_database != null) return _database!; // If the DB is already initialized, return it
    _database = await _initDB('notes.db'); // Otherwise, initialize the DB
    return _database!; // Return the database object
  }

  // Function to initialize the database, specifying the database path and version
  Future<Database> _initDB(String path) async {
    final dbPath = await getDatabasesPath(); // Get the path to store the database
    final dbLocation = join(dbPath, path); // Create the full path by joining db path and file name
    return openDatabase(dbLocation, version: 1, onCreate: _createDB); // Open or create the database
  }

  // Function to create the database and its tables when the database is first created
  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT'; // ID field type
    const textType = 'TEXT NOT NULL'; // Text field type (title and content)
    const intType = 'INTEGER NOT NULL'; // Integer field type (priority)

    // SQL statement to create the 'notes' table with columns id, title, content, and priority
    await db.execute('''
      CREATE TABLE notes (
        id $idType,
        title $textType,
        content $textType,
        priority $intType
      )
    ''');
  }

  // Function to insert a new note into the database
  Future<int> create(Note note) async {
    final db = await instance.database; // Get the database instance
    return db.insert('notes', note.toMap()); // Insert the note and return the result (row ID)
  }

  // Function to read all notes from the database
  Future<List<Note>> readAllNotes() async {
    final db = await instance.database; // Get the database instance
    final result = await db.query('notes'); // Query the 'notes' table
    return result.map((e) => Note.fromMap(e)).toList(); // Convert each result to a Note object and return a list
  }

  // Function to update an existing note in the database
  Future<int> update(Note note) async {
    final db = await instance.database; // Get the database instance
    return db.update(
      'notes', // Table name
      note.toMap(), // Note data as map
      where: 'id = ?', // Where clause to find the note by ID
      whereArgs: [note.id], // Arguments for the where clause
    );
  }

  // Function to delete a note from the database by ID
  Future<int> delete(int id) async {
    final db = await instance.database; // Get the database instance
    return db.delete(
      'notes', // Table name
      where: 'id = ?', // Where clause to find the note by ID
      whereArgs: [id], // Arguments for the where clause (note ID)
    );
  }
}
