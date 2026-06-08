
import 'package:dartz/dartz.dart';
import 'package:hellohive/core/errors/failure.dart';
import 'package:hellohive/core/network/netowork_info.dart';
import 'package:hellohive/feature/chats/chats_core/chats_core.dart';
import 'package:hellohive/feature/chats/data/dataSources/abstract_local_Ds.dart';
import 'package:hellohive/feature/chats/data/dataSources/abstract_remote_DS.dart';
import 'package:hellohive/feature/chats/domain/entities/chats_entities.dart';
import 'package:hellohive/feature/chats/domain/repositories/chats_repositories.dart';

class ChatsRepoImpl implements ChatRepository {
  final ChatLocalDatasource localDatasource;
  final ChatRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  ChatsRepoImpl({
    required this.localDatasource,
    required this.remoteDatasource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ActionStatus>> createChat(
    UsersChatParams params,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        await remoteDatasource.createChat(params);
        return Right(ActionStatus.success);
      } else {
        await localDatasource.createPendingChat(params);
        return Right(ActionStatus.pending);
      }

      
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, ChatsEntities>> getChat(
    UsersChatParams params,
  ) async {
    try {
        final result = await localDatasource.getChat(params);
        return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
   @override
  Future<Either<Failure, List<ChatsEntities>>> getChats(
    UserIdParams params,
  ) async {
    try {
        final result = await localDatasource.getChats(params);
        return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<ChatsEntities>>> watchChats(
    UserIdParams params,
  ) async* {
    try {
      yield* localDatasource
          .watchChats(params)
          .map((chats) => Right(chats));
    } catch (e) {
      yield Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure,ActionStatus>> deleteChat(ChatIdUserIdParams params) async {
    try {
      if (await networkInfo.isConnected) {
        await remoteDatasource.deleteChat(params);
        return Right(ActionStatus.success);
      } else {
        await localDatasource.deleteChat(params);
        return Right(ActionStatus.pending);
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure,ActionStatus>> muteChat(MuteChatParams params) async {
    try {
      if (await networkInfo.isConnected) {
        await remoteDatasource.muteChat(params);
        return Right(ActionStatus.success);
      } else {
        await localDatasource.muteChat(params);
        return Right(ActionStatus.pending);
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}