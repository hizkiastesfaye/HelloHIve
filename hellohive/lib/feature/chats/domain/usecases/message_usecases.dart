import 'package:dartz/dartz.dart';

import '../entities/message_entities.dart';
import 'package:hellohive/core/errors/failure.dart';
import 'package:hellohive/core/usecases/usecase.dart';
import 'package:hellohive/feature/chats/chats_core/chats_core.dart';

import '../repositories/message_repositories.dart';

class SendMessageUseCase extends UseCase<Unit,SendMessageParams>{
    final MessageRepo messageRepo;
    SendMessageUseCase(this.messageRepo);

    @override 
    Future<Either<Failure,Unit>> call(SendMessageParams params){
        return messageRepo.sendMessage(params);
    }
}
class ListenMessagesUseCase extends UseCaseStream<List<ChatMessageEntities>,ChatIdParams>{
    final MessageRepo messageRepo;
    ListenMessagesUseCase(this.messageRepo);

    @override 
    Stream<Either<Failure,List<ChatMessageEntities>>> call(ChatIdParams params){
        return messageRepo.listenMessage(params);
    }
}
class GetLastMessageUseCase extends UseCase<ChatMessageEntities,NoParams>{
    final MessageRepo messageRepo;
    GetLastMessageUseCase(this.messageRepo);

    @override 
    Future<Either<Failure,ChatMessageEntities>> call(NoParams noParams){
        return messageRepo.getLastMessage(noParams);
    }
}
class EditMessageUseCase extends UseCase<Unit, EditMessageParams>{
    final MessageRepo messageRepo;
    EditMessageUseCase(this.messageRepo);

    @override 
    Future<Either<Failure,Unit>> call(EditMessageParams params){
        return messageRepo.editMessage(params);
    }
}
class MarkMessageAsReadUseCase extends UseCase<Unit, MessageIdParams>{
    final MessageRepo messageRepo;
    MarkMessageAsReadUseCase(this.messageRepo);

    @override 
    Future<Either<Failure,Unit>> call(MessageIdParams params){
        return messageRepo.markMessageAsRead(params);
    }
}
class DeleteMessageUseCase extends UseCase<Unit,MessageIdParams>{
    final MessageRepo messageRepo;
    DeleteMessageUseCase(this.messageRepo);

    @override 
    Future<Either<Failure,Unit>> call(MessageIdParams params){
        return messageRepo.deleteMessage(params);
    }
}



// class RetryFailedMessageUseCase extends UseCase<UsersChatParams, Unit>{
//     final MessageRepo messageRepo;
//     RetryFailedMessageUseCase(this.messageRepo);

//     @override 
//     Future<Either<Failure,ChatMessageEntities>> call(UsersChatParams params){
//         return messageRepo.Message(parmas);
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
