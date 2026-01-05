import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:project_aplikasi_mobile/components/navbar/navbar.dart';
import 'package:project_aplikasi_mobile/features/dashboard/presentation/screens/home_screen.dart';
import 'package:project_aplikasi_mobile/features/dashboard/presentation/widgets/history_card.dart';
import 'package:project_aplikasi_mobile/features/favorite/presentation/screens/favorite_screen.dart';
import 'package:project_aplikasi_mobile/features/profile/presentation/screens/profile_screen.dart';
import 'package:project_aplikasi_mobile/features/trending/presentation/screens/trending_screen.dart';
import 'package:project_aplikasi_mobile/features/comics/presentation/screens/read_comic_screen.dart';
import 'package:project_aplikasi_mobile/services/database_helper.dart';
import 'package:project_aplikasi_mobile/models/history_model.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int _selectedIndex = 0;

  late ScrollController _scrollController;
  late List<Widget> _widgetOptions;
  bool _isHistoryCardVisible = true;

  // History data
  HistoryModel? _lastHistory;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    _widgetOptions = <Widget>[
      HomeScreen(scrollController: _scrollController),
      TrendingPage(scrollController: _scrollController),
      const FavoritesPage(),
      const ProfilePage(),
    ];

    _loadLastHistory();
  }

  Future<void> _loadLastHistory() async {
    // Skip database on web
    if (kIsWeb) return;

    try {
      final dbHelper = DatabaseHelper.instance;
      final history = await dbHelper.getAllHistory();
      if (mounted && history.isNotEmpty) {
        setState(() {
          _lastHistory = history.first;
        });
      }
    } catch (e) {
      debugPrint('Error loading history: $e');
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final direction = _scrollController.position.userScrollDirection;
    if (direction == ScrollDirection.reverse) {
      if (_isHistoryCardVisible) {
        setState(() => _isHistoryCardVisible = false);
      }
    } else if (direction == ScrollDirection.forward) {
      if (!_isHistoryCardVisible) {
        setState(() => _isHistoryCardVisible = true);
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Refresh history saat kembali ke home atau trending
    if (index == 0 || index == 1) {
      _loadLastHistory();
    }
  }

  void _onHistoryCardTap() {
    if (_lastHistory != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReadComicScreen(
            chapterSlug: _lastHistory!.lastChapterId ?? '',
            comicId: _lastHistory!.comicId,
            comicTitle: _lastHistory!.title,
            coverUrl: _lastHistory!.coverUrl,
            chapterNumber: _lastHistory!.lastChapterNumber,
          ),
        ),
      ).then((_) => _loadLastHistory());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _widgetOptions.elementAt(_selectedIndex),

          // Hanya tampilkan HistoryCard di Home dan Trending, dan jika ada history
          if (_selectedIndex < 2 && _lastHistory != null)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              bottom: _isHistoryCardVisible ? 0 : -100,
              left: 0,
              right: 0,
              child: HistoryCard(
                imageUrl: _lastHistory!.coverUrl,
                title: _lastHistory!.title,
                chapter: _lastHistory!.lastChapterNumber ?? 'Lanjutkan membaca',
                onTap: _onHistoryCardTap,
              ),
            ),
        ],
      ),

      bottomNavigationBar: Navbar(
        currentIndex: _selectedIndex,
        onTabChange: _onItemTapped,
      ),
    );
  }
}
