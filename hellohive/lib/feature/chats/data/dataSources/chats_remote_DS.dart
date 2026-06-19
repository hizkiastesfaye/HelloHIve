import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hellohive/feature/chats/chats_core/chats_core.dart';
import 'package:hellohive/feature/chats/data/dataSources/abstract_remote_DS.dart';
import 'package:hellohive/feature/chats/data/models/chats_model.dart';

class ChatRemoteDatasourceImpl implements ChatRemoteDatasource {
  final FirebaseFirestore firestore;

  ChatRemoteDatasourceImpl({required this.firestore});
  CollectionReference get chats => firestore.collection('chats');
  @override
  Future<ActionStatus> createChat(UsersChatParams params)async {
    try {
      print('-----------------Chat created in remote datasource------------------');

      final chatId = generateChatId(params.currentUserId, params.userBId);
      final chatDoc = chats.doc(chatId);
      // final existDoc = await chatDoc.get();
      final Map<String,bool> stat = {params.currentUserId:false,params.userBId:false};
      final chatData = {
        'id':chatId,
        'userAId': params.currentUserId,
        'userBId': params.userBId,
        'unreadCount': {},
        'mutedBy': stat,
        'deletedBy': stat,
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
        'lastMessageId': '',
        'lastMessageText': '',
        'lastMessageTime': '',
      };
      await chatDoc.set(chatData, SetOptions(merge: true));
      // if (!existDoc.exists){
      //   await chatDoc.set(chatData);
      // }

      print('-----------------Chat created in remote datasource------------------');
      print('-----------------Chat created in remote datasource------------------');
      print('-----------------Chat created in remote datasource------------------');
      print('${params.currentUserId} and ${params.userBId} ');
      print('-----------------Chat created in remote datasource------------------');
      print('-----------------Chat created in remote datasource------------------');

      return ActionStatus.success;
    } catch (e) {
      return ActionStatus.failed;
    }

  }
  @override
  Stream<List<ChatModel>> watchChats(
    String userId,
  ) {
    return chats.snapshots().map((snapshot) {
      return snapshot.docs
          .map(
            (doc) => ChatModel.fromJson(
              doc.data() as Map<String, dynamic>,
            ),
          )
          .where(
            (chat) =>
                chat.userAId == userId ||
                chat.userBId == userId,
          )
          .toList();
    });
  }
  @override
  Future<ChatModel> getChat(
    UsersChatParams params,
  ) async {
    final users = [
      params.currentUserId,
      params.userBId,
    ]..sort();

    final chatId = generateChatId(users[0], users[1]);

    final doc = await chats.doc(chatId).get();

    if (!doc.exists) {
      throw Exception('Chat not found');
    }

    return ChatModel.fromJson(
      doc.data() as Map<String, dynamic>,
    );
  }
  @override
  Future<List<ChatModel>> getChats(
    UserIdParams params,
  ) async {
    final snapshot = await chats.get();

    return snapshot.docs
        .map(
          (doc) => ChatModel.fromJson(
            doc.data() as Map<String, dynamic>,
          ),
        )
        .where(
          (chat) =>
              chat.userAId == params.userId ||
              chat.userBId == params.userId,
        )
        .toList();
  }
  @override
  Future<ChatModel?> getChatById(
    String chatId,
  ) async {
    final doc = await chats.doc(chatId).get();

    if (!doc.exists) {
      return null;
    }

    return ChatModel.fromJson(
      doc.data() as Map<String, dynamic>,
    );
  }
  @override
  Future<ActionStatus> updateChat(
    MostChatParams params,
  ) async {
    await chats.doc(params.id).update({
      'mutedBy': params.mutedBy,
      'deletedBy': params.deletedBy,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return ActionStatus.success;
  }
  @override
  Future<ActionStatus> deleteChat(
    ChatIdUserIdParams params,
  ) async {
    await chats.doc(params.chatId).update({
      'deletedBy.${params.userId}': true,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return ActionStatus.success;
  }
  @override
  Future<ActionStatus> muteChat(
    MuteChatParams params,
  ) async {
    await chats.doc(params.chatId).update({
      'mutedBy.${params.currentUserId}': params.isMuted,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return ActionStatus.success;
  }

  @override
  Future<ActionStatus> updateLastMessage(UpdateLastMessageParams params,) async {
    await chats.doc(params.chatId).update({
      'lastMessageId': params.lastMessageId,
      'lastMessageText': params.lastMessageText,
      'lastMessageTime': params.lastMessageTime,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return ActionStatus.success;
  }
  }