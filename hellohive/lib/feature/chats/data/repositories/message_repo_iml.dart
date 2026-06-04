
import 'package:dartz/dartz.dart';
import 'package:hellohive/core/errors/failure.dart';
import 'package:hellohive/core/network/netowork_info.dart';
import 'package:hellohive/feature/chats/data/dataSources/abstract_local_Ds.dart';
import 'package:hellohive/feature/chats/data/dataSources/abstract_remote_DS.dart';

import '../../chats_core/chats_core.dart';
import '../../domain/repositories/message_repositories.dart';

class MessageRepoImpl implements MessageRepo{
  final MessageLocalDatasource localDatasource;
  final MessageRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  MessageRepoImpl({
    required this.localDatasource,
    required this.remoteDatasource,
    required this.networkInfo,
  });
  @override
   Future<Either<Failure,ActionStatus>> sendMessage(SendMessageParams params) async {
    try {
      if (await networkInfo.isConnected) {
        final result = await remoteDatasource.sendMessage(params);
        return Right(result);
      } else {
        final result = await localDatasource.sendMessage(params);
        return Right(result);
      }
      
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure,List<ChatMessageEntities>>> listenMessage(ChatIdParams params) {
    // Implementation for listening to messages
  }

  @override
  Future<Either<Failure,ChatMessageEntities>> getLastMessage(ChatIdParams params) {
    // Implementation for getting the last message
  }

  @override
  Future<Either<Failure,Unit>> editMessage(EditMessageParams params) {
    // Implementation for editing a message
  }

  @override
  Future<Either<Failure,Unit>> deleteMessage(MessageIdParams params) {
    // Implementation for deleting a message
  }
  @override
  Future<Either<Failure,Unit>> markMessageAsRead(MessageIdParams params) {
    // Implementation for marking a message as read
  }
}