import 'package:flutter/material.dart';
import 'package:project_aplikasi_mobile/data/comic_data.dart';
import 'package:project_aplikasi_mobile/features/comics/presentation/screens/comic_detail_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),

        onPressed: () {
          final testComic = listComic[0];

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ComicDetailScreen(comic: testComic),
            ),
          );
        },
        // ------------------------------
        child: const Text('Buka Detail Komik'),
      ),
    );
  }
}
