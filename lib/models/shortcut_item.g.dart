// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shortcut_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShortcutItemAdapter extends TypeAdapter<ShortcutItem> {
  @override
  final int typeId = 0;

  @override
  ShortcutItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShortcutItem(
      id: fields[0] as String,
      title: fields[1] as String,
      colorValue: fields[2] as int,
      qrData: fields[5] as String,
      position: fields[7] as int,
      typeId: fields[8] as String,
      appKey: fields[3] as String,
      isVisible: fields[6] as bool,
      iconPath: fields[4] as String?,
      description: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ShortcutItem obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.colorValue)
      ..writeByte(3)
      ..write(obj.appKey)
      ..writeByte(4)
      ..write(obj.iconPath)
      ..writeByte(5)
      ..write(obj.qrData)
      ..writeByte(6)
      ..write(obj.isVisible)
      ..writeByte(7)
      ..write(obj.position)
      ..writeByte(8)
      ..write(obj.typeId)
      ..writeByte(9)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShortcutItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
