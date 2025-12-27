import 'package:flutter/material.dart';

class AnimatedFab extends StatefulWidget {
  final VoidCallback onPressed;
  final Icon icon;
  const AnimatedFab({
    super.key, 
    required this.onPressed,
    required this.icon
  });

  @override
  State<AnimatedFab> createState() => _AnimatedFabState();
}

class _AnimatedFabState extends State<AnimatedFab>
    with SingleTickerProviderStateMixin {

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.9,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _controller,
      child: FloatingActionButton(
        shape: const CircleBorder(),
        elevation: 0,
        onPressed: () async {
          await _controller.reverse();
          await _controller.forward();
          widget.onPressed();
        },
        child: widget.icon
      ),
    );
  }
}
