import 'package:flutter/material.dart';

class ComicHeader extends StatelessWidget {
  const ComicHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 126, 115, 255),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              "Chapters",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFBDB2B1),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Masukan Chapter',
                      hintStyle: const TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const Icon(Icons.search, color: Colors.white, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
