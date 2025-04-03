// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jellyfish_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JellyfishAdapter extends TypeAdapter<Jellyfish> {
  @override
  final int typeId = 0;

  @override
  Jellyfish read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Jellyfish(
      id: fields[0] as String,
      name: fields[1] as String,
      scientificName: fields[2] as String,
      description: fields[3] as String,
      shortDescription: fields[4] as String,
      funFact: fields[5] as String,
      dangerLevel: fields[6] as DangerLevel,
      imageUrl: fields[7] as String,
      colors: (fields[8] as List).cast<String>(),
      habitats: (fields[9] as List).cast<String>(),
      size: fields[10] as String,
      isDiscovered: fields[11] as bool,
      discoveredAt: fields[12] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Jellyfish obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.scientificName)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.shortDescription)
      ..writeByte(5)
      ..write(obj.funFact)
      ..writeByte(6)
      ..write(obj.dangerLevel)
      ..writeByte(7)
      ..write(obj.imageUrl)
      ..writeByte(8)
      ..write(obj.colors)
      ..writeByte(9)
      ..write(obj.habitats)
      ..writeByte(10)
      ..write(obj.size)
      ..writeByte(11)
      ..write(obj.isDiscovered)
      ..writeByte(12)
      ..write(obj.discoveredAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JellyfishAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DangerLevelAdapter extends TypeAdapter<DangerLevel> {
  @override
  final int typeId = 1;

  @override
  DangerLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DangerLevel.safe;
      case 1:
        return DangerLevel.mild;
      case 2:
        return DangerLevel.moderate;
      case 3:
        return DangerLevel.severe;
      case 4:
        return DangerLevel.deadly;
      default:
        return DangerLevel.safe;
    }
  }

  @override
  void write(BinaryWriter writer, DangerLevel obj) {
    switch (obj) {
      case DangerLevel.safe:
        writer.writeByte(0);
        break;
      case DangerLevel.mild:
        writer.writeByte(1);
        break;
      case DangerLevel.moderate:
        writer.writeByte(2);
        break;
      case DangerLevel.severe:
        writer.writeByte(3);
        break;
      case DangerLevel.deadly:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DangerLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
