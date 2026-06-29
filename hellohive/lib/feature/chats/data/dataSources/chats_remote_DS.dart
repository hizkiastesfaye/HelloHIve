import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hellohive/feature/chats/chats_core/chats_core.dart';
import 'package:hellohive/feature/chats/data/dataSources/abstract_remote_DS.dart';
import 'package:hellohive/feature/chats/data/models/chats_model.dart';

class ChatRemoteDatasourceImpl implements ChatRemoteDatasource {
  final FirebaseFirestore firestore;

  ChatRemoteDatasourceImpl({required this.firestore});
  CollectionReference get chats => firestore.collection('chats');
  final currentUser = FirebaseAuth.instance.currentUser;
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
        'participants':[params.currentUserId, params.userBId],
        'unreadCount': {},
        'mutedBy': stat,
        'deletedBy': stat,
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
        'lastMessageId': '',
        'lastMessageText': '',
        'lastMessageTime': null,
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
    return chats
        .where(
          'participants',
          arrayContains: userId,
        )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => ChatModel.fromJson(
                  doc.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }
  @override
  Future<ChatModel> getChat(
    UsersChatParams params,
  ) async {
    final chatId = generateChatId(
      params.currentUserId, 
      params.userBId,
      );

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
    try{
      print('------------------------------------------');
      print('------------------------------------------');
      print('------------------------------------------');
      print('------------------------------------------');
      print('remote ds');
      print('------------------------------------------');
      print('------------------------------------------');
      print('------------------------------------------');
      print('------------------------------------------');
      final snapshot = await chats
          .where(
            'participants',
            arrayContains: params.userId,
          )
          .get();


      for (final doc in snapshot.docs) {
        print('Document ID: ${doc.id}');
        print(doc.data());
      }

      final result = snapshot.docs
          .map(
            (doc) => ChatModel.fromJson(
              doc.data() as Map<String, dynamic>,
            ),
          )
          .toList();
      print('------------------------------------------');
      print('------------------remote ds 2------------------------');
      print('------------------------------------------');
      print('DOC COUNT: ${snapshot.docs.length}');
      for(final i in result){
        print(i);
      }
      return result;
    } catch (e){
      print('cccccccccccccaaaaaaaaattttttttcccccchhhhh');
      print('cccccccccccccaaaaaaaaattttttttcccccchhhhh');
      print(e);
      print('cccccccccccccaaaaaaaaattttttttcccccchhhhh');
      
      throw e.toString();
    }
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