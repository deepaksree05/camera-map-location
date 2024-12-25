import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  // Method to get the database instance
  static Future<Database> database() async {
    final dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, 'places.db'),
      onCreate: (db, version) {
        // Create the user_places table if it doesn't exist
        return db.execute('''
          CREATE TABLE user_places (
            id TEXT PRIMARY KEY,
            title TEXT,
            image TEXT,
            loc_lat REAL,
            loc_lng REAL,
            address TEXT
          )
        ''');
      },
      version: 1, // Increment this if you change the schema
    );
  }

  // Method to insert data into the database
  static Future<void> insert(String table, Map<String, Object> data) async {
    final sqlDb = await database(); // Use the database method to get the instance
    await sqlDb.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace, // Replace on conflict
    );
  }

  // Method to retrieve data from the database
  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final sqlDb = await database(); // Use the database method to get the instance
    return await sqlDb.query(table); // Query all rows from the specified table
  }
}