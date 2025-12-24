class Comic {
  final String title;
  final String slug;
  final String coverUrl;
  final String latestChapter;
  final double rating;
  final String? date;
  final String? type;
  final String? genre;

  Comic({
    required this.title,
    required this.slug,
    required this.coverUrl,
    required this.latestChapter,
    this.rating = 0.0,
    this.date,
    this.type,
    this.genre,
  });

  factory Comic.fromJson(Map<String, dynamic> json) {
    return Comic(
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      coverUrl: json['cover'] ?? '',
      latestChapter: json['chapter'] ?? 'Unknown',
      rating: double.tryParse(json['rating']?.toString() ?? '0') ?? 0.0,
      date: json['date'],
      type: json['type'],
      genre: json['genre'],
    );
  }
}

class Pagination {
  final int currentPage;
  final bool hasNextPage;

  Pagination({required this.currentPage, required this.hasNextPage});

  factory Pagination.fromRootJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['currentPage'] ?? 1,
      hasNextPage: json['hasNextPage'] ?? false,
    );
  }
}

class ComicResponse {
  final String creator;
  final bool success;
  final List<Comic> comics;
  final Pagination pagination;

  ComicResponse({
    required this.creator,
    required this.success,
    required this.comics,
    required this.pagination,
  });

  factory ComicResponse.fromJson(Map<String, dynamic> json) {
    return ComicResponse(
      creator: json['creator'] ?? '',
      success: json['success'] ?? false,
      comics:
          (json['komikList'] as List?)
              ?.map((item) => Comic.fromJson(item))
              .toList() ??
          [],
      pagination: Pagination.fromRootJson(json),
    );
  }
}
