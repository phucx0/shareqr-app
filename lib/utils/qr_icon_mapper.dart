import 'package:flutter/material.dart';
import '../models/qr_type.dart';

IconData getIconByQRType(QRType type) {
  switch (type) {
    case QRType.social:
      return Icons.share;
    case QRType.payment:
      return Icons.payment;
    case QRType.link:
      return Icons.link;
  }
}
