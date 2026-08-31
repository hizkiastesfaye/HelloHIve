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

      final chatId = generateChatId(currentUser!.uid, params.userBId);
      final chatDoc = chats.doc(chatId);
      // final existDoc = await chatDoc.get();
      final Map<String,bool> stat = {currentUser!.uid:false,params.userBId:false};
      final chatData = {
        'id':chatId,
        'participants':[currentUser!.uid, params.userBId],
        'unreadCount': {
          currentUser!.uid: 0,
          params.userBId: 0
        },
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
      print('${currentUser!.uid} and ${params.userBId} ');
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
    print('!!!!!!!!!!!!!!!!!!!!!11');
    print(currentUser!.uid);
    print('!!!!!!!!!!!!!!!!!!!!!11');
    final chatId = generateChatId(
      currentUser!.uid, 
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
      final firebaseUser = FirebaseAuth.instance.currentUser;

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
      for(final i in result){
        print(i);
      }
      return result;
    } catch (e){
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
    final docRef = chats.doc(params.chatId);
    final doc = await docRef.get();
    if (!doc.exists) {
      return ActionStatus.failed;
    }
  
    final chat = ChatModel.fromJson(
      doc.data() as Map<String, dynamic>,
    );

    chat.deletedBy[currentUser!.uid] = true;

    final allDeleted = chat.deletedBy.values.every((value) => value);

    if (allDeleted) {
      await docRef.delete();
    }
    else{
      await docRef.update({
      'deletedBy.${currentUser!.uid}': true,
      'updatedAt': FieldValue.serverTimestamp(),
      });
    }
    return ActionStatus.success;
  }
  @override
  Future<ActionStatus> muteChat(
    MuteChatParams params,
  ) async {
    await chats.doc(params.chatId).update({
      'mutedBy.${currentUser!.uid}': params.isMuted,
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