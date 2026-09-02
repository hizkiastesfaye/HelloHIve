import 'package:dartz/dartz.dart';
import 'package:hellohive/core/errors/failure.dart';
import 'package:hellohive/core/usecases/usecase.dart';
import 'package:hellohive/feature/chats/chats_core/chats_core.dart';
import 'package:hellohive/feature/chats/chats_core/chats_message_core.dart';
import 'package:hellohive/feature/chats/domain/entities/message_entities.dart';
import 'package:hellohive/feature/chats/domain/repositories/message_repositories.dart';

class SendMessageUseCase
    extends UseCase<ActionStatus, SendMessageParams> {
  final MessageRepo messageRepo;

  SendMessageUseCase(this.messageRepo);

  @override
  Future<Either<Failure, ActionStatus>> call(
    SendMessageParams params,
  ) {
    print('send usercaw4e');
    return messageRepo.sendMessage(params);
  }
}

class ListenMessagesUseCase
    extends UseCaseStream<
        List<ChatMessageEntities>,
        ChatIdParams> {
  final MessageRepo messageRepo;

  ListenMessagesUseCase(this.messageRepo);

  @override
  Stream<Either<Failure, List<ChatMessageEntities>>> call(
    ChatIdParams params,
  ) {
    return messageRepo.listenMessages(params);
  }
}

class GetLastMessageUseCase
    extends UseCase<ChatMessageEntities, ChatIdParams> {
  final MessageRepo messageRepo;

  GetLastMessageUseCase(this.messageRepo);

  @override
  Future<Either<Failure, ChatMessageEntities>> call(
    ChatIdParams params,
  ) {
    return messageRepo.getLastMessage(params);
  }
}

class EditMessageUseCase
    extends UseCase<ActionStatus, EditMessageParams> {
  final MessageRepo messageRepo;

  EditMessageUseCase(this.messageRepo);

  @override
  Future<Either<Failure, ActionStatus>> call(
    EditMessageParams params,
  ) {
    return messageRepo.editMessage(params);
  }
}

class DeleteMessageUseCase
    extends UseCase<ActionStatus, DeleteMessageParams> {
  final MessageRepo messageRepo;

  DeleteMessageUseCase(this.messageRepo);

  @override
  Future<Either<Failure, ActionStatus>> call(
    DeleteMessageParams params,
  ) {
    return messageRepo.deleteMessage(params);
  }
}

class MarkMessageAsReadUseCase
    extends UseCase<ActionStatus, MarkMessageAsReadParams> {
  final MessageRepo messageRepo;

  MarkMessageAsReadUseCase(this.messageRepo);

  @override
  Future<Either<Failure, ActionStatus>> call(
    MarkMessageAsReadParams params,
  ) {
    return messageRepo.markMessageAsRead(params);
  }
}


// class RetryFailedMessageUseCase extends UseCase<UsersChatParams, Unit>{
//     final MessageRepo messageRepo;
//     RetryFailedMessageUseCase(this.messageRepo);

//     @override 
//     Future<Either<Failure,ChatMessageEntities>> call(UsersChatParams params){
//         return messageRepo.retryFailedMessageUseCase(parmas);
//     }
// }
// class LoadMoreMessagesUseCase extends UseCase<UsersChatParams, Unit>{
//     final MessageRepo messageRepo;
//     LoadMoreMessagesUseCase(this.messageRepo);

//     @override 
//     Future<Either<Failure,ChatMessageEntities>> call(UsersChatParams params){
//         return messageRepo.Message(parmas);
//     }
// }
// class UploadMediaMessageUseCase extends UseCase<UsersChatParams, Unit>{
//     final MessageRepo messageRepo;
//     UploadMediaMessageUseCase(this.messageRepo);

//     @override 
//     Future<Either<Failure,ChatMessageEntities>> call(UsersChatParams params){
//         return messageRepo.Message(parmas);
//     }
// }
