import 'package:flutter/material.dart';
import 'package:project_aplikasi_mobile/api/comic_api.dart';
import 'package:project_aplikasi_mobile/models/list_comic.dart';
import 'package:project_aplikasi_mobile/features/comics/presentation/screens/comic_detail_loader.dart';
import '../widgets/comic_card.dart';

class AllComicsScreen extends StatefulWidget {
  final String title;
  final String endpoint;

  const AllComicsScreen({
    super.key,
    required this.title,
    required this.endpoint,
  });

  @override
  State<AllComicsScreen> createState() => _AllComicsScreenState();
}

class _AllComicsScreenState extends State<AllComicsScreen> {
  final ComicApi _comicApi = ComicApi();
  final ScrollController _scrollController = ScrollController();

  List<Comic> _comics = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _currentPage = 1;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadComics();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && _hasMore) {
        _loadMoreComics();
      }
    }
  }

  Future<void> _loadComics() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _comicApi.getComics(widget.endpoint, page: 1);
      setState(() {
        _comics = response.comics;
        _hasMore = response.pagination.hasNextPage;
        _currentPage = 1;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreComics() async {
    if (_isLoadingMore) return;

    setState(() => _isLoadingMore = true);

    try {
      final response = await _comicApi.getComics(
        widget.endpoint,
        page: _currentPage + 1,
      );
      setState(() {
        _comics.addAll(response.comics);
        _hasMore = response.pagination.hasNextPage;
        _currentPage++;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() => _isLoadingMore = false);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), elevation: 0),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $_error'),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadComics, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_comics.isEmpty) {
      return const Center(child: Text('Tidak ada komik ditemukan'));
    }

    return RefreshIndicator(
      onRefresh: _loadComics,
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.55,
          crossAxisSpacing: 12,
          mainAxisSpacing: 16,
        ),
        itemCount: _comics.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _comics.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
          }

          return ComicCard(
            comic: _comics[index],
            onTap: () => _navigateToDetail(_comics[index]),
          );
        },
      ),
    );
  }
}
