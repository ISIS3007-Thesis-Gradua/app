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
      path: fields[0] as String,
      name: fields[1] as String,
      duration: fields[2] as Duration,
    );
  }

  @override
  void write(BinaryWriter writer, SimpleMeditation obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.path)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.duration);
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