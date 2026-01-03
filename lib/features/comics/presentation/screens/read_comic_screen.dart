import 'package:flutter/material.dart';
import 'package:project_aplikasi_mobile/api/comic_api.dart';
import 'package:project_aplikasi_mobile/models/read_chapter.dart';

class ReadComicScreen extends StatefulWidget {
  final String chapterSlug; // Kita butuh Slug, bukan object Chapter full

  const ReadComicScreen({super.key, required this.chapterSlug});

  @override
  State<ReadComicScreen> createState() => _ReadComicScreenState();
}

class _ReadComicScreenState extends State<ReadComicScreen> {
  final ComicApi _api = ComicApi();

  // Variable State
  bool _isMenuVisible = true;
  bool _isLoading = true;
  int _currentIndex = 0; // Menggantikan _currentPage
  ReadChapterModel? _chapterData;

  @override
  void initState() {
    super.initState();
    _fetchChapterData(widget.chapterSlug);
  }

  // Fungsi ambil data
  void _fetchChapterData(String slug) async {
    setState(() => _isLoading = true);
    final data = await _api.getChapterImages(slug);

    if (mounted) {
      setState(() {
        _chapterData = data;
        _isLoading = false;
        _currentIndex = 0; // Reset halaman saat load chapter baru
      });
    }
  }

  void _toggleMenu() {
    setState(() {
      _isMenuVisible = !_isMenuVisible;
    });
  }

  // Fungsi Navigasi Ganti Chapter
  void _navigateToChapter(String slug) {
    // Kita replace halaman ini dengan halaman baru agar tidak menumpuk di stack
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ReadComicScreen(chapterSlug: slug),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _chapterData == null
          ? const Center(
              child: Text(
                "Gagal memuat chapter",
                style: TextStyle(color: Colors.white),
              ),
            )
          : GestureDetector(
              onTap: _toggleMenu,
              child: Stack(
                children: [
                  // --- LAPISAN 1: LIST GAMBAR ---
                  InteractiveViewer(
                    minScale: 1.0,
                    maxScale: 3.0,
                    child: ListView.builder(
                      // Tambah +1 item di bawah untuk tombol Next/Prev
                      itemCount: _chapterData!.images.length + 1,
                      itemBuilder: (context, index) {
                        // A. Bagian Tombol Navigasi Bawah (Item Terakhir)
                        if (index == _chapterData!.images.length) {
                          return _buildBottomNavigation();
                        }

                        // B. Bagian Gambar Komik
                        return VisibilityDetector(
                          index: index,
                          child: Image.network(
                            'https://images.weserv.nl/?url=${Uri.encodeComponent(_chapterData!.images[index])}&output=webp',
                            fit: BoxFit.fitWidth,
                            width: double.infinity,
                            // Loading Builder (saat gambar sedang di-download)
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: 300,
                                color: Colors.grey[900],
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white24,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 200,
                                color: Colors.grey[900],
                                child: const Icon(
                                  Icons.broken_image,
                                  color: Colors.white54,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  _buildHeader(),

                  _buildPageIndicator(),
                ],
              ),
            ),
    );
  }

  Widget VisibilityDetector({required int index, required Widget child}) {
    return Builder(
      builder: (context) {
        return child;
      },
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      color: Colors.black,
      child: Column(
        children: [
          const Text(
            "Chapter Selesai",
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Tombol PREV
              if (_chapterData!.prevSlug != null)
                ElevatedButton.icon(
                  onPressed: () => _navigateToChapter(_chapterData!.prevSlug!),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Previous"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                  ),
                ),

              // Tombol NEXT
              if (_chapterData!.nextSlug != null)
                ElevatedButton.icon(
                  onPressed: () => _navigateToChapter(_chapterData!.nextSlug!),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text("Next Chapter"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 50), // Ruang kosong bawah
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      top: _isMenuVisible ? 0 : -100, // Efek slide up/down
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.only(
          top: 40,
          left: 16,
          right: 16,
          bottom: 20,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withOpacity(0.9), Colors.transparent],
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _chapterData?.title ?? "Loading...",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    if (_chapterData == null) return const SizedBox();

    return Positioned(
      bottom: 30,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: _isMenuVisible ? 1.0 : 0.0,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(20),
            ),
            // Menampilkan jumlah total gambar
            child: Text(
              "${_chapterData!.images.length} Pages",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
