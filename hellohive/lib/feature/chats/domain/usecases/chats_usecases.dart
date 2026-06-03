
import 'package:dartz/dartz.dart';
import 'package:hellohive/core/errors/failure.dart';
import 'package:hellohive/core/usecases/usecase.dart';
import 'package:hellohive/feature/chats/chats_core/chats_core.dart';
import 'package:hellohive/feature/chats/domain/entities/chats_entities.dart';
import 'package:hellohive/feature/chats/domain/repositories/chats_repositories.dart';

class CreateChatUseCase extends UseCase<Unit, UsersChatParams>{
  final ChatRepository chatRepository;

  CreateChatUseCase(this.chatRepository);

  @override
  Future<Either<Failure,Unit>> call(UsersChatParams params){
    return chatRepository.createChat(params);
  }
}

class WatchChatsUseCase extends UseCaseStream<List<ChatsEntities>, ChatUserIdParams>{
  final ChatRepository chatRepository;

  WatchChatsUseCase(this.chatRepository);
  @override
  Stream<Either<Failure, List<ChatsEntities>>> call(ChatUserIdParams params){
    return chatRepository.watchChats(params);
  }

}

class DeleteChatUseCase extends UseCase<Unit, ChatIdUserIdParams>{
  final ChatRepository chatRepository;

  DeleteChatUseCase(this.chatRepository);

  @override
  Future<Either<Failure,Unit>> call(ChatIdUserIdParams params){
    return chatRepository.deleteChat(params);
  }
}

class MuteChatUseCase extends UseCase<Unit, MuteChatParams>{
  final ChatRepository chatRepository;

  MuteChatUseCase(this.chatRepository);

  @override
  Future<Either<Failure,Unit>> call(MuteChatParams params){
    return chatRepository.muteChat(params);
  }
}