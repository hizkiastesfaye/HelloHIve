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
      participants: (fields[1] as List).cast<String>(),
      unreadCount: (fields[2] as Map).cast<String, int>(),
      mutedBy: (fields[3] as Map).cast<String, bool>(),
      deletedBy: (fields[4] as Map).cast<String, bool>(),
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] as DateTime,
      lastMessageId: fields[7] as String?,
      lastMessageText: fields[8] as String?,
      lastMessageTime: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ChatHiveModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.participants)
      ..writeByte(2)
      ..write(obj.unreadCount)
      ..writeByte(3)
      ..write(obj.mutedBy)
      ..writeByte(4)
      ..write(obj.deletedBy)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.lastMessageId)
      ..writeByte(8)
      ..write(obj.lastMessageText)
      ..writeByte(9)
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
