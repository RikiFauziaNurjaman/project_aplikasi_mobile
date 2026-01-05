import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:project_aplikasi_mobile/models/history_model.dart';
import 'package:project_aplikasi_mobile/models/favorite_model.dart';
import 'package:project_aplikasi_mobile/models/chapter_bookmark_model.dart';

/// Singleton Database Helper untuk SQLite
/// Mengelola 3 tabel: history, favorites, chapter_bookmarks
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('comicu.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    // Tabel History - comic_id sebagai PRIMARY KEY
    await db.execute('''
      CREATE TABLE history (
        comic_id TEXT PRIMARY KEY,
        title TEXT,
        cover_url TEXT,
        last_chapter_id TEXT,
        last_chapter_number TEXT,
        last_read_at INTEGER,
        total_chapters_read INTEGER
      )
    ''');

    // Tabel Favorites - comic_id sebagai UNIQUE
    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        comic_id TEXT UNIQUE,
        title TEXT,
        cover_url TEXT,
        type TEXT,
        added_at INTEGER
      )
    ''');

    // Tabel Chapter Bookmarks - chapter_id sebagai UNIQUE
    await db.execute('''
      CREATE TABLE chapter_bookmarks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        comic_id TEXT,
        chapter_id TEXT UNIQUE,
        chapter_title TEXT,
        chapter_number TEXT,
        added_at INTEGER
      )
    ''');
  }

  // ============== HISTORY OPERATIONS ==============

  /// Insert atau Update history (UPSERT)
  /// Jika comic_id sudah ada, lakukan UPDATE
  Future<int> upsertHistory(HistoryModel history) async {
    final db = await database;

    // Cek apakah comic sudah ada di history
    final existing = await db.query(
      'history',
      where: 'comic_id = ?',
      whereArgs: [history.comicId],
    );

    if (existing.isNotEmpty) {
      // UPDATE - tambah total chapters read
      final oldHistory = HistoryModel.fromMap(existing.first);
      final updatedHistory = HistoryModel(
        comicId: history.comicId,
        title: history.title,
        coverUrl: history.coverUrl,
        lastChapterId: history.lastChapterId,
        lastChapterNumber: history.lastChapterNumber,
        lastReadAt: history.lastReadAt,
        totalChaptersRead: (oldHistory.totalChaptersRead ?? 0) + 1,
      );

      return await db.update(
        'history',
        updatedHistory.toMap(),
        where: 'comic_id = ?',
        whereArgs: [history.comicId],
      );
    } else {
      // INSERT baru
      final newHistory = HistoryModel(
        comicId: history.comicId,
        title: history.title,
        coverUrl: history.coverUrl,
        lastChapterId: history.lastChapterId,
        lastChapterNumber: history.lastChapterNumber,
        lastReadAt: history.lastReadAt,
        totalChaptersRead: 1,
      );
      return await db.insert('history', newHistory.toMap());
    }
  }

  /// Ambil semua history, urut berdasarkan waktu terakhir dibaca
  Future<List<HistoryModel>> getAllHistory() async {
    final db = await database;
    final result = await db.query('history', orderBy: 'last_read_at DESC');
    return result.map((map) => HistoryModel.fromMap(map)).toList();
  }

  /// Hapus history berdasarkan comic_id
  Future<int> deleteHistory(String comicId) async {
    final db = await database;
    return await db.delete(
      'history',
      where: 'comic_id = ?',
      whereArgs: [comicId],
    );
  }

  /// Hapus semua history
  Future<int> clearAllHistory() async {
    final db = await database;
    return await db.delete('history');
  }

  // ============== FAVORITES OPERATIONS ==============

  /// Tambah komik ke favorites
  Future<int> addFavorite(FavoriteModel favorite) async {
    final db = await database;
    return await db.insert(
      'favorites',
      favorite.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Hapus komik dari favorites
  Future<int> removeFavorite(String comicId) async {
    final db = await database;
    return await db.delete(
      'favorites',
      where: 'comic_id = ?',
      whereArgs: [comicId],
    );
  }

  /// Cek apakah komik ada di favorites
  Future<bool> isFavorite(String comicId) async {
    final db = await database;
    final result = await db.query(
      'favorites',
      where: 'comic_id = ?',
      whereArgs: [comicId],
    );
    return result.isNotEmpty;
  }

  /// Toggle favorite status
  Future<bool> toggleFavorite(FavoriteModel favorite) async {
    final isFav = await isFavorite(favorite.comicId);
    if (isFav) {
      await removeFavorite(favorite.comicId);
      return false;
    } else {
      await addFavorite(favorite);
      return true;
    }
  }

  /// Ambil semua favorites
  Future<List<FavoriteModel>> getAllFavorites() async {
    final db = await database;
    final result = await db.query('favorites', orderBy: 'added_at DESC');
    return result.map((map) => FavoriteModel.fromMap(map)).toList();
  }

  // ============== CHAPTER BOOKMARKS OPERATIONS ==============

  /// Tambah chapter ke bookmarks
  Future<int> addChapterBookmark(ChapterBookmarkModel bookmark) async {
    final db = await database;
    return await db.insert(
      'chapter_bookmarks',
      bookmark.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Hapus chapter dari bookmarks
  Future<int> removeChapterBookmark(String chapterId) async {
    final db = await database;
    return await db.delete(
      'chapter_bookmarks',
      where: 'chapter_id = ?',
      whereArgs: [chapterId],
    );
  }

  /// Cek apakah chapter ada di bookmarks
  Future<bool> isChapterBookmarked(String chapterId) async {
    final db = await database;
    final result = await db.query(
      'chapter_bookmarks',
      where: 'chapter_id = ?',
      whereArgs: [chapterId],
    );
    return result.isNotEmpty;
  }

  /// Ambil semua chapter bookmarks
  Future<List<ChapterBookmarkModel>> getAllChapterBookmarks() async {
    final db = await database;
    final result = await db.query(
      'chapter_bookmarks',
      orderBy: 'added_at DESC',
    );
    return result.map((map) => ChapterBookmarkModel.fromMap(map)).toList();
  }

  /// Ambil chapter bookmarks berdasarkan comic_id
  Future<List<ChapterBookmarkModel>> getChapterBookmarksByComic(
    String comicId,
  ) async {
    final db = await database;
    final result = await db.query(
      'chapter_bookmarks',
      where: 'comic_id = ?',
      whereArgs: [comicId],
      orderBy: 'added_at DESC',
    );
    return result.map((map) => ChapterBookmarkModel.fromMap(map)).toList();
  }

  // ============== DATABASE MANAGEMENT ==============

  /// Tutup koneksi database
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
