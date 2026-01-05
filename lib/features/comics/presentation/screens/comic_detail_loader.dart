import 'package:flutter/material.dart';
import 'package:project_aplikasi_mobile/api/comic_api.dart';
import 'package:project_aplikasi_mobile/models/detail_comic.dart';
import 'comic_detail_screen.dart';

class ComicDetailLoader extends StatefulWidget {
  final String slug;

  const ComicDetailLoader({super.key, required this.slug});

  @override
  State<ComicDetailLoader> createState() => _ComicDetailLoaderState();
}

class _ComicDetailLoaderState extends State<ComicDetailLoader> {
  final ComicApi _api = ComicApi();
  late Future<ComicDetail?> _detailFuture;

  @override
  void initState() {
    super.initState();
    _detailFuture = _api.getComicDetail(widget.slug);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ComicDetail?>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Detail komik tidak ditemukan"));
          } else {
            return ComicDetailScreen(
              comic: snapshot.data!,
              comicSlug: widget.slug,
            );
          }
        },
      ),
    );
  }
}
