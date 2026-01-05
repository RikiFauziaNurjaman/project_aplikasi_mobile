import 'package:flutter/material.dart';
import 'package:project_aplikasi_mobile/features/comics/presentation/widgets/ChapterList.dart';
import 'package:project_aplikasi_mobile/features/comics/presentation/widgets/chapter_filter.dart';
import 'package:project_aplikasi_mobile/features/comics/presentation/widgets/comic_header.dart';
import 'package:project_aplikasi_mobile/features/comics/presentation/widgets/comic_info.dart';
import 'package:project_aplikasi_mobile/features/comics/presentation/widgets/comment_bottom_sheet.dart';
import 'package:project_aplikasi_mobile/models/detail_comic.dart';
import 'package:project_aplikasi_mobile/services/database_helper.dart';
import 'package:project_aplikasi_mobile/models/favorite_model.dart';

class ComicDetailScreen extends StatefulWidget {
  final ComicDetail comic;
  final String comicSlug;

  const ComicDetailScreen({
    super.key,
    required this.comic,
    required this.comicSlug,
  });

  @override
  State<ComicDetailScreen> createState() => _ComicDetailScreenState();
}

class _ComicDetailScreenState extends State<ComicDetailScreen> {
  List<Chapter> _displayedChapters = [];
  List<String> _filterRanges = [];
  int _selectedFilterIndex = 0;
  final int _chunkSize = 50;

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  bool _isFavorite = false;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _generateFilterRanges();
    _updateDisplayedChapters(0);
    _checkFavoriteStatus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.trim();
      _isSearching = _searchQuery.isNotEmpty;
    });

    if (_isSearching) {
      final filtered = widget.comic.chapters.where((chapter) {
        final chapterTitle = chapter.title.toLowerCase();
        final searchLower = _searchQuery.toLowerCase();

        // Match exact chapter number
        final chapterNumbers = RegExp(r'\d+').allMatches(chapterTitle);
        for (var match in chapterNumbers) {
          if (match.group(0) == _searchQuery) {
            return true;
          }
        }

        return chapterTitle.contains(searchLower);
      }).toList();

      setState(() => _displayedChapters = filtered);
    } else {
      _updateDisplayedChapters(_selectedFilterIndex);
    }
  }

  Future<void> _checkFavoriteStatus() async {
    try {
      final isFav = await _dbHelper.isFavorite(widget.comicSlug);
      if (mounted) setState(() => _isFavorite = isFav);
    } catch (e) {
      if (mounted) setState(() => _isFavorite = false);
    }
  }

  Future<void> _toggleFavorite() async {
    try {
      final favorite = FavoriteModel(
        comicId: widget.comicSlug,
        title: widget.comic.title,
        coverUrl: widget.comic.cover,
        type: widget.comic.type,
        addedAt: DateTime.now().millisecondsSinceEpoch,
      );

      final newStatus = await _dbHelper.toggleFavorite(favorite);
      if (mounted) {
        setState(() => _isFavorite = newStatus);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  newStatus ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  newStatus
                      ? 'Ditambahkan ke favorit ❤️'
                      : 'Dihapus dari favorit',
                ),
              ],
            ),
            backgroundColor: newStatus ? Colors.green : Colors.grey[700],
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal mengubah status favorit'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showComments() {
    CommentBottomSheet.show(context, widget.comicSlug, widget.comic.title);
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

    setState(() => _filterRanges = ranges);
  }

  void _updateDisplayedChapters(int index) {
    int start = index * _chunkSize;
    int end = start + _chunkSize;
    if (end > widget.comic.chapters.length) end = widget.comic.chapters.length;

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
          SliverToBoxAdapter(
            child: ComicHeader(
              searchController: _searchController,
              onSearchChanged: _onSearchChanged,
            ),
          ),
          SliverToBoxAdapter(
            child: ChapterFilter(
              ranges: _filterRanges,
              selectedIndex: _selectedFilterIndex,
              onFilterSelected: _updateDisplayedChapters,
            ),
          ),
          ChapterList(
            chapters: _displayedChapters,
            comicId: widget.comicSlug,
            comicTitle: widget.comic.title,
            coverUrl: widget.comic.cover,
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildCircleIcon(IconData iconData, VoidCallback? onPressed) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
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
      automaticallyImplyLeading: false,
      leading: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
          iconSize: 24.0,
          splashRadius: 20.0,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: _toggleFavorite,
            iconSize: 24.0,
            splashRadius: 20.0,
          ),
        ),
        const SizedBox(width: 8),
        _buildCircleIcon(Icons.chat, _showComments),
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
