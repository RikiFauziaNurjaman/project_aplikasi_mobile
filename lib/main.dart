import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:project_aplikasi_mobile/features/auth/presentaion/screens/splash_screen_comic.dart';
import 'package:project_aplikasi_mobile/features/auth/presentaion/screens/login_screen_comic.dart';
import 'package:project_aplikasi_mobile/features/auth/presentaion/screens/register_screen_comic.dart';
import 'package:project_aplikasi_mobile/features/layouts/layout_screen.dart';

// Conditional import for database initialization
import 'package:project_aplikasi_mobile/services/database_init_stub.dart'
    if (dart.library.io) 'package:project_aplikasi_mobile/services/database_init_native.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database for desktop platforms (not web)
  await initializeDatabase();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'COMICU',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      // Start with SplashScreen yang akan cek login status
      home: const SplashScreenComic(),

      // Named routes untuk navigasi
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const LayoutScreen(),
      },
    );
  }
}
