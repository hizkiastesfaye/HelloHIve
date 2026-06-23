
import 'package:dartz/dartz.dart';
import 'package:dartz/dartz_unsafe.dart';
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

class GetChatUseCase extends UseCase<ChatsEntities, UsersChatParams>{
  final ChatRepository chatRepository;

  GetChatUseCase(this.chatRepository);

  @override
  Future<Either<Failure,ChatsEntities>> call(UsersChatParams params){
    return chatRepository.getChat(params);
  }
}

class GetChatsUseCase extends UseCase<List<ChatsEntities>, UserIdParams>{
  final ChatRepository chatRepository;

  GetChatsUseCase(this.chatRepository);

  @override
  Future<Either<Failure,List<ChatsEntities>>> call(UserIdParams params){
    return chatRepository.getChats(params);
  }
}

class GetChatByIdUseCase extends UseCase<ChatsEntities?, String>{
  final ChatRepository chatRepository;

  GetChatByIdUseCase(this.chatRepository);

  @override
  Future<Either<Failure,ChatsEntities?>> call(String chatId){
    return chatRepository.getChatById(chatId);
  }
}

class UpdateChatUseCase extends UseCase<ActionStatus, MostChatParams>{
  final ChatRepository chatRepository;

  UpdateChatUseCase(this.chatRepository);

  @override
  Future<Either<Failure,ActionStatus>> call(MostChatParams params){
    return chatRepository.updateChat(params);
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

class UpdateLastMessageUseCase extends UseCase<ActionStatus, UpdateLastMessageParams>{
  final ChatRepository chatRepository;

  UpdateLastMessageUseCase(this.chatRepository);

  @override
  Future<Either<Failure,ActionStatus>> call(UpdateLastMessageParams params){
    return chatRepository.updateLastMessage(params);
  }
}

class ChatSyncUsecase extends UseCase<Unit, UserIdParams>{
  final ChatRepository chatRepository;
  ChatSyncUsecase(this.chatRepository);

  @override
  Future<Either<Failure,Unit>> call(UserIdParams params){
    return chatRepository.chatSync(params);
  }
}