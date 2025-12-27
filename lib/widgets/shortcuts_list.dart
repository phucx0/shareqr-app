import 'package:flutter/material.dart';
import 'package:quick_app/constants/system_app_icons.dart';
import 'package:quick_app/l10n/l10n.dart';
import 'package:quick_app/services/type_service.dart';
import '../models/shortcut_item.dart';

// Widget tách riêng cho từng item trong list
class ShortcutListItem extends StatelessWidget {
  final ShortcutItem shortcut;
  final VoidCallback? onToggleVisibility;

  const ShortcutListItem({
    super.key,
    required this.shortcut,
    this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    final type = TypeService.getTypeById(shortcut.typeId);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          // color: shortcut.typeBadgeColor.withOpacity(0.2),
          width: 2
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            systemAppIcons[shortcut.appKey] ?? "assets/icon/icon.png",
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Row(
          children: [
            Text(
              shortcut.title,
              style: TextStyle(
                color: shortcut.isVisible ? Colors.white : Colors.white38,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                // color: shortcut.typeBadgeColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                type.name,
                style: TextStyle(
                  // color: shortcut.typeBadgeColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        subtitle: Text(
          shortcut.isVisible ? l10n.commonVisible : l10n.commonHidden,
          style: TextStyle(
            color: shortcut.isVisible ? Colors.white54 : Colors.white24,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                shortcut.isVisible ? Icons.visibility : Icons.visibility_off,
                color: shortcut.isVisible
                    ? Colors.blue
                    : Colors.white38,
              ),
              onPressed: onToggleVisibility,
            ),
            const Icon(
              Icons.drag_handle,
              color: Colors.white38,
            ),
          ],
        ),
      ),
    );
  }
}
