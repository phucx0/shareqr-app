// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shortcut_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShortcutTypeAdapter extends TypeAdapter<ShortcutType> {
  @override
  final int typeId = 1;

  @override
  ShortcutType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShortcutType(
      id: fields[0] as String,
      name: fields[1] as String,
      colorValue: fields[2] as int?,
      icon: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ShortcutType obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.colorValue)
      ..writeByte(3)
      ..write(obj.icon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShortcutTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
