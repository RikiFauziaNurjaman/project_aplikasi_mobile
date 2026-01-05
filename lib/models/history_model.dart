/// Model untuk tabel history
/// Menyimpan data komik yang pernah dibaca user
class HistoryModel {
  final String comicId;
  final String title;
  final String coverUrl;
  final String? lastChapterId;
  final String? lastChapterNumber;
  final int? lastReadAt;
  final int? totalChaptersRead;

  HistoryModel({
    required this.comicId,
    required this.title,
    required this.coverUrl,
    this.lastChapterId,
    this.lastChapterNumber,
    this.lastReadAt,
    this.totalChaptersRead,
  });

  /// Convert dari Map (SQLite row) ke HistoryModel
  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    return HistoryModel(
      comicId: map['comic_id'] as String,
      title: map['title'] as String? ?? '',
      coverUrl: map['cover_url'] as String? ?? '',
      lastChapterId: map['last_chapter_id'] as String?,
      lastChapterNumber: map['last_chapter_number'] as String?,
      lastReadAt: map['last_read_at'] as int?,
      totalChaptersRead: map['total_chapters_read'] as int?,
    );
  }

  /// Convert dari HistoryModel ke Map (untuk insert ke SQLite)
  Map<String, dynamic> toMap() {
    return {
      'comic_id': comicId,
      'title': title,
      'cover_url': coverUrl,
      'last_chapter_id': lastChapterId,
      'last_chapter_number': lastChapterNumber,
      'last_read_at': lastReadAt,
      'total_chapters_read': totalChaptersRead,
    };
  }

  /// Copy dengan modifikasi field tertentu
  HistoryModel copyWith({
    String? comicId,
    String? title,
    String? coverUrl,
    String? lastChapterId,
    String? lastChapterNumber,
    int? lastReadAt,
    int? totalChaptersRead,
  }) {
    return HistoryModel(
      comicId: comicId ?? this.comicId,
      title: title ?? this.title,
      coverUrl: coverUrl ?? this.coverUrl,
      lastChapterId: lastChapterId ?? this.lastChapterId,
      lastChapterNumber: lastChapterNumber ?? this.lastChapterNumber,
      lastReadAt: lastReadAt ?? this.lastReadAt,
      totalChaptersRead: totalChaptersRead ?? this.totalChaptersRead,
    );
  }
}
