import 'package:flutter/material.dart';
import 'package:project_aplikasi_mobile/models/detail_comic.dart';

class ComicInfo extends StatelessWidget {
  final ComicDetail comic;

  const ComicInfo({super.key, required this.comic});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  comic.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _buildRatingStars(comic.rating),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              _buildInfoRow(Icons.person, comic.author),
              const SizedBox(width: 20),

              _buildInfoRow(Icons.remove_red_eye, comic.readerCount),
            ],
          ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: comic.genres.take(3).map((genre) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  genre.title,
                  style: TextStyle(fontSize: 10, color: Colors.grey[800]),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 12),

          Text(
            comic.synopsis,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[700]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRatingStars(double rating) {
    List<Widget> stars = [];

    double iconSize = 20.0;

    for (int i = 0; i < 5; i++) {
      IconData icon = Icons.star_border;
      if (i < rating) {
        icon = Icons.star;
      } else if (i < rating + 0.5) {
        icon = Icons.star_half;
      }
      stars.add(Icon(icon, color: Colors.amber, size: iconSize));
    }
    return Row(children: stars);
  }
}
