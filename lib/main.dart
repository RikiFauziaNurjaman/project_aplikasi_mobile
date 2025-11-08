import 'package:flutter/material.dart';
import 'package:project_aplikasi_mobile/data/comic_data.dart';
// import 'package:project_aplikasi_mobile/features/auth/presentaion/screens/splash_screen_comic.dart';
import 'package:project_aplikasi_mobile/features/comics/presentation/screens/comic_detail_screen.dart';

void main() {
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
      // home: const SplashScreenComic(),
      home: ComicDetailScreen(comic: listComic[0]),
    );
  }
}
