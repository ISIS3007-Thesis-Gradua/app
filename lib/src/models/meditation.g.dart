// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meditation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SimpleMeditationAdapter extends TypeAdapter<SimpleMeditation> {
  @override
  final int typeId = 0;

  @override
  SimpleMeditation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SimpleMeditation(
      path: fields[1] as String,
      name: fields[2] as String,
    )
      ..id = fields[0] as String
      ..durationInSeconds = fields[3] as double;
  }

  @override
  void write(BinaryWriter writer, SimpleMeditation obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.path)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.durationInSeconds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SimpleMeditationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
