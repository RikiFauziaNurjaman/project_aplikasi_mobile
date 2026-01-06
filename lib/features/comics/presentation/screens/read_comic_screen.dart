import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_aplikasi_mobile/api/comic_api.dart';
import 'package:project_aplikasi_mobile/models/read_chapter.dart';
import 'package:project_aplikasi_mobile/services/database_helper.dart';
import 'package:project_aplikasi_mobile/models/history_model.dart';
import 'package:project_aplikasi_mobile/models/chapter_bookmark_model.dart';

class ReadComicScreen extends StatefulWidget {
  final String chapterSlug;
  final String? comicId;
  final String? comicTitle;
  final String? coverUrl;
  final String? chapterNumber;

  const ReadComicScreen({
    super.key,
    required this.chapterSlug,
    this.comicId,
    this.comicTitle,
    this.coverUrl,
    this.chapterNumber,
  });

  @override
  State<ReadComicScreen> createState() => _ReadComicScreenState();
}

class _ReadComicScreenState extends State<ReadComicScreen> {
  final ComicApi _api = ComicApi();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final ScrollController _scrollController = ScrollController();

  // State Variables
  bool _isMenuVisible = true;
  bool _isLoading = true;
  int _currentPage = 1;
  int _totalPages = 0;
  ReadChapterModel? _chapterData;

  bool _isFavorite = false;
  bool _isAutoPlaying = false;
  bool _isFullscreen = false;
  Timer? _autoPlayTimer;

  @override
  void initState() {
    super.initState();
    _fetchChapterData(widget.chapterSlug);
    _saveToHistory();
    _checkFavoriteStatus();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _autoPlayTimer?.cancel();
    // Reset system UI mode when leaving screen
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  /// Cek status favorite chapter
  Future<void> _checkFavoriteStatus() async {
    final isFav = await _dbHelper.isChapterBookmarked(widget.chapterSlug);
    if (mounted) {
      setState(() => _isFavorite = isFav);
    }
  }

  /// Toggle favorite status
  Future<void> _toggleFavorite() async {
    if (_isFavorite) {
      await _dbHelper.removeChapterBookmark(widget.chapterSlug);
    } else {
      final bookmark = ChapterBookmarkModel(
        comicId: widget.comicId ?? '',
        chapterId: widget.chapterSlug,
        chapterTitle: _chapterData?.title ?? '',
        chapterNumber: widget.chapterNumber ?? '',
        addedAt: DateTime.now().millisecondsSinceEpoch,
      );
      await _dbHelper.addChapterBookmark(bookmark);
    }

    if (mounted) {
      setState(() => _isFavorite = !_isFavorite);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isFavorite
                ? 'Chapter ditambahkan ke bookmark'
                : 'Chapter dihapus dari bookmark',
          ),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// Simpan atau update history ke SQLite
  Future<void> _saveToHistory() async {
    if (widget.comicId != null && widget.comicTitle != null) {
      final history = HistoryModel(
        comicId: widget.comicId!,
        title: widget.comicTitle!,
        coverUrl: widget.coverUrl ?? '',
        lastChapterId: widget.chapterSlug,
        lastChapterNumber: widget.chapterNumber ?? '',
        lastReadAt: DateTime.now().millisecondsSinceEpoch,
      );
      await _dbHelper.upsertHistory(history);
    }
  }

  /// Fungsi ambil data
  void _fetchChapterData(String slug) async {
    setState(() => _isLoading = true);
    final data = await _api.getChapterImages(slug);

    if (mounted) {
      setState(() {
        _chapterData = data;
        _isLoading = false;
        _totalPages = data?.images.length ?? 0;
        _currentPage = 1;
      });
    }
  }

  /// Track current page based on scroll position
  void _onScroll() {
    if (_chapterData == null || _totalPages == 0) return;
    if (!_scrollController.hasClients) return;

    final scrollPosition = _scrollController.position.pixels;
    final maxScroll = _scrollController.position.maxScrollExtent;

    // Calculate approximate page based on scroll position
    final estimatedPageHeight = maxScroll / _totalPages;
    int newPage = (scrollPosition / estimatedPageHeight).floor() + 1;
    newPage = newPage.clamp(1, _totalPages);

    if (_currentPage != newPage) {
      setState(() => _currentPage = newPage);
    }
  }

  void _toggleMenu() {
    setState(() {
      _isMenuVisible = !_isMenuVisible;
    });
  }

  /// Scroll to previous page
  void _previousPage() {
    if (_currentPage > 1) {
      final targetPage = _currentPage - 1;
      _scrollToPage(targetPage);
    }
  }

  /// Scroll to next page
  void _nextPage() {
    if (_currentPage < _totalPages) {
      final targetPage = _currentPage + 1;
      _scrollToPage(targetPage);
    }
  }

  /// Scroll to specific page
  void _scrollToPage(int page) {
    if (_scrollController.hasClients && page >= 1 && page <= _totalPages) {
      // Estimate scroll position based on page number
      final estimatedHeight =
          _scrollController.position.maxScrollExtent / _totalPages;
      final targetOffset = estimatedHeight * (page - 1);

      _scrollController.animateTo(
        targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentPage = page);
    }
  }

  /// Toggle autoplay
  void _toggleAutoPlay() {
    setState(() {
      _isAutoPlaying = !_isAutoPlaying;
    });

    if (_isAutoPlaying) {
      _startAutoPlay();
    } else {
      _stopAutoPlay();
    }
  }

  /// Start auto scrolling
  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < _totalPages) {
        _nextPage();
      } else {
        // Stop at end
        _stopAutoPlay();
      }
    });
  }

  /// Stop auto scrolling
  void _stopAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = null;
    if (mounted) {
      setState(() => _isAutoPlaying = false);
    }
  }

  /// Show settings bottom sheet
  void _showSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Pengaturan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.fullscreen, color: Colors.white),
                title: const Text(
                  'Fullscreen Mode',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Colors.white54,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _toggleFullscreen();
                },
              ),
              ListTile(
                leading: const Icon(Icons.speed, color: Colors.white),
                title: const Text(
                  'Auto-scroll Speed',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text(
                  '3 detik/halaman',
                  style: TextStyle(color: Colors.white54),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Colors.white54,
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Future: show speed selector
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  /// Toggle fullscreen mode
  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });

    if (_isFullscreen) {
      // Enter fullscreen - hide system UI
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      // Exit fullscreen - show system UI normally
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
    }
  }

  /// Navigate to different chapter
  void _navigateToChapter(String slug) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ReadComicScreen(
          chapterSlug: slug,
          comicId: widget.comicId,
          comicTitle: widget.comicTitle,
          coverUrl: widget.coverUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _chapterData == null
          ? const Center(
              child: Text(
                "Gagal memuat chapter",
                style: TextStyle(color: Colors.white),
              ),
            )
          : GestureDetector(
              onTap: _toggleMenu,
              child: Stack(
                children: [
                  // --- LAPISAN 1: LIST GAMBAR ---
                  InteractiveViewer(
                    minScale: 1.0,
                    maxScale: 3.0,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _chapterData!.images.length + 1,
                      itemBuilder: (context, index) {
                        // A. Bagian Tombol Navigasi Bawah (Item Terakhir)
                        if (index == _chapterData!.images.length) {
                          return _buildBottomNavigation();
                        }

                        // B. Bagian Gambar Komik
                        return Image.network(
                          'https://images.weserv.nl/?url=${Uri.encodeComponent(_chapterData!.images[index])}&output=webp',
                          fit: BoxFit.fitWidth,
                          width: double.infinity,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 300,
                              color: Colors.grey[900],
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white24,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 200,
                              color: Colors.grey[900],
                              child: const Icon(
                                Icons.broken_image,
                                color: Colors.white54,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  // Header
                  _buildHeader(),

                  // Bottom Bar
                  _buildBottomBar(),
                ],
              ),
            ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      color: Colors.black,
      child: Column(
        children: [
          const Text(
            "Chapter Selesai",
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Tombol PREV
              if (_chapterData!.prevSlug != null)
                ElevatedButton.icon(
                  onPressed: () => _navigateToChapter(_chapterData!.prevSlug!),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Previous"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                  ),
                ),

              // Tombol NEXT
              if (_chapterData!.nextSlug != null)
                ElevatedButton.icon(
                  onPressed: () => _navigateToChapter(_chapterData!.nextSlug!),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text("Next Chapter"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    // Extract only the chapter number
    String chapterDisplay = '';

    // Try to extract number from chapterNumber first
    if (widget.chapterNumber != null && widget.chapterNumber!.isNotEmpty) {
      final match = RegExp(r'(\d+)').firstMatch(widget.chapterNumber!);
      if (match != null) {
        chapterDisplay = match.group(1)!;
      }
    }

    // If still empty, try from title
    if (chapterDisplay.isEmpty && _chapterData?.title != null) {
      final match = RegExp(r'(\d+)').firstMatch(_chapterData!.title);
      if (match != null) {
        chapterDisplay = match.group(1)!;
      }
    }

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      top: _isMenuVisible ? 0 : -120,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.only(
          top: 45,
          left: 12,
          right: 12,
          bottom: 15,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withOpacity(0.95), Colors.transparent],
          ),
        ),
        child: Row(
          children: [
            // Back Button
            _buildCircleButton(
              icon: Icons.arrow_back,
              onTap: () => Navigator.pop(context),
            ),

            const SizedBox(width: 8),

            // Chapter Indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Ch.$chapterDisplay',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),

            const Spacer(),

            // Previous Chapter Button
            _buildCircleButton(
              icon: Icons.chevron_left,
              iconColor: _chapterData?.prevSlug != null
                  ? Colors.white
                  : Colors.white38,
              onTap: () {
                if (_chapterData?.prevSlug != null) {
                  _navigateToChapter(_chapterData!.prevSlug!);
                }
              },
            ),

            const SizedBox(width: 8),

            // Next Chapter Button
            _buildCircleButton(
              icon: Icons.chevron_right,
              iconColor: _chapterData?.nextSlug != null
                  ? Colors.white
                  : Colors.white38,
              onTap: () {
                if (_chapterData?.nextSlug != null) {
                  _navigateToChapter(_chapterData!.nextSlug!);
                }
              },
            ),

            const SizedBox(width: 8),

            // Fullscreen Button
            _buildCircleButton(
              icon: Icons.fullscreen,
              onTap: _toggleFullscreen,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      bottom: _isMenuVisible ? 0 : -100,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.95), Colors.transparent],
          ),
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Page Indicator
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$_currentPage/$_totalPages',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),

              // Action Buttons
              Row(
                children: [
                  // Settings Button
                  _buildCircleButton(
                    icon: Icons.settings,
                    onTap: _showSettings,
                  ),

                  const SizedBox(width: 12),

                  // Favorite Button
                  _buildCircleButton(
                    icon: _isFavorite ? Icons.favorite : Icons.favorite_border,
                    iconColor: _isFavorite ? Colors.red : Colors.white,
                    onTap: _toggleFavorite,
                  ),

                  const SizedBox(width: 12),

                  // Autoplay Button
                  _buildCircleButton(
                    icon: _isAutoPlaying ? Icons.pause : Icons.play_arrow,
                    iconColor: _isAutoPlaying ? Colors.green : Colors.white,
                    onTap: _toggleAutoPlay,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black54,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white24, width: 1),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
    );
  }
}
