import 'package:flutter/material.dart';
import 'package:project_aplikasi_mobile/api/comic_api.dart';
import 'package:project_aplikasi_mobile/features/trending/presentation/widgets/comic_list_item.dart';
import 'package:project_aplikasi_mobile/components/searchbar/searchbar.dart'
    as CustomSearchBar;
import 'package:project_aplikasi_mobile/models/list_comic.dart';
import 'package:project_aplikasi_mobile/features/dashboard/presentation/screens/search_results_screen.dart';

class TrendingPage extends StatefulWidget {
  final ScrollController scrollController;
  const TrendingPage({super.key, required this.scrollController});

  @override
  State<TrendingPage> createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  final ComicApi _comicApi = ComicApi();
  late Future<ComicResponse> _trendingFuture;

  @override
  void initState() {
    super.initState();

    _trendingFuture = _comicApi.getComics('/top');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSearchBar.SearchBar(
              onSubmitted: (query) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SearchResultsScreen(initialQuery: query),
                  ),
                );
              },
            ),

            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                '#Trending Top 10',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            Expanded(
              child: FutureBuilder<ComicResponse>(
                future: _trendingFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData ||
                      snapshot.data!.comics.isEmpty) {
                    return const Center(child: Text("Data trending kosong"));
                  }

                  final comics = snapshot.data!.comics;

                  return ListView.builder(
                    controller: widget.scrollController,
                    itemCount: comics.length,
                    padding: const EdgeInsets.only(bottom: 20),
                    itemBuilder: (context, index) {
                      final comic = comics[index];

                      return ComicListItem(comic: comic, rank: index + 1);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
