// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_meditation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedMeditationAdapter extends TypeAdapter<SavedMeditation> {
  @override
  final int typeId = 1;

  @override
  SavedMeditation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedMeditation(
      fields[0] as String,
      fields[1] as String,
      fields[2] as Duration,
    );
  }

  @override
  void write(BinaryWriter writer, SavedMeditation obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.path)
      ..writeByte(1)
      ..write(obj.meditationName)
      ..writeByte(2)
      ..write(obj.meditationDuration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedMeditationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
