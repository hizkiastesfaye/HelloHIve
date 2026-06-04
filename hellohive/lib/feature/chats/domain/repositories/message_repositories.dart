
import 'package:dartz/dartz.dart';
import 'package:hellohive/core/errors/failure.dart';
import 'package:hellohive/core/usecases/usecase.dart';
import 'package:hellohive/feature/chats/chats_core/chats_core.dart';
import 'package:hellohive/feature/chats/domain/entities/message_entities.dart';

abstract class MessageRepo {
  Future<Either<Failure,ActionStatus>> sendMessage(SendMessageParams params);
  Stream<Either<Failure,List<ChatMessageEntities>>> listenMessage(ChatIdParams params);
  Future<Either<Failure,ChatMessageEntities>> getLastMessage(ChatIdParams params);
  Future<Either<Failure,ActionStatus>> editMessage(EditMessageParams params);
  Future<Either<Failure,ActionStatus>> deleteMessage(MessageIdParams params);
  Future<Either<Failure,ActionStatus>> markMessageAsRead(MessageIdParams params);
}