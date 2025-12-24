import 'package:flutter/material.dart';
import 'package:project_aplikasi_mobile/api/comic_api.dart';
import 'package:project_aplikasi_mobile/models/list_comic.dart';
import '../widgets/carousel_view.dart';

class HomeScreen extends StatefulWidget {
  final ScrollController scrollController;
  const HomeScreen({super.key, required this.scrollController});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ComicApi _comicApi = ComicApi();

  late Future<ComicResponse> _recommendedComicsFuture;

  @override
  void initState() {
    super.initState();
    _recommendedComicsFuture = _comicApi.getComics('/recommen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: FutureBuilder<ComicResponse>(
        future: _recommendedComicsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final comics = snapshot.data?.comics ?? [];

          final slides = comics
              .map(
                (comic) => Image.network(
                  comic.coverUrl,
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
              .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (slides.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SimpleCarousel(height: 220, children: slides),
                ),
                const SizedBox(height: 12),
              ],
              Expanded(
                child: ListView.builder(
                  controller: widget.scrollController,
                  itemCount: comics.length,
                  itemBuilder: (context, index) {
                    final comic = comics[index];
                    return ListTile(
                      leading: Image.network(
                        comic.coverUrl,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 56,
                            height: 56,
                            color: Colors.grey[300],
                            child: const Icon(Icons.error),
                          );
                        },
                      ),
                      title: Text(comic.title),
                      subtitle: Text(comic.latestChapter),
                      onTap: () {},
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
