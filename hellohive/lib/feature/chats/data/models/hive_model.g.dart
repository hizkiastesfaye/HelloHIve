// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatHiveModelAdapter extends TypeAdapter<ChatHiveModel> {
  @override
  final int typeId = 0;

  @override
  ChatHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatHiveModel(
      id: fields[0] as String,
      userAId: fields[1] as String,
      userBId: fields[2] as String,
      unreadCount: (fields[3] as Map).cast<String, int>(),
      mutedBy: (fields[4] as Map).cast<String, bool>(),
      deletedBy: (fields[5] as Map).cast<String, bool>(),
      createdAt: fields[6] as DateTime,
      updatedAt: fields[7] as DateTime,
      lastMessageId: fields[8] as String?,
      lastMessageText: fields[9] as String?,
      lastMessageTime: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ChatHiveModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userAId)
      ..writeByte(2)
      ..write(obj.userBId)
      ..writeByte(3)
      ..write(obj.unreadCount)
      ..writeByte(4)
      ..write(obj.mutedBy)
      ..writeByte(5)
      ..write(obj.deletedBy)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(8)
      ..write(obj.lastMessageId)
      ..writeByte(9)
      ..write(obj.lastMessageText)
      ..writeByte(10)
      ..write(obj.lastMessageTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChatSyncOperationAdapter extends TypeAdapter<ChatSyncOperation> {
  @override
  final int typeId = 10;

  @override
  ChatSyncOperation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatSyncOperation(
      id: fields[0] as String,
      operation: fields[1] as SyncOperationType,
      chatId: fields[2] as String,
      payload: (fields[3] as Map).cast<String, dynamic>(),
      createdAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ChatSyncOperation obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.operation)
      ..writeByte(2)
      ..write(obj.chatId)
      ..writeByte(3)
      ..write(obj.payload)
      ..writeByte(4)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatSyncOperationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
