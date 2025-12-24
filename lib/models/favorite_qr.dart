// models/favorite_qr.dart
import 'package:hive/hive.dart';
import 'package:quick_app/models/shortcut_item.dart';

part 'favorite_qr.g.dart';

@HiveType(typeId: 3)
class FavoriteQR extends HiveObject {
  @HiveField(0)
  String id; // ID của favorite (auto-generated)

  @HiveField(1)
  String shortcutId; // Reference đến ShortcutItem

  @HiveField(2)
  DateTime createdAt;

  @HiveField(3)
  DateTime? lastUsedAt;

  @HiveField(4)
  int usageCount;

  @HiveField(5)
  String? note; // Custom note riêng cho favorite (optional)

  FavoriteQR({
    required this.id,
    required this.shortcutId,
    required this.createdAt,
    this.lastUsedAt,
    this.usageCount = 0,
    this.note,
  });

  // Copy with method
  FavoriteQR copyWith({
    String? id,
    String? shortcutId,
    DateTime? createdAt,
    DateTime? lastUsedAt,
    int? usageCount,
    String? note,
  }) {
    return FavoriteQR(
      id: id ?? this.id,
      shortcutId: shortcutId ?? this.shortcutId,
      createdAt: createdAt ?? this.createdAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      usageCount: usageCount ?? this.usageCount,
      note: note ?? this.note,
    );
  }

  // Helper method để lấy ShortcutItem
  ShortcutItem? getShortcut() {
    final box = Hive.box<ShortcutItem>('shortcutsBox');
    return box.get(shortcutId);
  }

  // To Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shortcutId': shortcutId,
      'createdAt': createdAt.toIso8601String(),
      'lastUsedAt': lastUsedAt?.toIso8601String(),
      'usageCount': usageCount,
      'note': note,
    };
  }

  // From Map
  factory FavoriteQR.fromMap(Map<String, dynamic> map) {
    return FavoriteQR(
      id: map['id'],
      shortcutId: map['shortcutId'],
      createdAt: DateTime.parse(map['createdAt']),
      lastUsedAt: map['lastUsedAt'] != null 
          ? DateTime.parse(map['lastUsedAt']) 
          : null,
      usageCount: map['usageCount'] ?? 0,
      note: map['note'],
    );
  }
}
