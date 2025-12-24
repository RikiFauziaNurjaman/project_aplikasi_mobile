import 'package:flutter/material.dart';
import 'package:project_aplikasi_mobile/features/comics/presentation/widgets/ChapterList.dart';
import 'package:project_aplikasi_mobile/features/comics/presentation/widgets/chapter_filter.dart';
import 'package:project_aplikasi_mobile/features/comics/presentation/widgets/comic_header.dart';
import 'package:project_aplikasi_mobile/features/comics/presentation/widgets/comic_info.dart';
import 'package:project_aplikasi_mobile/models/detail_comic.dart';

class ComicDetailScreen extends StatefulWidget {
  final ComicDetail comic;
  const ComicDetailScreen({super.key, required this.comic});

  @override
  State<ComicDetailScreen> createState() => _ComicDetailScreenState();
}

class _ComicDetailScreenState extends State<ComicDetailScreen> {
  List<Chapter> _displayedChapters = [];
  List<String> _filterRanges = [];
  int _selectedFilterIndex = 0;
  final int _chunkSize = 50;

  @override
  void initState() {
    super.initState();
    _generateFilterRanges();
    _updateDisplayedChapters(0);
  }

  void _generateFilterRanges() {
    int totalChapters = widget.comic.chapters.length;
    int chunks = (totalChapters / _chunkSize).ceil();

    List<String> ranges = [];
    for (int i = 0; i < chunks; i++) {
      int start = (i * _chunkSize) + 1;
      int end = ((i + 1) * _chunkSize);
      if (end > totalChapters) end = totalChapters;

      ranges.add('$start-$end');
    }

    setState(() {
      _filterRanges = ranges;
    });
  }

  void _updateDisplayedChapters(int index) {
    int start = index * _chunkSize;
    int end = start + _chunkSize;

    if (end > widget.comic.chapters.length) {
      end = widget.comic.chapters.length;
    }

    setState(() {
      _selectedFilterIndex = index;
      _displayedChapters = widget.comic.chapters.sublist(start, end);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(child: ComicInfo(comic: widget.comic)),
          SliverToBoxAdapter(child: const ComicHeader()),
          SliverToBoxAdapter(
            child: ChapterFilter(
              ranges: _filterRanges,
              selectedIndex: _selectedFilterIndex,
              onFilterSelected: (index) {
                _updateDisplayedChapters(index);
              },
            ),
          ),
          ChapterList(chapters: _displayedChapters),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),
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

  Widget _buildSliverAppBar(BuildContext context) {
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
        background: Image.network(
          widget.comic.cover,
          fit: BoxFit.cover,
          color: Colors.black.withOpacity(0.3),
          colorBlendMode: BlendMode.darken,
          errorBuilder: (context, error, stackTrace) => const Center(
            child: Icon(Icons.broken_image, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
