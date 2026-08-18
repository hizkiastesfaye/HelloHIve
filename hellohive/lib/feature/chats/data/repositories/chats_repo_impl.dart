
import 'package:dartz/dartz.dart';
import 'package:hellohive/core/errors/failure.dart';
import 'package:hellohive/core/network/netowork_info.dart';
import 'package:hellohive/feature/chats/chats_core/chats_core.dart';
import 'package:hellohive/feature/chats/data/dataSources/abstract_local_Ds.dart';
import 'package:hellohive/feature/chats/data/dataSources/abstract_remote_DS.dart';
import 'package:hellohive/feature/chats/data/dataSources/chat_sync_service.dart';
import 'package:hellohive/feature/chats/domain/entities/chats_entities.dart';
import 'package:hellohive/feature/chats/domain/repositories/chats_repositories.dart';

class ChatsRepoImpl implements ChatRepository {
  final ChatLocalDatasource localDatasource;
  final ChatRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  final ChatSyncServiceFromLocalToRemote syncFromLToR;
  final ChatSyncServiceFromRemoteToLocal syncFromRtoL;

  ChatsRepoImpl({
    required this.localDatasource,
    required this.remoteDatasource,
    required this.networkInfo,
    required this.syncFromLToR,
    required this.syncFromRtoL
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
        if(result.isEmpty || result == null){
          print('nuuuuuuuuuuuuuuuuuuuuuuuuuuuuul');
        }
        print(')))))))))))))))))))))');
        print(')))))))))))))))))))))');
        print(result.isEmpty);
        for(final i in result){
          print(i.id);
        }
        print(')))))))))))))))))))))');
        print(')))))))))))))))))))))');
        return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatsEntities?>> getChatById(String chatId) async {
    try {
      final result = await localDatasource.getChatById(chatId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ActionStatus>> updateChat(
    MostChatParams params,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        await remoteDatasource.updateChat(params);
        return Right(ActionStatus.success);
      } else {
        await localDatasource.updateChat(params);
        return Right(ActionStatus.pending);
      }
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
  @override
  Future<Either<Failure,ActionStatus>> updateLastMessage(UpdateLastMessageParams params,) async {
    try {
      if (await networkInfo.isConnected) {
        await remoteDatasource.updateLastMessage(params);
        return Right(ActionStatus.success);
      } else {
        await localDatasource.updateLastMessage(params);
        return Right(ActionStatus.pending);
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> chatSync(
    UserIdParams params,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        print('------------------------------------------');
        print('------------------------------------------');
        print('------------------------------------------');
        print('-----------sync repo------------');
        print('------------------------------------------');
        print('------------------------------------------');
        print('------------------------------------------');
        print('------------------------------------------');
        print('------------------------------------------');
        await syncFromRtoL.getChatsFromRemote(params);
        await syncFromLToR.syncChats();
        
        return const Right(unit);
      }

      return Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}