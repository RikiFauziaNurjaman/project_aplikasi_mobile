import 'package:flutter/material.dart';
import 'package:project_aplikasi_mobile/models/list_comic.dart';

class ComicInfo extends StatelessWidget {
  final Comic comic;
  const ComicInfo({super.key, required this.comic});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                comic.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const Spacer(),
              _buildRatingStars(comic.rating),
            ],
          ),

          const SizedBox(height: 8),

          _buildInfoRow(Icons.person, comic.author),
          const SizedBox(width: 25),
          _buildInfoRow(Icons.visibility, comic.viewCount),

          const SizedBox(height: 16),

          Text(
            comic.description,
            style: const TextStyle(fontSize: 16, color: Colors.black),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color.fromARGB(255, 0, 0, 0)),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingStars(double rating) {
    List<Widget> stars = [];
    for (int i = 0; i < 5; i++) {
      IconData icon = Icons.star_border;
      if (i < rating) {
        icon = Icons.star;
      } else if (i < rating + 0.5) {
        icon = Icons.star_half;
      }
      stars.add(Icon(icon, color: Colors.yellow[700], size: 30));
    }
    return Row(children: stars);
  }
}
