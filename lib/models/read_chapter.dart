class ReadChapterModel {
  final String title;
  final List<String> images;
  final String? nextSlug;
  final String? prevSlug;

  ReadChapterModel({
    required this.title,
    required this.images,
    this.nextSlug,
    this.prevSlug,
  });

  factory ReadChapterModel.fromJson(Map<String, dynamic> json) {
    final nav = json['navigation'] as Map<String, dynamic>?;

    return ReadChapterModel(
      title: json['title'] ?? '',
      images:
          (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
      nextSlug: nav?['next'],
      prevSlug: nav?['prev'],
    );
  }
}
