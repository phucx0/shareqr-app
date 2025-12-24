import 'package:hive/hive.dart';
import 'package:quick_app/models/shortcut_type.dart';
import 'package:quick_app/services/favorite_qr_service.dart';

part 'shortcut_item.g.dart';

@HiveType(typeId: 0)
class ShortcutItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  int colorValue; // Lưu color dưới dạng int

  @HiveField(3)
  final String appKey;

  @HiveField(4)
  final String? iconPath;

  @HiveField(5)
  String qrData;

  @HiveField(6)
  bool isVisible;

  @HiveField(7)
  int position;

  @HiveField(8)
  String typeId;

  @HiveField(9)
  String description; // ← THÊM FIELD NÀY

  ShortcutItem({
    required this.id,
    required this.title,
    required this.colorValue,
    required this.qrData,
    required this.position,
    required this.typeId,
    required this.appKey,
    this.isVisible = true,
    this.iconPath,
    this.description = '', // ← THÊM PARAMETER NÀY
  });

  ShortcutItem copyWith({
    String? id,
    String? title,
    int? colorValue,
    String? qrData,
    bool? isVisible,
    int? position,
    String? typeId,
    String? appKey,
    String? iconPath,
    String? description, // ← THÊM PARAMETER NÀY
  }) {
    return ShortcutItem(
      id: id ?? this.id,
      title: title ?? this.title,
      qrData: qrData ?? this.qrData,
      isVisible: isVisible ?? this.isVisible,
      position: position ?? this.position,
      typeId: typeId ?? this.typeId,
      appKey: appKey ?? this.appKey,
      iconPath: iconPath ?? this.iconPath,
      colorValue: colorValue ?? this.colorValue,
      description: description ?? this.description, // ← THÊM DÒNG NÀY
    );
  }

  // Helper method để lấy ShortcutType
  ShortcutType? get type {
    final box = Hive.box<ShortcutType>('shortcutTypesBox');
    return box.get(typeId);
  }

  // Helper method để lấy type name
  String get typeName {
    return type?.name ?? 'Unknown';
  }

  bool get isFavorite {
    return FavoriteQRService.getFavoriteByShortcutId(id) != null;
  }
}