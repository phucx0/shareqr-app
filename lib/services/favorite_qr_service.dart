// services/favorite_qr_service.dart
import 'package:hive/hive.dart';
import 'package:quick_app/models/favorite_qr.dart';
import 'package:quick_app/models/qr_item.dart';

class FavoriteQRService {
  static const String _boxName = 'favoriteQRBox';

  // Get box
  static Box<FavoriteQR> get _box => Hive.box<FavoriteQR>(_boxName);
  static Box<QRItem> get _shortcutBox => Hive.box<QRItem>('QRsBox');

  static List<QRItem> getFavoriteShortcuts() {
    return getAllFavoritesWithQRs()
        .map((item) => item['shortcut'] as QRItem)
        .toList();
  }


  // CREATE - Thêm shortcut vào favorites
  static Future<bool> addFavorite({
    required String shortcutId,
    String? note,
  }) async {
    try {
      // Check if shortcut exists
      final shortcut = _shortcutBox.get(shortcutId);
      if (shortcut == null) {
        return false;
      }

      // Check if already favorited
      if (isFavorite(shortcutId)) {
        return false;
      }

      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final favorite = FavoriteQR(
        id: id,
        qrId: shortcutId,
        createdAt: DateTime.now(),
        note: note,
      );

      await _box.put(id, favorite);
      return true;
    } catch (e) {
      return false;
    }
  }

  // READ - Lấy tất cả favorites
  static List<FavoriteQR> getAllFavorites() {
    return _box.values.toList();
  }

  // READ - Lấy tất cả favorites kèm ShortcutItem (chỉ những shortcut còn tồn tại)
  static List<Map<String, dynamic>> getAllFavoritesWithQRs() {
    return _box.values.map((fav) {
      final shortcut = fav.getQR();
      return {
        'favorite': fav,
        'shortcut': shortcut,
      };
    }).where((item) => item['shortcut'] != null).toList();
  }

  // READ - Lấy favorite theo ID
  static FavoriteQR? getFavoriteById(String id) {
    return _box.get(id);
  }

  // READ - Lấy favorite theo shortcutId
  static FavoriteQR? getFavoriteByShortcutId(String shortcutId) {
    try {
      return _box.values.firstWhere(
        (fav) => fav.qrId == shortcutId,
      );
    } catch (e) {
      return null;
    }
  }

  // READ - Lấy favorites được dùng nhiều nhất
  static List<Map<String, dynamic>> getMostUsedFavorites({int limit = 10}) {
    final favoritesWithShortcuts = getAllFavoritesWithQRs();
    favoritesWithShortcuts.sort((a, b) {
      final favA = a['favorite'] as FavoriteQR;
      final favB = b['favorite'] as FavoriteQR;
      return favB.usageCount.compareTo(favA.usageCount);
    });
    return favoritesWithShortcuts.take(limit).toList();
  }

  // READ - Lấy favorites gần đây
  static List<Map<String, dynamic>> getRecentFavorites({int limit = 10}) {
    final favoritesWithShortcuts = getAllFavoritesWithQRs();
    favoritesWithShortcuts.sort((a, b) {
      final favA = a['favorite'] as FavoriteQR;
      final favB = b['favorite'] as FavoriteQR;
      final aDate = favA.lastUsedAt ?? favA.createdAt;
      final bDate = favB.lastUsedAt ?? favB.createdAt;
      return bDate.compareTo(aDate);
    });
    return favoritesWithShortcuts.take(limit).toList();
  }

  // UPDATE - Cập nhật note
  static Future<bool> updateNote({
    required String id,
    String? note,
  }) async {
    try {
      final favorite = _box.get(id);
      if (favorite == null) return false;

      final updated = favorite.copyWith(note: note);
      await _box.put(id, updated);
      return true;
    } catch (e) {
      return false;
    }
  }

  // UPDATE - Tăng số lần sử dụng
  static Future<void> incrementUsage(String shortcutId) async {
    try {
      final favorite = getFavoriteByShortcutId(shortcutId);
      if (favorite == null) return;
      
      final updated = favorite.copyWith(
        usageCount: favorite.usageCount + 1,
        lastUsedAt: DateTime.now(),
      );

      await _box.put(favorite.id, updated);
    } catch (e) {
      // Shortcut not in favorites, ignore
    }
  }

  // DELETE - Xóa favorite theo ID
  static Future<bool> deleteFavorite(String id) async {
    try {
      await _box.delete(id);
      return true;
    } catch (e) {
      return false;
    }
  }

  // DELETE - Xóa favorite theo shortcutId
  static Future<bool> deleteFavoriteByQRId(String shortcutId) async {
    try {
      final favorite = getFavoriteByShortcutId(shortcutId);
      if (favorite == null) return false;
      
      await _box.delete(favorite.id);
      return true;
    } catch (e) {
      return false;
    }
  }

  // DELETE - Xóa nhiều favorites
  static Future<void> deleteFavorites(List<String> ids) async {
    await _box.deleteAll(ids);
  }

  // DELETE - Xóa tất cả favorites
  static Future<void> deleteAllFavorites() async {
    await _box.clear();
  }

  // DELETE - Cleanup favorites của shortcuts đã bị xóa
  static Future<int> cleanupDeletedShortcuts() async {
    final toDelete = <String>[];
    
    for (var fav in _box.values) {
      final shortcut = fav.getQR();
      if (shortcut == null) {
        toDelete.add(fav.id);
      }
    }
    
    if (toDelete.isNotEmpty) {
      await _box.deleteAll(toDelete);
    }
    
    return toDelete.length;
  }

  // UTILITY - Kiểm tra shortcut đã được yêu thích chưa
  static bool isFavorite(String shortcutId) {
    return _box.values.any((fav) => fav.qrId == shortcutId);
  }

  // UTILITY - Tìm kiếm favorites
  static List<Map<String, dynamic>> searchFavorites(String query) {
    final lowercaseQuery = query.toLowerCase();
    
    return getAllFavoritesWithQRs().where((item) {
      final fav = item['favorite'] as FavoriteQR;
      final shortcut = item['shortcut'] as QRItem?;
      
      if (shortcut == null) return false;
      
      return shortcut.title.toLowerCase().contains(lowercaseQuery) ||
             shortcut.qrData.toLowerCase().contains(lowercaseQuery) ||
             shortcut.description.toLowerCase().contains(lowercaseQuery) ||
             (fav.note?.toLowerCase().contains(lowercaseQuery) ?? false);
    }).toList();
  }

  // UTILITY - Đếm số lượng favorites
  static int getFavoritesCount() {
    return _box.length;
  }

  // UTILITY - Đếm số lượng theo type
  static Map<String, int> getCountByType() {
    final countMap = <String, int>{};
    
    for (var item in getAllFavoritesWithQRs()) {
      final shortcut = item['shortcut'] as QRItem;
      final typeName = shortcut.typeName;
      countMap[typeName] = (countMap[typeName] ?? 0) + 1;
    }
    
    return countMap;
  }

  // EXPORT - Export data
  static List<Map<String, dynamic>> exportAllFavorites() {
    return _box.values.map((fav) => fav.toMap()).toList();
  }

  // IMPORT - Import data
  static Future<int> importFavorites(List<Map<String, dynamic>> data) async {
    int imported = 0;
    
    for (var item in data) {
      final favorite = FavoriteQR.fromMap(item);
      // Verify shortcut exists before importing
      if (_shortcutBox.get(favorite.qrId) != null) {
        await _box.put(favorite.id, favorite);
        imported++;
      }
    }
    
    return imported;
  }
}