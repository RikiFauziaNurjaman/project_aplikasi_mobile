class CommentModel {
  final int? id;
  final String comicId;
  final String username;
  final String comment;
  final int createdAt;

  CommentModel({
    this.id,
    required this.comicId,
    required this.username,
    required this.comment,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'comic_id': comicId,
      'username': username,
      'comment': comment,
      'created_at': createdAt,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] as int?,
      comicId: map['comic_id'] as String? ?? '',
      username: map['username'] as String? ?? 'Anonymous',
      comment: map['comment'] as String? ?? '',
      createdAt: map['created_at'] as int? ?? 0,
    );
  }

  String get timeAgo {
    final now = DateTime.now().millisecondsSinceEpoch;
    final diff = now - createdAt;

    final seconds = diff ~/ 1000;
    final minutes = seconds ~/ 60;
    final hours = minutes ~/ 60;
    final days = hours ~/ 24;

    if (days > 0) return '$days hari lalu';
    if (hours > 0) return '$hours jam lalu';
    if (minutes > 0) return '$minutes menit lalu';
    return 'Baru saja';
  }
}
