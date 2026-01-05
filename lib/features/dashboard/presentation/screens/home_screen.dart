import 'package:flutter/material.dart';
import 'package:project_aplikasi_mobile/api/comic_api.dart';
import 'package:project_aplikasi_mobile/models/list_comic.dart';
import 'package:project_aplikasi_mobile/models/history_model.dart';
import 'package:project_aplikasi_mobile/services/database_helper.dart';
import 'package:project_aplikasi_mobile/features/comics/presentation/screens/comic_detail_loader.dart';
import 'package:project_aplikasi_mobile/features/comics/presentation/screens/read_comic_screen.dart';
import '../widgets/carousel_view.dart';
import '../widgets/comic_card.dart';
import '../widgets/section_header.dart';
import '../widgets/history_card.dart';
import 'all_comics_screen.dart';
import 'search_results_screen.dart';

class HomeScreen extends StatefulWidget {
  final ScrollController scrollController;
  const HomeScreen({super.key, required this.scrollController});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ComicApi _comicApi = ComicApi();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  late Future<ComicResponse> _latestComicsFuture;
  late Future<ComicResponse> _topComicsFuture;
  HistoryModel? _lastRead;

  @override
  void initState() {
    super.initState();
    _latestComicsFuture = _comicApi.getComics('/latest');
    _topComicsFuture = _comicApi.getComics('/top');
    _loadLastRead();
  }

  Future<void> _loadLastRead() async {
    try {
      final history = await _dbHelper.getAllHistory();
      if (history.isNotEmpty && mounted) {
        setState(() => _lastRead = history.first);
      }
    } catch (e) {
      // Ignore errors - just don't show continue reading
    }
  }

  void _navigateToDetail(Comic comic) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComicDetailLoader(slug: comic.slug),
      ),
    );
  }

  void _continueReading() {
    if (_lastRead != null && _lastRead!.lastChapterId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ReadComicScreen(chapterSlug: _lastRead!.lastChapterId!),
        ),
      );
    }
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SearchResultsScreen(initialQuery: ''),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.grey[600]),
            const SizedBox(width: 12),
            Text(
              'Cari berdasarkan judul dan penulis',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselSection(List<Comic> comics) {
    final carouselComics = comics.take(5).toList();

    final slides = carouselComics.map((comic) {
      return GestureDetector(
        onTap: () => _navigateToDetail(comic),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              comic.coverUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 50),
                );
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                  ),
                ),
                child: Text(
                  comic.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();

    if (slides.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SimpleCarousel(height: 180, children: slides),
    );
  }

  Widget _buildHorizontalComicList(List<Comic> comics) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: comics.length > 10 ? 10 : comics.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ComicCard(
              comic: comics[index],
              onTap: () => _navigateToDetail(comics[index]),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<ComicResponse>>(
          future: Future.wait([_latestComicsFuture, _topComicsFuture]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text('Error: ${snapshot.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _latestComicsFuture = _comicApi.getComics('/latest');
                          _topComicsFuture = _comicApi.getComics('/top');
                        });
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final latestComics = snapshot.data?[0].comics ?? [];
            final topComics = snapshot.data?[1].comics ?? [];

            return SingleChildScrollView(
              controller: widget.scrollController,
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(),

                  _buildCarouselSection(latestComics),
                  const SizedBox(height: 16),

                  SectionHeader(
                    title: 'For you',
                    onViewAll: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllComicsScreen(
                            title: 'For You',
                            endpoint: '/latest',
                          ),
                        ),
                      );
                    },
                  ),
                  _buildHorizontalComicList(latestComics),
                  const SizedBox(height: 8),

                  SectionHeader(
                    title: 'Hot news',
                    onViewAll: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllComicsScreen(
                            title: 'Hot News',
                            endpoint: '/top',
                          ),
                        ),
                      );
                    },
                  ),
                  _buildHorizontalComicList(topComics),

                  if (_lastRead != null) ...[
                    const SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Continue Reading',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    HistoryCard(
                      imageUrl: _lastRead!.coverUrl,
                      title: _lastRead!.title,
                      chapter: _lastRead!.lastChapterNumber ?? 'Continue',
                      onTap: _continueReading,
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
