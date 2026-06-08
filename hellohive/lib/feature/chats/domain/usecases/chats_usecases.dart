
import 'package:dartz/dartz.dart';
import 'package:hellohive/core/errors/failure.dart';
import 'package:hellohive/core/usecases/usecase.dart';
import 'package:hellohive/feature/chats/chats_core/chats_core.dart';
import 'package:hellohive/feature/chats/domain/entities/chats_entities.dart';
import 'package:hellohive/feature/chats/domain/repositories/chats_repositories.dart';

class CreateChatUseCase extends UseCase<ActionStatus, UsersChatParams>{
  final ChatRepository chatRepository;

  CreateChatUseCase(this.chatRepository);

  @override
  Future<Either<Failure,ActionStatus>> call(UsersChatParams params){
    return chatRepository.createChat(params);
  }
}

class WatchChatsUseCase extends UseCaseStream<List<ChatsEntities>, UserIdParams>{
  final ChatRepository chatRepository;

  WatchChatsUseCase(this.chatRepository);
  @override
  Stream<Either<Failure, List<ChatsEntities>>> call(UserIdParams params){
    return chatRepository.watchChats(params);
  }

}

class DeleteChatUseCase extends UseCase<ActionStatus, ChatIdUserIdParams>{
  final ChatRepository chatRepository;

  DeleteChatUseCase(this.chatRepository);

  @override
  Future<Either<Failure,ActionStatus>> call(ChatIdUserIdParams params){
    return chatRepository.deleteChat(params);
  }
}

class MuteChatUseCase extends UseCase<ActionStatus, MuteChatParams>{
  final ChatRepository chatRepository;

  MuteChatUseCase(this.chatRepository);

  @override
  Future<Either<Failure,ActionStatus>> call(MuteChatParams params){
    return chatRepository.muteChat(params);
  }
}