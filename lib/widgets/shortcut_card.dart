import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quick_app/services/type_service.dart';
import '../models/shortcut_item.dart';

class ShortcutCard extends StatelessWidget {
  final ShortcutItem shortcut;
  final VoidCallback onTap;


  const ShortcutCard({
    super.key,
    required this.shortcut,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    final type = TypeService.getTypeById(shortcut.typeId);
    final iconPath = type.icon ?? "assets/svg/default.svg";

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xff1E293B),
                borderRadius: BorderRadius.circular(16),
              ),
              child: SizedBox(
                child: Center(
                  child: SvgPicture.asset(
                    width: 30,
                    height: 30,
                    iconPath,
                    fit: BoxFit.cover,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              )
            ),
          ),
          Text(
            shortcut.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}