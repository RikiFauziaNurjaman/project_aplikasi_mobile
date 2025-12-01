import 'dart:async';

import 'package:flutter/material.dart';

class SimpleCarousel extends StatefulWidget {
  final List<Widget> children;
  final double height;
  final Duration autoPlayInterval;

  const SimpleCarousel({
    Key? key,
    required this.children,
    this.height = 200,
    this.autoPlayInterval = const Duration(seconds: 4),
  }) : super(key: key);

  @override
  State<SimpleCarousel> createState() => _SimpleCarouselState();
}

class _SimpleCarouselState extends State<SimpleCarousel> {
  late final PageController _controller;
  int _current = 0;
  Timer? _timer;

  void _startTimer() {
    _timer?.cancel();
    if (widget.children.length <= 1) return;
    _timer = Timer.periodic(widget.autoPlayInterval, (_) {
      if (!mounted) return;
      final next = _current - 1 < 0 ? widget.children.length - 1 : _current - 1;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.children.isEmpty) {
      return SizedBox(height: widget.height, child: const Center(child: Text('No slides')));
    }

    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: GestureDetector(
            onPanDown: (_) => _stopTimer(),
            onPanCancel: () => _startTimer(),
            onPanEnd: (_) => _startTimer(),
            child: PageView.builder(
              reverse: true,
              controller: _controller,
              itemCount: widget.children.length,
              onPageChanged: (index) => setState(() => _current = index),
              itemBuilder: (context, index) => ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox.expand(child: widget.children[index]),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (widget.children.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.children.length, (i) {
              final selected = i == _current;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: selected ? 16 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: selected ? Theme.of(context).primaryColor : Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            }),
          ),
      ],
    );
  }
}
