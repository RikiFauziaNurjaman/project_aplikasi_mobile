import 'package:flutter/material.dart';
import 'package:project_aplikasi_mobile/features/comics/presentation/widgets/ChapterList.dart';
import 'package:project_aplikasi_mobile/features/comics/presentation/widgets/chapter_filter.dart';
import 'package:project_aplikasi_mobile/features/comics/presentation/widgets/comic_header.dart';
import 'package:project_aplikasi_mobile/features/comics/presentation/widgets/comic_info.dart';
import 'package:project_aplikasi_mobile/models/list_comic.dart';

class ComicDetailScreen extends StatelessWidget {
  final Comic comic;
  const ComicDetailScreen({super.key, required this.comic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, comic),
          SliverToBoxAdapter(child: ComicInfo(comic: comic)),
          SliverToBoxAdapter(child: const ComicHeader()),
          SliverToBoxAdapter(child: const ChapterFilter()),
          ChapterList(chapters: comic.chapters),
        ],
      ),
    );
  }

  Widget _buildCircleIcon(IconData iconData, VoidCallback? onPressed) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle),
      child: IconButton(
        icon: Icon(iconData, color: Colors.white),
        onPressed: onPressed,
        iconSize: 24.0,
        splashRadius: 20.0,
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, Comic comic) {
    return SliverAppBar(
      expandedHeight: 250.0,
      pinned: true,
      backgroundColor: const Color(0xFF1F1F1F),

      leading: _buildCircleIcon(Icons.arrow_back, () {
        Navigator.of(context).pop();
      }),

      actions: [
        _buildCircleIcon(Icons.favorite, () {}),
        const SizedBox(width: 8),
        _buildCircleIcon(Icons.chat, () {}),
        const SizedBox(width: 12),
      ],

      flexibleSpace: FlexibleSpaceBar(
        background: Image.asset(
          comic.coverUrl,
          fit: BoxFit.cover,
          color: Colors.black.withOpacity(0.3),
          colorBlendMode: BlendMode.darken,
        ),
      ),
    );
  }
}
