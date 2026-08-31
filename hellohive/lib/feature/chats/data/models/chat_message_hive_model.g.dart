// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatMessageHiveModelAdapter extends TypeAdapter<ChatMessageHiveModel> {
  @override
  final int typeId = 30;

  @override
  ChatMessageHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatMessageHiveModel(
      id: fields[0] as String,
      chatId: fields[1] as String,
      senderId: fields[2] as String,
      receiverId: fields[3] as String,
      isEdited: fields[4] as bool,
      type: fields[5] as MessageType,
      status: fields[6] as MessageStatus,
      deletedBy: (fields[7] as Map).cast<String, bool>(),
      createdAt: fields[8] as DateTime,
      updatedAt: fields[9] as DateTime,
      text: fields[10] as String?,
      mediaUrl: fields[11] as String?,
      repliedMessageId: fields[12] as String?,
      editedAt: fields[13] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ChatMessageHiveModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.chatId)
      ..writeByte(2)
      ..write(obj.senderId)
      ..writeByte(3)
      ..write(obj.receiverId)
      ..writeByte(4)
      ..write(obj.isEdited)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.deletedBy)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt)
      ..writeByte(10)
      ..write(obj.text)
      ..writeByte(11)
      ..write(obj.mediaUrl)
      ..writeByte(12)
      ..write(obj.repliedMessageId)
      ..writeByte(13)
      ..write(obj.editedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessageHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MessageSyncOperationAdapter extends TypeAdapter<MessageSyncOperation> {
  @override
  final int typeId = 34;

  @override
  MessageSyncOperation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageSyncOperation(
      id: fields[0] as String,
      operation: fields[1] as MessageSyncOperationType,
      messageId: fields[2] as String,
      chatId: fields[3] as String,
      payload: (fields[4] as Map).cast<String, dynamic>(),
      createdAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, MessageSyncOperation obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.operation)
      ..writeByte(2)
      ..write(obj.messageId)
      ..writeByte(3)
      ..write(obj.chatId)
      ..writeByte(4)
      ..write(obj.payload)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageSyncOperationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MessageSyncOperationTypeAdapter
    extends TypeAdapter<MessageSyncOperationType> {
  @override
  final int typeId = 33;

  @override
  MessageSyncOperationType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MessageSyncOperationType.createMessage;
      case 1:
        return MessageSyncOperationType.editMessage;
      case 2:
        return MessageSyncOperationType.deleteMessage;
      case 3:
        return MessageSyncOperationType.markMessageAsRead;
      default:
        return MessageSyncOperationType.createMessage;
    }
  }

  @override
  void write(BinaryWriter writer, MessageSyncOperationType obj) {
    switch (obj) {
      case MessageSyncOperationType.createMessage:
        writer.writeByte(0);
        break;
      case MessageSyncOperationType.editMessage:
        writer.writeByte(1);
        break;
      case MessageSyncOperationType.deleteMessage:
        writer.writeByte(2);
        break;
      case MessageSyncOperationType.markMessageAsRead:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageSyncOperationTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
