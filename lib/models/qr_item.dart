import 'package:hive/hive.dart';
import 'package:quick_app/models/qr_enum.dart';
import 'package:quick_app/models/qr_type.dart';
import 'package:quick_app/services/favorite_qr_service.dart';

part 'qr_item.g.dart';

@HiveType(typeId: 0)
class QRItem extends HiveObject {
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
  QrType type;

  @HiveField(9)
  String description; // ← THÊM FIELD NÀY

  QRItem({
    required this.id,
    required this.title,
    required this.colorValue,
    required this.qrData,
    required this.position,
    required this.type,
    required this.appKey,
    this.isVisible = true,
    this.iconPath,
    this.description = '', // ← THÊM PARAMETER NÀY
  });

  QRItem copyWith({
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
    return QRItem(
      id: id ?? this.id,
      title: title ?? this.title,
      qrData: qrData ?? this.qrData,
      isVisible: isVisible ?? this.isVisible,
      position: position ?? this.position,
      type: type,
      appKey: appKey ?? this.appKey,
      iconPath: iconPath ?? this.iconPath,
      colorValue: colorValue ?? this.colorValue,
      description: description ?? this.description,
    );
  }

  // Helper method để lấy ShortcutType
  QrTypeModel? get getType {
    final box = Hive.box<QrTypeModel>('QRTypesBox');
    return box.get(type.name);
  }

  // Helper method để lấy type name
  String get typeName {
    return getType?.name ?? 'Unknown';
  }

  bool get isFavorite {
    return FavoriteQRService.getFavoriteByShortcutId(id) != null;
  }
}