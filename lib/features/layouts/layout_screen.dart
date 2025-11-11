import 'package:flutter/material.dart';
import 'package:project_aplikasi_mobile/components/navbar/navbar.dart';
import 'package:project_aplikasi_mobile/features/dashboard/presentation/screens/home_screen.dart';
import 'package:project_aplikasi_mobile/features/favorite/presentation/screens/favorite_screen.dart';
import 'package:project_aplikasi_mobile/features/profile/presentation/screens/profile_screen.dart';
import 'package:project_aplikasi_mobile/features/trending/presentation/screens/trending_screen.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    TrendingPage(),
    FavoritesPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF1F1F1F),
        child: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      ),

      bottomNavigationBar: Navbar(
        currentIndex: _selectedIndex,
        onTabChange: _onItemTapped,
      ),
    );
  }
}
