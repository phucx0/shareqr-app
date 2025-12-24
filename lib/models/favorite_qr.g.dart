// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_qr.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteQRAdapter extends TypeAdapter<FavoriteQR> {
  @override
  final int typeId = 3;

  @override
  FavoriteQR read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteQR(
      id: fields[0] as String,
      shortcutId: fields[1] as String,
      createdAt: fields[2] as DateTime,
      lastUsedAt: fields[3] as DateTime?,
      usageCount: fields[4] as int,
      note: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteQR obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.shortcutId)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.lastUsedAt)
      ..writeByte(4)
      ..write(obj.usageCount)
      ..writeByte(5)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteQRAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
