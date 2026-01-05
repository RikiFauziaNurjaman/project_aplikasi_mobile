/// Model untuk tabel chapter_bookmarks
/// Menyimpan chapter yang dibookmark user (favorit per chapter)
class ChapterBookmarkModel {
  final int? id;
  final String comicId;
  final String chapterId;
  final String? chapterTitle;
  final String? chapterNumber;
  final int? addedAt;

  ChapterBookmarkModel({
    this.id,
    required this.comicId,
    required this.chapterId,
    this.chapterTitle,
    this.chapterNumber,
    this.addedAt,
  });

  /// Convert dari Map (SQLite row) ke ChapterBookmarkModel
  factory ChapterBookmarkModel.fromMap(Map<String, dynamic> map) {
    return ChapterBookmarkModel(
      id: map['id'] as int?,
      comicId: map['comic_id'] as String,
      chapterId: map['chapter_id'] as String,
      chapterTitle: map['chapter_title'] as String?,
      chapterNumber: map['chapter_number'] as String?,
      addedAt: map['added_at'] as int?,
    );
  }

  /// Convert dari ChapterBookmarkModel ke Map (untuk insert ke SQLite)
  Map<String, dynamic> toMap() {
    return {
      'comic_id': comicId,
      'chapter_id': chapterId,
      'chapter_title': chapterTitle,
      'chapter_number': chapterNumber,
      'added_at': addedAt ?? DateTime.now().millisecondsSinceEpoch,
    };
  }

  /// Copy dengan modifikasi field tertentu
  ChapterBookmarkModel copyWith({
    int? id,
    String? comicId,
    String? chapterId,
    String? chapterTitle,
    String? chapterNumber,
    int? addedAt,
  }) {
    return ChapterBookmarkModel(
      id: id ?? this.id,
      comicId: comicId ?? this.comicId,
      chapterId: chapterId ?? this.chapterId,
      chapterTitle: chapterTitle ?? this.chapterTitle,
      chapterNumber: chapterNumber ?? this.chapterNumber,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}
