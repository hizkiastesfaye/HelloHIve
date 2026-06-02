
import 'package:hellohive/feature/chats/data/models/chats_model.dart';

import '../models/message_model.dart';


abstract class ChatRemoteDatasource {

  Future<void> createChat(
    ChatModel chat,
  );

  Stream<List<ChatModel>> watchChats(
    String userId,
  );

  Future<void> deleteChat({
    required String chatId,
    required String userId,
  });

  Future<void> muteChat({
    required String chatId,
    required String userId,
    required bool isMuted,
  });
}


abstract class MessageRemoteDatasource {

  Future<void> sendMessage(
    ChatMessageModel message,
  );

  Stream<List<ChatMessageModel>>
    listenMessages(
    String chatId,
  );

  Future<ChatMessageModel?> getLastMessage(
    String chatId,
  );

  Future<void> editMessage({
    required String messageId,
    required String text,
  });

  Future<void> deleteMessage({
    required String messageId,
    required String userId,
  });

  Future<void> markMessageAsRead({
    required String messageId,
  });

  //   Future<List<ChatMessageModel>>
  //     getMessages({
  //   required String chatId,
  //   String? lastMessageId,
  //   int limit = 20,
  // });
}