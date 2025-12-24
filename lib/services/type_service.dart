import 'package:hive/hive.dart';
import 'package:quick_app/models/shortcut_type.dart';

class TypeService {
  static Box<ShortcutType> get _box => Hive.box<ShortcutType>('shortcutTypesBox');


  static ShortcutType getTypeById(String id) {
    return _box.values.where((b) => b.id == id).first;
  }

  static Future<void> addType(ShortcutType type) async {
    await _box.put(type.id, type);
  }

  static List<ShortcutType> getAllTypes() {
    return _box.values.toList();
  }

  static Future<void> removeType(String id) async {
    await _box.delete(id);
  }

  static Future<void> initType() async{
    List<ShortcutType> list = getDefaultTypes();
    for (var t in list) {
      await addType(t);
    }
  }

  // Get default shortcuts
  static List<ShortcutType> getDefaultTypes() {
    return [
      ShortcutType(
        name: "Payment",
        id: "0",
        icon: "assets/svg/payment.svg"
      ),
      ShortcutType(
        name: "Crypto",
        id: "1",
        icon: "assets/svg/bitcoin.svg"
      ),
      ShortcutType(
        name: "Social",
        id: "2",
        icon: "assets/svg/social.svg"
      ),
      ShortcutType(
        name: "Messenger",
        id: "3",
        icon: "assets/svg/messenger.svg"
      ),
      ShortcutType(
        name: "Email",
        id: "4",
        icon: "assets/svg/email.svg"
      ),
      ShortcutType(
        name: "Phone",
        id: "5",
        icon: "assets/svg/phone.svg"
      ),
      ShortcutType(
        name: "WiFi",
        id: "6",
        icon: "assets/svg/wifi.svg"
      ),
      ShortcutType(
        name: "Link",
        id: "10",
        icon: "assets/svg/link.svg"
      ),
    ];
  }
}
