import 'package:flutter/material.dart';
import 'package:project_aplikasi_mobile/features/comics/presentation/screens/read_comic_screen.dart';
import 'package:project_aplikasi_mobile/models/detail_comic.dart';

class ChapterList extends StatelessWidget {
  final List<Chapter> chapters;

  const ChapterList({super.key, required this.chapters});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final chapter = chapters[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 0.0,
              ),
              title: Text(
                chapter.displayName,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              subtitle: Text(
                chapter.date,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Colors.grey,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ReadComicScreen(chapterSlug: chapter.slug),
                  ),
                );
              },
            ),
          );
        }, childCount: chapters.length),
      ),
    );
  }
}
