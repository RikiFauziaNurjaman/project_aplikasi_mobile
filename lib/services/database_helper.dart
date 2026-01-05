import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:project_aplikasi_mobile/models/history_model.dart';
import 'package:project_aplikasi_mobile/models/favorite_model.dart';
import 'package:project_aplikasi_mobile/models/chapter_bookmark_model.dart';
import 'package:project_aplikasi_mobile/models/comment_model.dart';

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

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
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

    await db.execute('''
      CREATE TABLE comments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        comic_id TEXT,
        username TEXT,
        comment TEXT,
        created_at INTEGER
      )
    ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS comments (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          comic_id TEXT,
          username TEXT,
          comment TEXT,
          created_at INTEGER
        )
      ''');
    }
  }

  // HISTORY

  Future<int> upsertHistory(HistoryModel history) async {
    final db = await database;
    final existing = await db.query(
      'history',
      where: 'comic_id = ?',
      whereArgs: [history.comicId],
    );

    if (existing.isNotEmpty) {
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

  Future<List<HistoryModel>> getAllHistory() async {
    final db = await database;
    final result = await db.query('history', orderBy: 'last_read_at DESC');
    return result.map((map) => HistoryModel.fromMap(map)).toList();
  }

  Future<int> deleteHistory(String comicId) async {
    final db = await database;
    return await db.delete(
      'history',
      where: 'comic_id = ?',
      whereArgs: [comicId],
    );
  }

  Future<int> clearAllHistory() async {
    final db = await database;
    return await db.delete('history');
  }

  // FAVORITES

  Future<int> addFavorite(FavoriteModel favorite) async {
    final db = await database;
    return await db.insert(
      'favorites',
      favorite.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> removeFavorite(String comicId) async {
    final db = await database;
    return await db.delete(
      'favorites',
      where: 'comic_id = ?',
      whereArgs: [comicId],
    );
  }

  Future<bool> isFavorite(String comicId) async {
    final db = await database;
    final result = await db.query(
      'favorites',
      where: 'comic_id = ?',
      whereArgs: [comicId],
    );
    return result.isNotEmpty;
  }

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

  Future<List<FavoriteModel>> getAllFavorites() async {
    final db = await database;
    final result = await db.query('favorites', orderBy: 'added_at DESC');
    return result.map((map) => FavoriteModel.fromMap(map)).toList();
  }

  // CHAPTER BOOKMARKS

  Future<int> addChapterBookmark(ChapterBookmarkModel bookmark) async {
    final db = await database;
    return await db.insert(
      'chapter_bookmarks',
      bookmark.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> removeChapterBookmark(String chapterId) async {
    final db = await database;
    return await db.delete(
      'chapter_bookmarks',
      where: 'chapter_id = ?',
      whereArgs: [chapterId],
    );
  }

  Future<bool> isChapterBookmarked(String chapterId) async {
    final db = await database;
    final result = await db.query(
      'chapter_bookmarks',
      where: 'chapter_id = ?',
      whereArgs: [chapterId],
    );
    return result.isNotEmpty;
  }

  Future<List<ChapterBookmarkModel>> getAllChapterBookmarks() async {
    final db = await database;
    final result = await db.query(
      'chapter_bookmarks',
      orderBy: 'added_at DESC',
    );
    return result.map((map) => ChapterBookmarkModel.fromMap(map)).toList();
  }

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

  // COMMENTS

  Future<int> addComment(CommentModel comment) async {
    final db = await database;
    return await db.insert('comments', comment.toMap());
  }

  Future<List<CommentModel>> getCommentsByComic(String comicId) async {
    final db = await database;
    final result = await db.query(
      'comments',
      where: 'comic_id = ?',
      whereArgs: [comicId],
      orderBy: 'created_at DESC',
    );
    return result.map((map) => CommentModel.fromMap(map)).toList();
  }

  Future<int> deleteComment(int commentId) async {
    final db = await database;
    return await db.delete('comments', where: 'id = ?', whereArgs: [commentId]);
  }

  Future<int> deleteAllCommentsByComic(String comicId) async {
    final db = await database;
    return await db.delete(
      'comments',
      where: 'comic_id = ?',
      whereArgs: [comicId],
    );
  }

  Future<int> getCommentCount(String comicId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM comments WHERE comic_id = ?',
      [comicId],
    );
    return result.first['count'] as int? ?? 0;
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
