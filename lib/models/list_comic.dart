import 'package:project_aplikasi_mobile/models/chapter_comic.dart';

class Comic {
  final String id;
  final String title;
  final String author;
  final String coverUrl;
  final String description;
  final double rating;
  final String viewCount;
  final List<String> tags;
  final List<Chapter> chapters;
  final String latestChapter;

  Comic({
    required this.id,
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.description,
    required this.rating,
    required this.viewCount,
    required this.tags,
    required this.chapters,
    required this.latestChapter,
  });
}
