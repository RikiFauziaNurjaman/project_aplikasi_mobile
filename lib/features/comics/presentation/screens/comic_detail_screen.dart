import 'package:flutter/material.dart';
import 'package:project_aplikasi_mobile/components/navbar/navbar.dart';
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
      bottomNavigationBar: const Navbar(currentIndex: 0),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, Comic comic) {
    return SliverAppBar(
      expandedHeight: 250.0,
      pinned: true,
      backgroundColor: const Color(0xFF1F1F1F),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_border, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
          onPressed: () {},
        ),
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
