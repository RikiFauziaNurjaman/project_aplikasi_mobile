import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_aplikasi_mobile/services/auth_preferences.dart';
import 'package:project_aplikasi_mobile/features/layouts/layout_screen.dart';
import 'login_screen_comic.dart';

class SplashScreenComic extends StatefulWidget {
  const SplashScreenComic({Key? key}) : super(key: key);

  @override
  State<SplashScreenComic> createState() => _SplashScreenComicState();
}

class _SplashScreenComicState extends State<SplashScreenComic> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // 1 second duration
    _timer = Timer(const Duration(seconds: 1), _onTimerComplete);
  }

  void _onTimerComplete() async {
    // Cek apakah user sudah login
    final isLoggedIn = await AuthPreferences.isLoggedIn();

    if (!mounted) return;

    if (isLoggedIn) {
      // Jika sudah login, langsung ke LayoutScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LayoutScreen()),
      );
    } else {
      // Jika belum login, ke LoginScreen
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'images/auth/logo.png',
              width: 500,
              height: 250,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            const Text(
              'COMICU',
              style: TextStyle(
                fontFamily: 'Fredoka',
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Platform Pembaca Komik Digital",
              style: TextStyle(
                fontFamily: 'Fredoka',
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
