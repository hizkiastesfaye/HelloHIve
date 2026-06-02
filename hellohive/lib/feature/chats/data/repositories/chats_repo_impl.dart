
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
  Future<Either<Failure,Unit>> createChat(UsersChatParams params) async {
    if (await networkInfo.isConnected) {
      try{
        
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Stream<Either<Failure,List<ChatsEntities>>> watchChats(ChatUserIdParams params) async* {
    try {
      yield* remoteDatasource.watchChats(params.userId).map((chats) => Right(chats.map((chat) => chat.toEntity()).toList()));
    } catch (e) {
      yield Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure,Unit>> deleteChat(UsersChatParams params) async {
    try {
      await remoteDatasource.deleteChat(chatId: params.chatId, userId: params.userId);
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