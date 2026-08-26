// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friends_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FriendsHiveModelAdapter extends TypeAdapter<FriendsHiveModel> {
  @override
  final int typeId = 20;

  @override
  FriendsHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FriendsHiveModel(
      uId: fields[0] as String,
      firstName: fields[1] as String,
      lastName: fields[2] as String,
      username: fields[3] as String,
      photoUrl: fields[4] as String,
      description: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FriendsHiveModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.uId)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.username)
      ..writeByte(4)
      ..write(obj.photoUrl)
      ..writeByte(5)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FriendsHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
