// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_enum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QrTypeAdapter extends TypeAdapter<QrType> {
  @override
  final int typeId = 10;

  @override
  QrType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return QrType.payment;
      case 1:
        return QrType.crypto;
      case 2:
        return QrType.social;
      case 3:
        return QrType.messenger;
      case 4:
        return QrType.phone;
      case 5:
        return QrType.email;
      case 6:
        return QrType.wifi;
      case 7:
        return QrType.url;
      case 8:
        return QrType.text;
      default:
        return QrType.payment;
    }
  }

  @override
  void write(BinaryWriter writer, QrType obj) {
    switch (obj) {
      case QrType.payment:
        writer.writeByte(0);
        break;
      case QrType.crypto:
        writer.writeByte(1);
        break;
      case QrType.social:
        writer.writeByte(2);
        break;
      case QrType.messenger:
        writer.writeByte(3);
        break;
      case QrType.phone:
        writer.writeByte(4);
        break;
      case QrType.email:
        writer.writeByte(5);
        break;
      case QrType.wifi:
        writer.writeByte(6);
        break;
      case QrType.url:
        writer.writeByte(7);
        break;
      case QrType.text:
        writer.writeByte(8);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QrTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
