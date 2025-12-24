import 'package:hive/hive.dart';
import 'package:quick_app/services/favorite_qr_service.dart';
import '../models/shortcut_item.dart';
class StorageService {
  // static const String _shortcutsKey = 'shortcuts_data';
  static Box<ShortcutItem> get _box => Hive.box<ShortcutItem>('shortcutsBox');
  static Future<void> addShortcut(ShortcutItem item) async {
    await _box.put(item.id, item); // thêm/ghi đè theo id
  }

  static Future<void> deleteShortcutById(String id) async {
    await _box.delete(id);
    await FavoriteQRService.deleteFavoriteByShortcutId(id);
  }

  static Future<void> updateQRData(String newData, ShortcutItem shortcut) async {
  final box = Hive.box<ShortcutItem>('shortcutsBox');
  
  // Tạo shortcut mới với data đã update
  final updatedShortcut = ShortcutItem(
    id: shortcut.id,
    title: shortcut.title,
    qrData: newData, 
    typeId: shortcut.typeId,
    description: shortcut.description,
    appKey: shortcut.appKey,
    position: 23,
    colorValue: 1
  );
  
  // ✅ QUAN TRỌNG: Dùng put() để trigger listener
  await box.put(shortcut.id, updatedShortcut);
}

  static Future<void> removeShortcut(String id) async {
    await _box.delete(id);
  }

  static List<ShortcutItem> getAllShortcuts() {
    return _box.values.toList();
  }

  static List<ShortcutItem> getShortcutsByTypeId(String id) {
    return _box.values.where((b) => b.typeId == id).toList();
  }

  static Future<void> clearAll() async {
    await _box.clear();
  }

  // Lưu shortcuts
  // static Future<void> saveShortcuts(List<ShortcutItem> shortcuts) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final jsonList = shortcuts.map((s) => s.toJson()).toList();
  //   await prefs.setString(_shortcutsKey, json.encode(jsonList));
  // }

  // Load shortcuts
  // static Future<List<ShortcutItem>?> loadShortcuts() async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final jsonString = prefs.getString(_shortcutsKey);
  //     if (jsonString == null) {
  //       return null;
  //     }
      
  //     final List<dynamic> jsonList = json.decode(jsonString);
  //     final shortcuts = jsonList.map((json) {
  //       return ShortcutItem.fromJson(json);
  //     }).toList();
      
  //     return shortcuts;
  //   } catch (e) {
  //     return null;
  //   }
  // }

  // Clear all data
  // static Future<void> clearAll() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove(_shortcutsKey);
  // }

  // Get default shortcuts
  // static List<ShortcutItem> getDefaultShortcuts() {
  //   return [
  //     ShortcutItem(
  //       id: 'facebook',
  //       title: 'Facebook',
  //       color: const Color(0xFFC27D5F),
  //       qrData: 'https://facebook.com/yourprofile',
  //       position: 0,
  //       type: QRType.social,
  //       appKey: "facebook"
  //     ),
  //     ShortcutItem(
  //       id: 'instagram',
  //       title: 'Instagram',
  //       color: const Color(0xFFC27D5F),
  //       qrData: 'https://instagram.com/yourprofile',
  //       position: 1,
  //       type: QRType.social,
  //       appKey: "instagram"
  //     ),
  //     ShortcutItem(
  //       id: 'zalo',
  //       title: 'Zalo',
  //       color: const Color(0xFFC27D5F),
  //       qrData: 'https://zalo.me/yourphone',
  //       position: 2,
  //       type: QRType.social,
  //       appKey: "custom"
  //     ),
  //     ShortcutItem(
  //       id: 'telegram',
  //       title: 'Telegram',
  //       color: const Color(0xFFC27D5F),
  //       qrData: 'https://t.me/yourusername',
  //       position: 3,
  //       type: QRType.social,
  //       appKey: "telegram",
  //       isVisible: false
  //     ),
  //     ShortcutItem(
  //       id: 'bankqr',
  //       title: 'Ngân hàng',
  //       color: const Color(0xFFC27D5F),
  //       qrData: 'BANK:1234567890|VIETCOMBANK',
  //       position: 4,
  //       type: QRType.payment,
  //       appKey: "bank"
  //     ),
  //     ShortcutItem(
  //       id: 'bitcoin',
  //       title: 'Bitcoin',
  //       color: const Color(0xFFC27D5F),
  //       qrData: '',
  //       position: 5,
  //       type: QRType.payment,
  //       appKey: "bitcoin"
  //     ),
  //   ];
  // }
}