class Genre {
  final String title;
  final String slug;

  Genre({required this.title, required this.slug});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(title: json['title'] ?? '', slug: json['slug'] ?? '');
  }
}

class Chapter {
  final String title;
  final String slug;
  final String date;

  Chapter({required this.title, required this.slug, required this.date});

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      date: json['date'] ?? '',
    );
  }

  String get displayName {
    if (title.isNotEmpty) return title;
    List<String> parts = slug.split('-');
    String formatted = parts
        .map((part) {
          if (part.isEmpty) return '';
          return "${part[0].toUpperCase()}${part.substring(1)}";
        })
        .join(' ');

    return formatted;
  }
}

class ComicDetail {
  final String title;
  final String cover;
  final double rating;
  final String otherTitle;
  final String status;
  final String type;
  final String author;
  final String artist;
  final String release;
  final String series;
  final String readerCount;
  final String synopsis;
  final List<Genre> genres;
  final List<Chapter> chapters;

  ComicDetail({
    required this.title,
    required this.cover,
    required this.rating,
    required this.otherTitle,
    required this.status,
    required this.type,
    required this.author,
    required this.artist,
    required this.release,
    required this.series,
    required this.readerCount,
    required this.synopsis,
    required this.genres,
    required this.chapters,
  });

  factory ComicDetail.fromJson(Map<String, dynamic> json) {
    return ComicDetail(
      title: json['title'] ?? '',
      cover: json['cover'] ?? '',
      rating: double.tryParse(json['rating']?.toString() ?? '0') ?? 0.0,
      otherTitle: json['otherTitle'] ?? '',
      status: json['status'] ?? '',
      type: json['type'] ?? '',
      author: json['author'] ?? 'Unknown',
      artist: json['artist'] ?? 'Unknown',
      release: json['release'] ?? '',
      series: json['series'] ?? '',
      readerCount: json['reader'] ?? '',
      synopsis: json['synopsis'] ?? '',
      // Mapping List of Objects
      genres:
          (json['genres'] as List?)
              ?.map((item) => Genre.fromJson(item))
              .toList() ??
          [],
      chapters:
          (json['chapters'] as List?)
              ?.map((item) => Chapter.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class ComicDetailResponse {
  final String creator;
  final bool success;
  final ComicDetail? detail;

  ComicDetailResponse({
    required this.creator,
    required this.success,
    this.detail,
  });

  factory ComicDetailResponse.fromJson(Map<String, dynamic> json) {
    return ComicDetailResponse(
      creator: json['creator'] ?? '',
      success: json['success'] ?? false,
      detail: json['detail'] != null
          ? ComicDetail.fromJson(json['detail'])
          : null,
    );
  }
}
