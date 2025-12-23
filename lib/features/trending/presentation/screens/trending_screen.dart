import 'package:flutter/material.dart';
import 'package:project_aplikasi_mobile/data/comic_data.dart';
import 'package:project_aplikasi_mobile/features/trending/presentation/widgets/comic_list_item.dart';

class TrendingPage extends StatelessWidget {
  const TrendingPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                '#Trending',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: listComic.length,
                itemBuilder: (context, index) {
                  final comic = listComic[index];
                  return ComicListItem(comic: comic, rank: index + 1);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
