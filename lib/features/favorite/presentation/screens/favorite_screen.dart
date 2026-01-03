import 'package:flutter/material.dart';
import 'package:project_aplikasi_mobile/data/comic_data.dart';
import 'package:project_aplikasi_mobile/features/comics/presentation/screens/comic_detail_screen.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> comics = [
    {
      'title': 'One Piece',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/ujikomiko.appspot.com/o/gambar%2Fonepiece.webp?alt=media&token=ca5058c9-a288-4cf2-bb26-691ca1ad4746',
    },
    {
      'title': 'Naruto',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/ujikomiko.appspot.com/o/gambar%2Fnaruto.webp?alt=media&token=1b8f8485-5867-4831-9669-14d3d8d3bbd0',
    },
    {
      'title': 'Doraemon',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/ujikomiko.appspot.com/o/gambar%2Fdoraemon.webp?alt=media&token=164bdb2b-fdac-4f7a-a5c9-9eb880651e72',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildComicItem(Map<String, String> item) {
    return Column(
      children: [
        SizedBox(
          height: 110,
          child: Image.network(
            item['image']!,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          item['title']!,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: Colors.grey.shade600,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey.shade300,
          tabs: const [
            Tab(text: 'Comic'),
            Tab(text: 'Chapter'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Comic tab content
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: comics.map(_buildComicItem).toList()),
          ),
          // Chapter tab content (kosong atau bisa diisi sesuai kebutuhan)
          const Center(
              child: Text('Chapter tab content',
                  style: TextStyle(fontSize: 16, color: Colors.grey))),
        ],
      ),
    );
  }
}