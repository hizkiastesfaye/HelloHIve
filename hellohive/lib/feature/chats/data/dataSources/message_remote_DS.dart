
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hellohive/core/errors/exception.dart';
import 'package:hellohive/feature/chats/chats_core/chats_core.dart';
import 'package:hellohive/feature/chats/chats_core/chats_message_core.dart';
import 'package:hellohive/feature/chats/data/models/message_model.dart';
import 'package:hellohive/feature/chats/domain/entities/message_entities.dart';

import 'abstract_message_remote_DS.dart';

class MessageRemoteDSImpl implements MessageRemoteDS {
  final FirebaseFirestore firestore;

  MessageRemoteDSImpl({
    required this.firestore,
  });

  CollectionReference<Map<String, dynamic>> get messages =>
      firestore.collection('messages');

  // ------------------------------------------------------------
  // SEND MESSAGE
  // ------------------------------------------------------------

  @override
  Future<ActionStatus> sendMessage(
    SendMessageParams params,
  ) async {
    try {
      print('message sent to remote datasource');
      print('message sent to remote datasource');
      print('message sent to remote datasource');
      // print(params.chatId);
      // print(params.text);
      print('message sent to remote datasource');
      print('message sent to remote datasource');
      print('message sent to remote datasource');
      print('message sent to remote datasource');
      final now = DateTime.now();

      final messageId = _generateMessageId(
        params.senderId,
        now,
      );

      final message = ChatMessageModel(
        id: messageId,
        chatId: params.chatId,
        senderId: params.senderId,
        receiverId: params.receiverId,
        isEdited: false,
        type: params.type,
        status: MessageStatus.sent,
        deletedBy: {},
        createdAt: now,
        updatedAt: now,
        text: params.text,
        mediaUrl: params.mediaUrl,
        repliedMessageId: params.repliedMessageId,
      );

      await messages
          .doc(messageId)
          .set(message.toJson());

      return ActionStatus.success;
    } on FirebaseException catch (e) {
      throw ServerException(
        e.message ?? 'Failed to send message',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ------------------------------------------------------------
  // LISTEN MESSAGES
  // ------------------------------------------------------------

  @override
  Stream<List<ChatMessageModel>> listenMessages(
    ChatIdParams params,
  ) {
    return messages
        .where(
          'chatId',
          isEqualTo: params.chatId,
        )
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots()
        .map(
          (snapshot) {
            return snapshot.docs
                .map(
                  (doc) => ChatMessageModel.fromJson(
                    doc.data(),
                  ),
                )
                .toList();
          },
        );
  }

  // ------------------------------------------------------------
  // GET LAST MESSAGE
  // ------------------------------------------------------------

  @override
  Future<ChatMessageModel> getLastMessage(
    ChatIdParams params,
  ) async {
    try {
      final snapshot = await messages
          .where(
            'chatId',
            isEqualTo: params.chatId,
          )
          .orderBy(
            'createdAt',
            descending: true,
          )
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        throw CacheException('No messages found');
      }

      return ChatMessageModel.fromJson(
        snapshot.docs.first.data(),
      );
    } on FirebaseException catch (e) {
      throw ServerException(
        e.message ?? 'Failed to get last message',
      );
    } on CacheException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ------------------------------------------------------------
  // GET MESSAGE BY ID
  // ------------------------------------------------------------

  @override
  Future<ChatMessageModel?> getMessageById(
    String messageId,
  ) async {
    try {
      final snapshot = await messages
          .doc(messageId)
          .get();

      if (!snapshot.exists) {
        return null;
      }

      final data = snapshot.data();

      if (data == null) {
        return null;
      }

      return ChatMessageModel.fromJson(data);
    } on FirebaseException catch (e) {
      throw ServerException(
        e.message ?? 'Failed to get message',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ------------------------------------------------------------
  // GET MESSAGES
  // ------------------------------------------------------------

  @override
  Future<List<ChatMessageModel>> getMessages(
    ChatIdParams params,
  ) async {
    try {
      final snapshot = await messages
          .where(
            'chatId',
            isEqualTo: params.chatId,
          )
          .orderBy(
            'createdAt',
            descending: true,
          )
          .get();

      return snapshot.docs
          .map(
            (doc) => ChatMessageModel.fromJson(
              doc.data(),
            ),
          )
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(
        e.message ?? 'Failed to get messages',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ------------------------------------------------------------
  // EDIT MESSAGE
  // ------------------------------------------------------------

  @override
  Future<ActionStatus> editMessage(
    EditMessageParams params,
  ) async {
    try {
      await messages
          .doc(params.messageId)
          .update({
        'text': params.newText,
        'isEdited': true,
        'editedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return ActionStatus.success;
    } on FirebaseException catch (e) {
      throw ServerException(
        e.message ?? 'Failed to edit message',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ------------------------------------------------------------
  // DELETE MESSAGE
  // ------------------------------------------------------------

  @override
  Future<ActionStatus> deleteMessage(
    DeleteMessageParams params,
  ) async {
    try {
      await messages
          .doc(params.messageId)
          .update({
        'deletedBy.${params.userId}': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return ActionStatus.success;
    } on FirebaseException catch (e) {
      throw ServerException(
        e.message ?? 'Failed to delete message',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ------------------------------------------------------------
  // MARK MESSAGE AS READ
  // ------------------------------------------------------------

  @override
  Future<ActionStatus> markMessageAsRead(
    MarkMessageAsReadParams params,
  ) async {
    try {
      await messages
          .doc(params.messageId)
          .update({
        'status': MessageStatus.read.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return ActionStatus.success;
    } on FirebaseException catch (e) {
      throw ServerException(
        e.message ?? 'Failed to mark message as read',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ------------------------------------------------------------
  // MESSAGE ID
  // ------------------------------------------------------------

  String _generateMessageId(
    String senderId,
    DateTime time,
  ) {
    return '${senderId}_${time.microsecondsSinceEpoch}';
  }

    @override
  Future<ActionStatus> syncCreateMessage(
    ChatMessageModel message,
  ) async {
    try {
      final remoteMessage = ChatMessageModel(
        id: message.id,
        chatId: message.chatId,
        senderId: message.senderId,
        receiverId: message.receiverId,
        isEdited: message.isEdited,
        type: message.type,
        status: MessageStatus.sent,
        deletedBy: Map<String, bool>.from(
          message.deletedBy,
        ),
        createdAt: message.createdAt,
        updatedAt: message.updatedAt,
        text: message.text,
        mediaUrl: message.mediaUrl,
        repliedMessageId: message.repliedMessageId,
        editedAt: message.editedAt,
      );

      await messages
          .doc(message.id)
          .set(remoteMessage.toJson());

      return ActionStatus.success;
    } on FirebaseException catch (e) {
      throw ServerException(
        e.message ?? 'Failed to sync message',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}