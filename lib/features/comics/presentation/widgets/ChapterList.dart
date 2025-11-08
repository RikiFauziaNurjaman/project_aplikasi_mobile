import 'package:flutter/material.dart';
import 'package:project_aplikasi_mobile/models/chapter_comic.dart';

class ChapterList extends StatelessWidget {
  final List<Chapter> chapters;

  const ChapterList({super.key, required this.chapters});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        final chapter = chapters[index];

        // Ambil gambar pertama dari list sebagai thumbnail
        // Pastikan list tidak kosong sebelum mengambil index [0]
        final String thumbnailUrl = chapter.imageUrls.isNotEmpty
            ? chapter.imageUrls[0]
            : 'images/placeholder.png'; // Sediakan gambar placeholder lokal jika kosong

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                // Ganti Image.network menjadi Image.asset
                child: Image.asset(
                  thumbnailUrl, // Gunakan path gambar lokal
                  width: 100,
                  height: 70,
                  fit: BoxFit.cover,
                  // Tambahkan errorBuilder untuk menangani jika asset tidak ditemukan
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 100,
                      height: 70,
                      color: Colors.grey[800],
                      child: Icon(Icons.broken_image, color: Colors.grey[600]),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // Gunakan title dari data chapter yang benar
                      chapter.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.visibility,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          chapter.viewCount,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }, childCount: chapters.length),
    );
  }
}
