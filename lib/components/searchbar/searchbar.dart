import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final ValueChanged<String>? onSubmitted;

  const SearchBar({super.key, this.onSubmitted});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearch() {
    if (_controller.text.trim().isNotEmpty) {
      widget.onSubmitted?.call(_controller.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF5B9EFF),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Cari berdasarkan judul dan penulis',
                  filled: true,
                  fillColor: Colors.white,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                    vertical: 12.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    widget.onSubmitted?.call(value.trim());
                  }
                },
              ),
            ),
            const SizedBox(width: 8.0),
            IconButton(
              icon: const Icon(Icons.search),
              iconSize: 28.0,
              color: Colors.white,
              onPressed: _onSearch,
            ),
          ],
        ),
      ),
    );
  }
}
