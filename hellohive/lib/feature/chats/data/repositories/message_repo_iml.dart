import 'package:dartz/dartz.dart';
import 'package:hellohive/core/errors/failure.dart';
import 'package:hellohive/core/network/netowork_info.dart';
import 'package:hellohive/feature/chats/chats_core/chats_core.dart';
import 'package:hellohive/feature/chats/chats_core/chats_message_core.dart';
import 'package:hellohive/feature/chats/data/dataSources/abstract_message_local_DS.dart';
import 'package:hellohive/feature/chats/data/dataSources/abstract_message_remote_DS.dart';
import 'package:hellohive/feature/chats/domain/entities/message_entities.dart';
import 'package:hellohive/feature/chats/domain/repositories/message_repositories.dart';

class MessageRepoImpl implements MessageRepo {
  final MessageLocalDS localDatasource;
  final MessageRemoteDS remoteDatasource;
  final NetworkInfo networkInfo;

  MessageRepoImpl({
    required this.localDatasource,
    required this.remoteDatasource,
    required this.networkInfo,
  });

  // ============================================================
  // SEND MESSAGE
  // ============================================================

  @override
  Future<Either<Failure, ActionStatus>> sendMessage(
    SendMessageParams params,
  ) async {
    try {
      print('1message sent to repository');
      final message =
          await localDatasource.createPendingMessage(params);
      print('2message sent to repository');

      if (!await networkInfo.isConnected) {
      print('3message sent to repository');

        return const Right(ActionStatus.pending);
      }

      try {
      print('4message sent to repository');

        await remoteDatasource.sendMessage(params);

        await localDatasource.markMessageAsSent(
          message.id,
        );

        // IMPORTANT:
        // Don't remove by messageId.
        // Pending-operation handling should be done
        // by the sync service using operation.id.
        return const Right(ActionStatus.success);
      } catch (_) {
        return const Right(ActionStatus.pending);
      }
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  // ============================================================
  // LISTEN
  // ============================================================

  @override
  Stream<Either<Failure, List<ChatMessageEntities>>>
      listenMessages(
    ChatIdParams params,
  ) async* {
    try {
      yield* localDatasource
          .listenMessages(params)
          .map(
            (messages) =>
                Right<Failure, List<ChatMessageEntities>>(
              messages,
            ),
          );
    } catch (e) {
      yield Left(CacheFailure(e.toString()));
    }
  }

  // ============================================================
  // GET LAST MESSAGE
  // ============================================================

  @override
  Future<Either<Failure, ChatMessageEntities>>
      getLastMessage(
    ChatIdParams params,
  ) async {
    try {
      final message =
          await localDatasource.getLastMessage(params);

      return Right(message);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  // ============================================================
  // EDIT
  // ============================================================

  @override
  Future<Either<Failure, ActionStatus>> editMessage(
    EditMessageParams params,
  ) async {
    try {
      // Always update Hive first.
      await localDatasource.editMessage(params);

      if (!await networkInfo.isConnected) {
        return const Right(ActionStatus.pending);
      }

      try {
        await remoteDatasource.editMessage(params);

        return const Right(ActionStatus.success);
      } catch (_) {
        return const Right(ActionStatus.pending);
      }
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  // ============================================================
  // DELETE
  // ============================================================

  @override
  Future<Either<Failure, ActionStatus>> deleteMessage(
    DeleteMessageParams params,
  ) async {
    try {
      print('1message repo delete message');
      await localDatasource.deleteMessage(params);

      if (!await networkInfo.isConnected) {
      print('2message repo delete message');

        return const Right(ActionStatus.pending);
      }

      try {
      print('3message repo delete message');

        await remoteDatasource.deleteMessage(params);
      print('4message repo delete message');

        return const Right(ActionStatus.success);
      } catch (_) {
      print('5message repo delete message');

        return const Right(ActionStatus.pending);
      }
    } catch (e) {
      print('6message repo delete message');

      return Left(CacheFailure(e.toString()));
    }
  }

  // ============================================================
  // MARK READ
  // ============================================================

  @override
  Future<Either<Failure, ActionStatus>>
      markMessageAsRead(
    MarkMessageAsReadParams params,
  ) async {
    try {
      await localDatasource.markMessageAsRead(params);

      if (!await networkInfo.isConnected) {
        return const Right(ActionStatus.pending);
      }

      try {
        await remoteDatasource.markMessageAsRead(params);

        return const Right(ActionStatus.success);
      } catch (_) {
        return const Right(ActionStatus.pending);
      }
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}