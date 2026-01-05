/// Model untuk tabel favorites
/// Menyimpan komik yang difavoritkan user
class FavoriteModel {
  final int? id;
  final String comicId;
  final String title;
  final String coverUrl;
  final String? type; // Manga/Manhwa/Manhua
  final int? addedAt;

  FavoriteModel({
    this.id,
    required this.comicId,
    required this.title,
    required this.coverUrl,
    this.type,
    this.addedAt,
  });

  /// Convert dari Map (SQLite row) ke FavoriteModel
  factory FavoriteModel.fromMap(Map<String, dynamic> map) {
    return FavoriteModel(
      id: map['id'] as int?,
      comicId: map['comic_id'] as String,
      title: map['title'] as String? ?? '',
      coverUrl: map['cover_url'] as String? ?? '',
      type: map['type'] as String?,
      addedAt: map['added_at'] as int?,
    );
  }

  /// Convert dari FavoriteModel ke Map (untuk insert ke SQLite)
  Map<String, dynamic> toMap() {
    return {
      'comic_id': comicId,
      'title': title,
      'cover_url': coverUrl,
      'type': type,
      'added_at': addedAt ?? DateTime.now().millisecondsSinceEpoch,
    };
  }

  /// Copy dengan modifikasi field tertentu
  FavoriteModel copyWith({
    int? id,
    String? comicId,
    String? title,
    String? coverUrl,
    String? type,
    int? addedAt,
  }) {
    return FavoriteModel(
      id: id ?? this.id,
      comicId: comicId ?? this.comicId,
      title: title ?? this.title,
      coverUrl: coverUrl ?? this.coverUrl,
      type: type ?? this.type,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}
