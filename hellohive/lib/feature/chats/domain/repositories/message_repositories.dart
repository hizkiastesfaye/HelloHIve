import 'package:dartz/dartz.dart';
import 'package:hellohive/core/errors/failure.dart';
import 'package:hellohive/feature/chats/chats_core/chats_core.dart';
import 'package:hellohive/feature/chats/chats_core/chats_message_core.dart';
import 'package:hellohive/feature/chats/domain/entities/message_entities.dart';


abstract class MessageRepo {
  Future<Either<Failure, ActionStatus>> sendMessage(
    SendMessageParams params,
  );

  Stream<Either<Failure, List<ChatMessageEntities>>> listenMessages(
    ChatIdParams params,
  );

  Future<Either<Failure, ChatMessageEntities>> getLastMessage(
    ChatIdParams params,
  );

  Future<Either<Failure, ActionStatus>> editMessage(
    EditMessageParams params,
  );

  Future<Either<Failure, ActionStatus>> deleteMessage(
    DeleteMessageParams params,
  );

  Future<Either<Failure, ActionStatus>> markMessageAsRead(
    MarkMessageAsReadParams params,
  );
}