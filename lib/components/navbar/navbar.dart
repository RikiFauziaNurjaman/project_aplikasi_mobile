import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Navbar extends StatelessWidget {
  final int currentIndex;

  final Function(int) onTabChange;

  const Navbar({
    super.key,
    required this.currentIndex,
    required this.onTabChange,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 100, 83, 233),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: GNav(
          backgroundColor: const Color.fromARGB(255, 100, 83, 233),
          color: Colors.white,
          activeColor: Colors.white,
          tabBackgroundColor: const Color.fromARGB(255, 65, 47, 124),
          gap: 8,
          padding: const EdgeInsets.all(16),

          selectedIndex: currentIndex,
          onTabChange: onTabChange,

          tabs: const [
            GButton(icon: Icons.home, text: 'Home'),
            GButton(icon: Icons.local_fire_department, text: 'Trending'),
            GButton(icon: Icons.star, text: 'Favorites'),
            GButton(icon: Icons.person, text: 'Profile'),
          ],
        ),
      ),
    );
  }
}
