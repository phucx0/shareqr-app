import 'package:quick_app/models/qr_enum.dart';

class QrDetector {
  static String getDomainName(String url) {
    final uri = Uri.parse(url);
    final host = uri.host.replaceFirst('www.', '');
    return host.split('.').first;
  }

  static QrType detectQR(String qrData) {
    final lowerData = qrData.toLowerCase();
    
    // Bank QR patterns
    if (qrData.contains('00020101') || 
        qrData.contains('0002010102') ||
        lowerData.contains('napas') ||
        lowerData.contains('vnpay') ||
        lowerData.contains('momo') ||
        lowerData.contains('zalopay') ||
        (lowerData.contains('bank') && qrData.length > 50)) {
      return QrType.payment; // Bank
    }
    
    if (lowerData.startsWith('bitcoin:') ||
        lowerData.startsWith('btc:') ||
        (qrData.startsWith('1') && qrData.length >= 26 && qrData.length <= 35) ||
        (qrData.startsWith('3') && qrData.length >= 26 && qrData.length <= 35) ||
        (lowerData.startsWith('bc1') && qrData.length >= 26) ||
        lowerData.startsWith('ethereum:') ||
        lowerData.startsWith('eth:') ||
        (qrData.startsWith('0x') && qrData.length == 42 && RegExp(r'^0x[a-fA-F0-9]{40}$').hasMatch(qrData))
        ) {
      return QrType.crypto;
    }


    // Social media patterns (ID: 2)
    if (lowerData.contains('facebook.com') ||
        lowerData.contains('instagram.com') || 
        lowerData.contains('twitter.com') || lowerData.contains('x.com') ||
        lowerData.contains('linkedin.com') ||
        lowerData.contains('tiktok.com') ||
        lowerData.contains('youtube.com') ||
        lowerData.contains('threads.net') ||
        lowerData.contains('snapchat.com') ||
        lowerData.contains('pinterest.com') ||
        lowerData.contains('reddit.com')) {
      
      return QrType.social;
    }
    
    // Messaging apps (ID: 3)
    if (lowerData.contains('zalo.me') || lowerData.contains('zalo://') ||
        lowerData.contains('t.me') || lowerData.contains('telegram.me') ||
        lowerData.contains('wa.me') || lowerData.contains('whatsapp.com') ||
        lowerData.contains('viber://') ||
        lowerData.contains('line.me')) {
      return QrType.messenger; // Messenger
    }
    
    if (lowerData.startsWith('mailto:') ||
        RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(qrData)) {
      return QrType.email;
    }

    // Phone (ID: 5)
    if (lowerData.startsWith('tel:') ||
        RegExp(r'^(\+84|0)\d{9,10}$').hasMatch(qrData.replaceAll(' ', ''))) {
      return QrType.phone;
    }
    if (qrData.startsWith('WIFI:')) {
      return QrType.wifi;
    }
    // Default to link if it's a URL
    if (lowerData.startsWith('http://') || 
        lowerData.startsWith('https://') || 
        lowerData.contains('www.')) {
      
      return QrType.url;
    }

    // Default
    return QrType.text;
  }
}