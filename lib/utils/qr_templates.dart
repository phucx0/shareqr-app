import '../models/qr_template.dart';

class QRTemplates {
  static List<QRTemplate> getTemplates(String shortcutTitle) {
    switch (shortcutTitle) {
      case 'Facebook':
        return [
          QRTemplate('Profile', 'https://facebook.com/'),
          QRTemplate('Page', 'https://facebook.com/pages/'),
        ];
      case 'Instagram':
        return [
          QRTemplate('Profile', 'https://instagram.com/'),
        ];
      case 'Zalo':
        return [
          QRTemplate('Phone', 'https://zalo.me/'),
        ];
      case 'Telegram':
        return [
          QRTemplate('Username', 'https://t.me/'),
        ];
      case 'ZaloPay':
      case 'MoMo':
      case 'VNPay':
        return [
          QRTemplate('Phone', '${shortcutTitle.toUpperCase()}:'),
        ];
      case 'Bank QR':
        return [
          QRTemplate('Vietcombank', 'BANK:|VIETCOMBANK'),
          QRTemplate('VCB', 'BANK:|VCB'),
          QRTemplate('Techcombank', 'BANK:|TECHCOMBANK'),
        ];
      default:
        return [];
    }
  }
}