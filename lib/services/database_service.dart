import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'user_info.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  // Create table
  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firstname TEXT,
        lastname TEXT,
        dob TEXT,
        mobile TEXT
      )
    ''');
  }

  // Insert
  Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert(
      'user',
      user,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // list
  Future<List<Map<String, dynamic>>> getUsers({int limit = 10, int offset = 0}) async {
    final db = await database;
    return await db.query(
      'user',
      orderBy: 'id DESC',
      limit: limit,
      offset: offset,
    );
  }

  Future<int> getCount() async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM user');
    print("this is count from table ${maps.length}");
    return maps.length;
  }

  // Get by id
  Future<Map<String, dynamic>?> getUser(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return null;
    }
  }

  // Update user
  Future<void> updateUser(int id, Map<String, dynamic> user) async {
    final db = await database;
    await db.update(
      'user',
      user,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete user
  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete(
      'user',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Search firstname or lastname
  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    final db = await database;
    return await db.query(
      'user',
      where: 'firstname LIKE ? OR lastname LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'id DESC',
    );
  }
}
