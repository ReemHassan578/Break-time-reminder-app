// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_session_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkSessionModelAdapter extends TypeAdapter<WorkSessionModel> {
  @override
  final int typeId = 1;

  @override
  WorkSessionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkSessionModel(
      workFrom: fields[0] as int,
      workTo: fields[1] as int,
      breakDuration: fields[2] as int,
      breakOccurrence: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, WorkSessionModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.workFrom)
      ..writeByte(1)
      ..write(obj.workTo)
      ..writeByte(2)
      ..write(obj.breakDuration)
      ..writeByte(3)
      ..write(obj.breakOccurrence);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkSessionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
