import 'package:flutter/material.dart';

class GradientIcon extends StatelessWidget {
  final List<Color> gradientColors;
  final double size;
  final IconData? icon;

  const GradientIcon({
    super.key,
    required this.gradientColors,
    required this.size,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: icon != null
          ? Icon(
              icon,
              color: Colors.white,
              size: size * 0.5,
            )
          : null,
    );
  }
}