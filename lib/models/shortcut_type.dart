import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:quick_app/l10n/app_localizations.dart';
part 'shortcut_type.g.dart';

@HiveType(typeId: 1)
class ShortcutType extends HiveObject {
  @HiveField(0)
  String id;       // uuid hoặc timestamp

  @HiveField(1)
  String name;     // tên loại, ví dụ "Event", "Promo"

  @HiveField(2)
  int? colorValue;  // màu hiển thị

  @HiveField(3)
  String? icon;

  ShortcutType({
    required this.id,
    required this.name,
    this.colorValue,
    this.icon
  });

  // Getter để lấy translated name
  String getName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (name.toLowerCase()) {
      case 'payment':
        return l10n.filterPayment;
      case 'crypto':
        return l10n.filterCrypto;
      case 'social':
        return l10n.filterSocial;
      case 'messenger':
        return l10n.filterMessenger;
      case 'phone':
        return l10n.filterPhone;
      default:
        return name;
    }
  }

  int get color => colorValue!;
  set color(int value) => colorValue = value;  
}
