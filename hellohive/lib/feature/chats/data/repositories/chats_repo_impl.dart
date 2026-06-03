
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
  Future<Either<Failure, Unit>> createChat(
    UsersChatParams params,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        await remoteDatasource.createChat(params);
      } else {
        await localDatasource.createPendingChat(params);
      }

      return Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<ChatsEntities>>> watchChats(
    ChatUserIdParams params,
  ) async* {
    try {
      yield* localDatasource
          .watchChats(params.userId)
          .map((chats) => Right(chats));
    } catch (e) {
      yield Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure,Unit>> deleteChat(ChatIdUserIdParams params) async {
    try {
      if (await networkInfo.isConnected) {
        await remoteDatasource.deleteChat(params);
      } else {
        await localDatasource.deleteChat(params);
      }

      return Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure,Unit>> muteChat(MuteChatParams params) async {
    try {
      await remoteDatasource.muteChat(chatId: params.chatId, userId: params.userId, isMuted: params.isMuted);
      return Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}