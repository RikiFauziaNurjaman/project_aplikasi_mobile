import 'package:flutter/material.dart';
import 'package:project_aplikasi_mobile/data/comic_data.dart';
import 'package:project_aplikasi_mobile/models/list_comic.dart';
import '../widgets/carousel_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Comic> _listHome = listComic;

  @override
  Widget build(BuildContext context) {
    final slides = _listHome
        .map((comic) => Image.asset(
              comic.coverUrl,
              height: double.infinity,
              width: double.infinity,
            ))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SimpleCarousel(
                height: 220,
                children: slides,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _listHome.length,
                itemBuilder: (context, index) {
                  final comic = _listHome[index];
                  return ListTile(
                    leading: Image.asset(comic.coverUrl, width: 56, fit: BoxFit.cover),
                    title: Text(comic.title),
                    subtitle: Text('by ${comic.author}'),
                  );
                },
              ),
            ),
          ],
        ),
    );
  }
}