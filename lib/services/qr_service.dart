import 'package:hive/hive.dart';
import 'package:quick_app/models/qr_enum.dart';
import 'package:quick_app/services/favorite_qr_service.dart';
import '../models/qr_item.dart';

class QRService {
  // static const String _QRsKey = 'QRs_data';
  static Box<QRItem> get _box => Hive.box<QRItem>('QRsBox');
  static Future<void> addQR(QRItem item) async {
    await _box.put(item.id, item); // thêm/ghi đè theo id
  }

  static Future<void> deleteQRById(String id) async {
    await _box.delete(id);
    await FavoriteQRService.deleteFavoriteByQRId(id);
  }

  static Future<void> updateQRData(String newData, QRItem qr) async {
    final updatedQR = QRItem(
      id: qr.id,
      title: qr.title,
      qrData: newData, 
      type: qr.type,
      description: qr.description,
      appKey: qr.appKey,
      position: 23,
      colorValue: 1
    );
    
    // ✅ QUAN TRỌNG: Dùng put() để trigger listener
    await _box.put(qr.id, updatedQR);
  }

  static Future<void> removeQR(String id) async {
    await _box.delete(id);
  }

  static List<QRItem> getAllQRs() {
    return _box.values.toList();
  }

  static List<QRItem> getQRsByType(QrType type) {
    return _box.values.where((b) => b.type == type).toList();
  }

  static Future<void> clearAll() async {
    await _box.clear();
  }
}