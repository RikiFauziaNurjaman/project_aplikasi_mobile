import 'package:flutter/material.dart';

class ChapterFilter extends StatefulWidget {
  const ChapterFilter({super.key});

  @override
  State<ChapterFilter> createState() => _ChapterFilterState();
}

class _ChapterFilterState extends State<ChapterFilter> {
  final List<String> _filters = [
    '1-30',
    '31-60',
    '61-90',
    '91-120',
    '121-150',
    '151-180',
    '181-210',
  ];
  int _selectedFilterIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(_filters[index]),
              labelStyle: TextStyle(
                color: _selectedFilterIndex == index
                    ? Colors.white
                    : Colors.black,
              ),
              selected: _selectedFilterIndex == index,
              onSelected: (bool selected) {
                setState(() {
                  _selectedFilterIndex = selected ? index : 0;
                });
              },
              backgroundColor: Colors.grey[800],
              selectedColor: Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: const BorderSide(color: Colors.transparent),
              ),
            ),
          );
        },
      ),
    );
  }
}
