// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 2;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      uid: fields[0] as String?,
      name: fields[1] as String,
      email: fields[10] as String?,
      exp: fields[2] as int,
      level: fields[3] as int,
      discoveredJellyfishCount: fields[4] as int,
      reportedJellyfishCount: fields[9] as int,
      badgeCount: fields[5] as int,
      completedQuizIds: (fields[6] as List).cast<int>(),
      lastLoginDate: fields[7] as DateTime?,
      createdAt: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.exp)
      ..writeByte(3)
      ..write(obj.level)
      ..writeByte(4)
      ..write(obj.discoveredJellyfishCount)
      ..writeByte(5)
      ..write(obj.badgeCount)
      ..writeByte(6)
      ..write(obj.completedQuizIds)
      ..writeByte(7)
      ..write(obj.lastLoginDate)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.reportedJellyfishCount)
      ..writeByte(10)
      ..write(obj.email);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
