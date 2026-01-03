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

  Widget _buildComicCard(Comic comic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            comic.coverUrl,
            height: 140,
            width: 100,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 100,
          child: Text(
            comic.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<Comic> comics) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: Navigate to view all
                },
                child: const Text(
                  'view all',
                  style: TextStyle(color: Colors.blue, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: comics.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _buildComicCard(comics[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final slides = _listHome
        .map((comic) => Image.asset(
              comic.coverUrl,
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.fill,
            ))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: SimpleCarousel(
                height: 200,
                children: slides,
              ),
            ),
            _buildSection('For you', _listHome.sublist(0, (_listHome.length ~/ 2).clamp(0, _listHome.length))),
            const SizedBox(height: 12),
            _buildSection('Hot news', _listHome.sublist((_listHome.length ~/ 2).clamp(0, _listHome.length))),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}