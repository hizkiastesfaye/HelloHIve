

import 'package:dartz/dartz.dart';
import 'package:hellohive/core/errors/failure.dart';
import 'package:hellohive/feature/chats/chats_core/chats_core.dart';

import '../entities/chats_entities.dart';

abstract class ChatRepository {
  Future<Either<Failure,ActionStatus>> createChat(UsersChatParams params);
  Future<Either<Failure,ChatsEntities>> getChat(UsersChatParams params);
  Future<Either<Failure,List<ChatsEntities>>> getChats(UserIdParams params);
  Future<Either<Failure,ChatsEntities?>> getChatById(String chatId);
  Future<Either<Failure,ActionStatus>> updateChat(MostChatParams params);
  Stream<Either<Failure,List<ChatsEntities>>> watchChats(UserIdParams params);

  Future<Either<Failure,ActionStatus>> deleteChat(ChatIdUserIdParams params);

  Future<Either<Failure,ActionStatus>> muteChat(MuteChatParams params);
  Future<Either<Failure,ActionStatus>> updateLastMessage(UpdateLastMessageParams params,);
  Future<Either<Failure,Unit>> chatSync(UserIdParams params);
}