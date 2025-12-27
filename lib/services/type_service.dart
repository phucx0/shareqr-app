import 'package:hive/hive.dart';
import 'package:quick_app/models/qr_enum.dart';
import 'package:quick_app/models/qr_type.dart';

class TypeService {
  static Box<QrTypeModel> get _box => Hive.box<QrTypeModel>('QRTypesBox');

  static QrTypeModel getTypeById(QrType type) {
    return _box.values.where((b) => b.type == type).first;
  }

  static Future<void> addType(QrTypeModel qrType) async {
    await _box.put(qrType.type.name, qrType);
  }

  static List<QrTypeModel> getAllTypes() {
    return _box.values.toList();
  }

  static Future<void> removeType(QrType type) async {
    await _box.delete(type.name);
  }

  static Future<void> initType() async{
    List<QrTypeModel> list = getDefaultTypes();
    for (var t in list) {
      await addType(t);
    }
  }

  // Get default shortcuts
  static List<QrTypeModel> getDefaultTypes() {
    return [
      QrTypeModel(
        type: QrType.payment,
        name: "Payment",
        icon: "assets/svg/payment.svg"
      ),
      QrTypeModel(
        type: QrType.crypto,
        name: "Crypto",
        icon: "assets/svg/bitcoin.svg"
      ),
      QrTypeModel(
        type: QrType.social,
        name: "Social",
        icon: "assets/svg/social.svg"
      ),
      QrTypeModel(
        type: QrType.messenger,
        name: "Messenger",
        icon: "assets/svg/messenger.svg"
      ),
      QrTypeModel(
        type: QrType.email,
        name: "Email",
        icon: "assets/svg/email.svg"
      ),
      QrTypeModel(
        type: QrType.phone,
        name: "Phone",
        icon: "assets/svg/phone.svg"
      ),
      QrTypeModel(
        type: QrType.wifi,
        name: "WiFi",
        icon: "assets/svg/wifi.svg"
      ),
      QrTypeModel(
        type: QrType.url,
        name: "Link",
        icon: "assets/svg/link.svg"
      ),
      QrTypeModel(
        type: QrType.text,
        name: "Text",
        icon: "assets/svg/text.svg"
      ),
    ];
  }
}
