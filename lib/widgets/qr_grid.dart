import 'package:flutter/material.dart';
import '../models/qr_item.dart';
import 'qr_card.dart';

class QRGrid extends StatelessWidget {
  final List<QRItem> qrs;
  final Function(QRItem) onTap;

  const QRGrid({
    super.key,
    required this.qrs,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (qrs.isEmpty) {
      return const SizedBox.shrink();
    }

    // Responsive cross axis count
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = 4; // 4 cho tablet, 2 cho phone
    
    final itemCount = qrs.length;
    final rowCount = (itemCount / crossAxisCount).ceil();
    
    // Tính chiều cao dựa trên childAspectRatio và spacing
    final itemWidth = (screenWidth - 40 - (crossAxisCount - 1) * 12) / crossAxisCount;
    final itemHeight = itemWidth / 1;
    final gridHeight = rowCount * itemHeight + (rowCount - 1) * 12;
    
    return SizedBox(
      height: gridHeight,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1,
        ),
        itemCount: qrs.length,
        itemBuilder: (context, index) {
          return QRCard(
            qr: qrs[index],
            onTap: () => onTap(qrs[index]),
          );
        },
      ),
    );
  }
}