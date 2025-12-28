import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quick_app/core/theme/app_theme.dart';
import 'package:quick_app/widgets/animated_scale_button.dart';
import '../models/qr_item.dart';

class QRCard extends StatelessWidget {
  final QRItem qr;
  final VoidCallback onTap;


  const QRCard({
    super.key,
    required this.qr,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    final iconPath = qr.getType!.icon ?? "assets/svg/default.svg";

    return AnimatedScaleButton(
      onPressed: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.darkest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SvgPicture.asset(
                  width: 24,
                  height: 24,
                  iconPath,
                  fit: BoxFit.cover,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              Text(
                qr.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1,
                  color: Colors.white
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}