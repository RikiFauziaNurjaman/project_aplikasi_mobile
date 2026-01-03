import 'package:flutter/material.dart';

class ChapterFilter extends StatelessWidget {
  final List<String> ranges;
  final int selectedIndex;
  final Function(int) onFilterSelected;

  const ChapterFilter({
    super.key,
    required this.ranges,
    required this.selectedIndex,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (ranges.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: ranges.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final bool isSelected = selectedIndex == index;

          return ChoiceChip(
            label: Text(
              ranges[index],
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            selected: isSelected,
            onSelected: (bool selected) {
              if (selected) {
                onFilterSelected(index);
              }
            },

            backgroundColor: Colors.grey[200],
            selectedColor: const Color.fromARGB(255, 126, 115, 255),
            showCheckmark: false,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(
                color: isSelected ? Colors.transparent : Colors.grey.shade300,
              ),
            ),
          );
        },
      ),
    );
  }
}
