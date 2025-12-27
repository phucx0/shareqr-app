import 'package:hive/hive.dart';

part 'qr_enum.g.dart';

@HiveType(typeId: 10)
enum QrType {
  @HiveField(0)
  payment,

  @HiveField(1)
  crypto,

  @HiveField(2)
  social,

  @HiveField(3)
  messenger,

  @HiveField(4)
  phone,

  @HiveField(5)
  email,

  @HiveField(6)
  wifi,

  @HiveField(7)
  url,

  @HiveField(8)
  text,
}
