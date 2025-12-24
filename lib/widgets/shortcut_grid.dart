import 'package:flutter/material.dart';
import '../models/shortcut_item.dart';
import 'shortcut_card.dart';

class ShortcutGrid extends StatelessWidget {
  final List<ShortcutItem> shortcuts;
  final Function(ShortcutItem) onShortcutTap;

  const ShortcutGrid({
    super.key,
    required this.shortcuts,
    required this.onShortcutTap,
  });

  @override
  Widget build(BuildContext context) {
    if (shortcuts.isEmpty) {
      return const SizedBox.shrink();
    }

    // Responsive cross axis count
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = 4; // 4 cho tablet, 2 cho phone
    
    final itemCount = shortcuts.length;
    final rowCount = (itemCount / crossAxisCount).ceil();
    
    // Tính chiều cao dựa trên childAspectRatio và spacing
    final itemWidth = (screenWidth - 40 - (crossAxisCount - 1) * 24) / crossAxisCount;
    final itemHeight = itemWidth / 0.76;
    final gridHeight = rowCount * itemHeight + (rowCount - 1) * 24;
    
    return SizedBox(
      height: gridHeight,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 24,
          crossAxisSpacing: 24,
          childAspectRatio: 0.76,
        ),
        itemCount: shortcuts.length,
        itemBuilder: (context, index) {
          return ShortcutCard(
            shortcut: shortcuts[index],
            onTap: () => onShortcutTap(shortcuts[index]),
          );
        },
      ),
    );
  }
}