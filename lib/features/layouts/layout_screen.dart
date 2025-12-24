import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:project_aplikasi_mobile/components/navbar/navbar.dart';
import 'package:project_aplikasi_mobile/features/dashboard/presentation/screens/home_screen.dart';
import 'package:project_aplikasi_mobile/features/dashboard/presentation/widgets/history_card.dart';
// import 'package:project_aplikasi_mobile/features/dashboard/presentation/widgets/history_card.dart';
// import 'package:project_aplikasi_mobile/features/favorite/presentation/screens/favorite_screen.dart';
// import 'package:project_aplikasi_mobile/features/profile/presentation/screens/profile_screen.dart';
import 'package:project_aplikasi_mobile/features/trending/presentation/screens/trending_screen.dart';

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

  @override
  void initState() {
    super.initState();
    // 1. Buat ScrollController
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    _widgetOptions = <Widget>[
      HomeScreen(scrollController: _scrollController),
      TrendingPage(scrollController: _scrollController),
      // FavoritesPage(
      //   scrollController: _scrollController,
      // ), // Asumsi FavoritesPage juga bisa di-scroll
      // ProfilePage(
      //   scrollController: _scrollController,
      // ), // Asumsi ProfilePage juga bisa di-scroll
    ];
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _widgetOptions.elementAt(_selectedIndex),

          if (_selectedIndex != 3)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              bottom: _isHistoryCardVisible ? 0 : -100,
              left: 0,
              right: 0,
              child: HistoryCard(
                imageUrl: "",
                title: "",
                chapter: "Ch. 143",
                onTap: () {
                  /* Navigasi ke halaman baca */
                },
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
