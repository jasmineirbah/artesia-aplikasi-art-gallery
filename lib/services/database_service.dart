import 'dart:convert';

import 'package:artesia_aplikasi_art_gallery/models/user_model.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  DatabaseService._();

  static final DatabaseService instance = DatabaseService._();

  static const _databaseName = 'artesia_gallery.db';
  static const _databaseVersion = 5;
  static const usersTable = 'users';

  Database? _database;

  Future<Database> get database async {
    final existingDatabase = _database;
    if (existingDatabase != null) return existingDatabase;

    final database = await _openDatabase();
    _database = database;
    return database;
  }

  Future<Database> _openDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = p.join(databasesPath, _databaseName);

    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $usersTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        full_name TEXT NOT NULL COLLATE NOCASE UNIQUE,
        password_hash TEXT NOT NULL,
        created_at TEXT NOT NULL,
        last_login_at TEXT,
        profile_image TEXT
      )
    ''');

    await db.execute(
      'CREATE INDEX idx_users_full_name ON $usersTable(full_name)',
    );

    await _createFavoritesTable(db);
  }

  Future<void> _createFavoritesTable(Database db) async {
    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        artwork_id INTEGER NOT NULL,
        artwork_data TEXT,
        created_at TEXT NOT NULL,
        UNIQUE(user_id, artwork_id)
      )
    ''');
  }

  Future<void> _createFavoritesTableIfMissing(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        artwork_id INTEGER NOT NULL,
        artwork_data TEXT,
        created_at TEXT NOT NULL,
        UNIQUE(user_id, artwork_id)
      )
    ''');
  }

  Future<void> _addColumnIfMissing(
    Database db,
    String table,
    String column,
    String definition,
  ) async {
    final columns = await db.rawQuery('PRAGMA table_info($table)');
    final exists = columns.any((item) => item['name'] == column);

    if (!exists) {
      await db.execute('ALTER TABLE $table ADD COLUMN $column $definition');
    }
  }

  Future<void> _upgradeDatabase(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE $usersTable RENAME TO users_old');
      await _createDatabase(db, newVersion);
      await db.execute('''
        INSERT INTO $usersTable (
          id,
          full_name,
          password_hash,
          created_at,
          last_login_at
        )
        SELECT
          id,
          full_name,
          password_hash,
          created_at,
          last_login_at
        FROM users_old
      ''');
      await db.execute('DROP TABLE users_old');
    }

    if (oldVersion < 3) {
      await _createFavoritesTableIfMissing(db);
    }

    if (oldVersion < 4) {
      await _addColumnIfMissing(db, usersTable, 'profile_image', 'TEXT');
    }

    if (oldVersion < 5) {
      await _createFavoritesTableIfMissing(db);
      await _addColumnIfMissing(db, 'favorites', 'artwork_data', 'TEXT');
    }
  }

  Future<int> createUser(UserModel user) async {
    final db = await database;
    return db.insert(
      usersTable,
      user.toMap()..remove('id'),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<UserModel?> getUserByName(String fullName) async {
    final db = await database;
    final rows = await db.query(
      usersTable,
      where: 'full_name = ? COLLATE NOCASE',
      whereArgs: [fullName.trim()],
      limit: 1,
    );

    if (rows.isEmpty) return null;
    return UserModel.fromMap(rows.first);
  }

  Future<bool> nameExists(String fullName) async {
    final user = await getUserByName(fullName);
    return user != null;
  }

  Future<int> updateLastLogin(int userId, DateTime loginTime) async {
    final db = await database;
    return db.update(
      usersTable,
      {'last_login_at': loginTime.toIso8601String()},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<void> addFavorite(int userId, int artworkId) async {
    final db = await database;

    await db.insert('favorites', {
      'user_id': userId,
      'artwork_id': artworkId,
      'created_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> addFavoriteArtwork(
    int userId,
    Map<String, dynamic> artwork,
  ) async {
    final db = await database;
    final artworkId = artwork['id'];

    if (artworkId is! int) return;

    await db.insert('favorites', {
      'user_id': userId,
      'artwork_id': artworkId,
      'artwork_data': jsonEncode(artwork),
      'created_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeFavorite(int userId, int artworkId) async {
    final db = await database;

    await db.delete(
      'favorites',
      where: 'user_id = ? AND artwork_id = ?',
      whereArgs: [userId, artworkId],
    );
  }

  Future<List<int>> getUserFavorites(int userId) async {
    final db = await database;

    final result = await db.query(
      'favorites',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    return result.map((e) => e['artwork_id'] as int).toList();
  }

  Future<List<Map<String, dynamic>>> getUserFavoriteArtworks(int userId) async {
    final db = await database;

    final result = await db.query(
      'favorites',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );

    return result.map((row) {
      final rawArtworkData = row['artwork_data'] as String?;

      if (rawArtworkData != null && rawArtworkData.isNotEmpty) {
        try {
          final decoded = Map<String, dynamic>.from(
            jsonDecode(rawArtworkData) as Map,
          );
          decoded['id'] ??= row['artwork_id'];
          return decoded;
        } catch (_) {
          // Pakai data cadangan di bawah kalau data lama tidak bisa dibaca.
        }
      }

      final artworkId = row['artwork_id'] as int;
      return {
        'id': artworkId,
        'title': 'Artwork #$artworkId',
        'artist': 'Unknown Artist',
        'image': '',
        'medium': 'Unknown medium',
        'price': '',
        'category': 'Art',
        'culture': 'Unknown',
        'dimensions': 'Unknown size',
        'location': 'Unknown Museum',
      };
    }).toList();
  }

  Future<void> updateProfileImage(int userId, String imagePath) async {
    final db = await database;

    await db.update(
      usersTable,
      {'profile_image': imagePath},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
}
