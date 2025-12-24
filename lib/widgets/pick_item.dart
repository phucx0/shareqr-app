import 'package:flutter/material.dart';

class PickItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const PickItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: onTap,
    );
  }
}