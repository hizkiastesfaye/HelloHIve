
import 'package:hellohive/feature/chats/chats_core/chats_core.dart';
import 'package:hellohive/feature/chats/data/models/chats_model.dart';

import '../models/message_model.dart';


abstract class ChatRemoteDatasource {

  Future<ActionStatus> createChat(
    UsersChatParams params,
  );

  Stream<List<ChatModel>> watchChats(
    String userId,
  );

  Future<ActionStatus> deleteChat(ChatIdUserIdParams params);

  Future<ActionStatus> muteChat(MuteChatParams params);
}


abstract class MessageRemoteDatasource {

  Future<ActionStatus> sendMessage(SendMessageParams params);

  Stream<List<ChatMessageModel>>
    listenMessages(
    String chatId,
  );

  Future<ChatMessageModel?> getLastMessage(
    String chatId,
  );

  Future<ActionStatus> editMessage({
    required String messageId,
    required String text,
  });

  Future<ActionStatus> deleteMessage({
    required String messageId,
    required String userId,
  });

  Future<ActionStatus> markMessageAsRead({
    required String messageId,
  });

  //   Future<List<ChatMessageModel>>
  //     getMessages({
  //   required String chatId,
  //   String? lastMessageId,
  //   int limit = 20,
  // });
}