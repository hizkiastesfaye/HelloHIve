import 'package:hellohive/core/usecases/usecase.dart';
import 'package:hellohive/feature/friends/domain/usecases/friends_sync_usecase.dart';

class AppInitializer {
  final SyncFriendsUseCase syncFriendsUseCase;
  final DisposeFriendSyncUseCase disposeFriendSyncUseCase;

  AppInitializer({
    required this.syncFriendsUseCase,
    required this.disposeFriendSyncUseCase,
  });

  Future<void> start() async {
    await syncFriendsUseCase(NoParams());
  }

  Future<void> stop() async {
    await disposeFriendSyncUseCase(NoParams());
  }
}