import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:project_aplikasi_mobile/services/database_helper.dart';
import 'package:project_aplikasi_mobile/models/favorite_model.dart';
import 'package:project_aplikasi_mobile/models/chapter_bookmark_model.dart';
import 'package:project_aplikasi_mobile/features/comics/presentation/screens/comic_detail_loader.dart';
import 'package:project_aplikasi_mobile/features/comics/presentation/screens/read_comic_screen.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<FavoriteModel> _favorites = [];
  List<ChapterBookmarkModel> _chapterBookmarks = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Skip database on web
    if (kIsWeb) {
      setState(() {
        _favorites = [];
        _chapterBookmarks = [];
        _isLoading = false;
        _errorMessage =
            'Database tidak tersedia di web browser.\nGunakan Android/iOS untuk fitur lengkap.';
      });
      return;
    }

    try {
      final dbHelper = DatabaseHelper.instance;
      final favorites = await dbHelper.getAllFavorites();
      final bookmarks = await dbHelper.getAllChapterBookmarks();

      if (mounted) {
        setState(() {
          _favorites = favorites;
          _chapterBookmarks = bookmarks;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Gagal memuat data: $e';
          _favorites = [];
          _chapterBookmarks = [];
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildComicItem(FavoriteModel item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ComicDetailLoader(slug: item.comicId),
          ),
        ).then((_) => _loadData());
      },
      onLongPress: () {
        _showDeleteFavoriteDialog(item);
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: item.coverUrl,
              height: 110,
              width: 80,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 110,
                width: 80,
                color: Colors.grey[300],
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                height: 110,
                width: 80,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image),
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 80,
            child: Text(
              item.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          if (item.type != null)
            Text(
              item.type!,
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
        ],
      ),
    );
  }

  void _showDeleteFavoriteDialog(FavoriteModel item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Favorit'),
        content: Text('Hapus "${item.title}" dari favorit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              final dbHelper = DatabaseHelper.instance;
              await dbHelper.removeFavorite(item.comicId);
              Navigator.pop(context);
              _loadData();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Dihapus dari favorit')),
                );
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildChapterItem(ChapterBookmarkModel item) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.bookmark, color: Colors.blue),
      ),
      title: Text(
        item.chapterTitle ?? item.chapterNumber ?? 'Chapter',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        item.chapterNumber ?? '',
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, color: Colors.red),
        onPressed: () => _showDeleteChapterBookmarkDialog(item),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReadComicScreen(
              chapterSlug: item.chapterId,
              comicId: item.comicId,
              chapterNumber: item.chapterNumber,
            ),
          ),
        );
      },
    );
  }

  void _showDeleteChapterBookmarkDialog(ChapterBookmarkModel item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Bookmark'),
        content: Text(
          'Hapus "${item.chapterTitle ?? item.chapterNumber}" dari bookmark?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              final dbHelper = DatabaseHelper.instance;
              await dbHelper.removeChapterBookmark(item.chapterId);
              Navigator.pop(context);
              _loadData();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bookmark dihapus')),
                );
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Terjadi kesalahan',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            if (!kIsWeb) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadData,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: const Color(0xFF6453E9),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: 'Comic (${_favorites.length})'),
            Tab(text: 'Chapter (${_chapterBookmarks.length})'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? _buildErrorState()
          : TabBarView(
              controller: _tabController,
              children: [
                // Comic tab content
                _favorites.isEmpty
                    ? _buildEmptyState(
                        'Belum ada komik favorit\n\nTap ❤️ di halaman detail komik\nuntuk menambahkan',
                        Icons.favorite_border,
                      )
                    : RefreshIndicator(
                        onRefresh: _loadData,
                        child: GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 0.55,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                          itemCount: _favorites.length,
                          itemBuilder: (context, index) {
                            return _buildComicItem(_favorites[index]);
                          },
                        ),
                      ),
                // Chapter tab content
                _chapterBookmarks.isEmpty
                    ? _buildEmptyState(
                        'Belum ada chapter yang di-bookmark',
                        Icons.bookmark_border,
                      )
                    : RefreshIndicator(
                        onRefresh: _loadData,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: _chapterBookmarks.length,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 1),
                          itemBuilder: (context, index) {
                            return _buildChapterItem(_chapterBookmarks[index]);
                          },
                        ),
                      ),
              ],
            ),
    );
  }
}
