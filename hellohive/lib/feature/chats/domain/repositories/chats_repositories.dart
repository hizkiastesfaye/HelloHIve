

import 'package:dartz/dartz.dart';
import 'package:hellohive/core/errors/failure.dart';
import 'package:hellohive/feature/chats/chats_core/chats_core.dart';

import '../entities/chats_entities.dart';

abstract class ChatRepository {
  Future<Either<Failure,ActionStatus>> createChat(UsersChatParams params);

  Stream<Either<Failure,List<ChatsEntities>>> watchChats(ChatUserIdParams params);

  Future<Either<Failure,ActionStatus>> deleteChat(ChatIdUserIdParams params);

  Future<Either<Failure,ActionStatus>> muteChat(MuteChatParams params);
}