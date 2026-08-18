import 'package:firebase_auth/firebase_auth.dart';
import 'package:hellohive/core/usecases/usecase.dart';
import 'package:hellohive/feature/chats/chats_core/chats_core.dart';
import 'package:hellohive/feature/chats/domain/usecases/chats_usecases.dart';
import 'package:hellohive/feature/friends/domain/usecases/friends_sync_usecase.dart';

class AppInitializer {
  // final SyncFriendsUseCase syncFriendsUseCase;
  // final DisposeFriendSyncUseCase disposeFriendSyncUseCase;
  final ChatSyncUsecase chatSyncUsecase;

  AppInitializer({
    // required this.syncFriendsUseCase,
    // required this.disposeFriendSyncUseCase,
    required this.chatSyncUsecase,
  });

  Future<void> start() async {
    // await syncFriendsUseCase(NoParams());
   final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return;
  }

  await chatSyncUsecase(
    UserIdParams(userId: user.uid),
  );
  }

  Future<void> stop() async {
    // await disposeFriendSyncUseCase(NoParams());
  }
}