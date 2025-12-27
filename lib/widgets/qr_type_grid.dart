import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quick_app/models/qr_enum.dart';
import 'package:quick_app/models/qr_type.dart';
import 'package:quick_app/widgets/animated_scale_button.dart';

class QrTypeGrid extends StatelessWidget {
  final List<QrTypeModel> QRTypes;
  final void Function(int index) onTap;
  final QrType selectedType;
  const QrTypeGrid({
    super.key,
    required this.QRTypes,
    required this.onTap,
    required this.selectedType
  });

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = 4;
    double spacing = 12;
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          itemCount: QRTypes.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            bool isSelected = selectedType == QRTypes[index].type;
            return AnimatedScaleButton(
              onPressed: () => onTap(index),
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? Theme.of(context).primaryColor : const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      width: 1,
                      color: isSelected ? Theme.of(context).focusColor : Theme.of(context).colorScheme.onSecondary,
                    )
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: SvgPicture.asset(
                          width: 24,
                          height: 24,
                          QRTypes[index].icon!,
                          fit: BoxFit.cover,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        QRTypes[index].getName(context),
                        maxLines: 2,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )  
              ),
            );
          }
        );
      }
    );
  }
}