
import 'package:equatable/equatable.dart';

class UsersChatParams extends Equatable{
  final String currentUserId;
  final String userBId;

  UsersChatParams({
    required this.currentUserId,
    required this.userBId
  });
  @override
  List<Object> get props => [currentUserId,userBId];
}

class ChatUserIdParams extends Equatable{
  final String userId;

  ChatUserIdParams({

    required this.userId
  });
  @override
  List<Object> get props => [userId];
}

class MuteChatParams extends Equatable{
  final String currentUserId;
  final String userBId;
  final bool isMuted;

  MuteChatParams({
    required this.currentUserId,
    required this.userBId,
    required this.isMuted,
  });
  @override
  List<Object> get props => [currentUserId,userBId,isMuted];
}