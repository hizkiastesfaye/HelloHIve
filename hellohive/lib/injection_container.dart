import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:hellohive/core/app_initialize.dart';
import 'package:hellohive/core/network/netowork_info.dart';
import 'package:hellohive/feature/auth/data/dataSources/auth_remote_data_source.dart';
import 'package:hellohive/feature/auth/data/repositories/auth_repositories_impl.dart';
import 'package:hellohive/feature/auth/domain/repositories/auth_repositories.dart';
import 'package:hellohive/feature/auth/domain/usecases/auth_usecases.dart';
import 'package:hellohive/feature/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:hellohive/feature/chats/data/dataSources/abstract_local_Ds.dart';
import 'package:hellohive/feature/chats/data/dataSources/abstract_remote_DS.dart';
import 'package:hellohive/feature/chats/data/dataSources/chat_sync_service.dart';
import 'package:hellohive/feature/chats/data/dataSources/chats_local_DS.dart';
import 'package:hellohive/feature/chats/data/dataSources/chats_remote_DS.dart';
import 'package:hellohive/feature/chats/data/models/hive_model.dart';
import 'package:hellohive/feature/chats/data/repositories/chats_repo_impl.dart';
import 'package:hellohive/feature/chats/domain/repositories/chats_repositories.dart';
import 'package:hellohive/feature/chats/domain/usecases/chats_usecases.dart';
import 'package:hellohive/feature/chats/presentation/bloc/chats/chats_bloc.dart';
import 'package:hellohive/feature/friends/data/datasources/friends_local_DS.dart';
import 'package:hellohive/feature/friends/data/datasources/friends_remote_DS.dart';
import 'package:hellohive/feature/friends/data/datasources/friends_sync_service.dart';
import 'package:hellohive/feature/friends/data/models/friends_hive_model.dart';
import 'package:hellohive/feature/friends/data/repositories/friend_sync_repo_impl.dart';
import 'package:hellohive/feature/friends/data/repositories/friends_repo_impl.dart';
import 'package:hellohive/feature/friends/domain/repositories/friend_sync_repo.dart';
import 'package:hellohive/feature/friends/domain/repositories/friends_repo.dart';
import 'package:hellohive/feature/friends/domain/usecases/friends_sync_usecase.dart';
import 'package:hellohive/feature/friends/domain/usecases/friends_usecases.dart';
import 'package:hellohive/feature/friends/presentation/bloc/friends_bloc.dart';
import 'package:hellohive/feature/settings/data/dataSources/user_profile_local.dart';
import 'package:hellohive/feature/settings/data/dataSources/user_profile_remote.dart';
import 'package:hellohive/feature/settings/data/repositories/user_profile_repo_iml.dart';
import 'package:hellohive/feature/settings/domain/repositories/user_profile_repo.dart';
import 'package:hellohive/feature/settings/domain/usecases/user_profile_useCase.dart';
import 'package:hellohive/feature/settings/presentation/bloc/user_profile_bloc_bloc.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.I;

Future<void> init() async{

  //!App Initializer
  sl.registerLazySingleton(()=>AppInitializer(
    chatSyncUsecase: sl(),
    syncFriendsUseCase: sl(),
    disposeFriendSyncUseCase: sl()
  ));

  //!core
  sl.registerLazySingleton<NetworkInfo>(()=>NetworkInfoImpl(sl()));

  //!External
  sl.registerLazySingleton(()=>InternetConnectionChecker());
  sl.registerLazySingleton(()=>FirebaseAuth.instance);
  sl.registerLazySingleton(()=>FirebaseFirestore.instance);
  sl.registerLazySingleton(()=>FirebaseDatabase.instance);
  final sharedInstance = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(()=>sharedInstance);
  sl.registerLazySingleton<Box<ChatHiveModel>>(
    () => Hive.box<ChatHiveModel>('chatBox'),
  );

  sl.registerLazySingleton<Box<ChatSyncOperation>>(
    () => Hive.box<ChatSyncOperation>('operationsBox'),
  );

  sl.registerLazySingleton<Box<FriendsHiveModel>>(
    () => Hive.box<FriendsHiveModel>('friendsBox'),
  );

  //! Features - Auth
  //? Auth Bloc
  sl.registerFactory(()=>AuthBloc(
    signInUsecase: sl(),
    signUpUsecase: sl(),
    signOutUsecase: sl(),
    emailVerifiedUsecase: sl(),
    verifyEmailUsecase: sl(),
    resetPasswordUsecase: sl(),
  ));


  //? Auth Usecases
  sl.registerLazySingleton(()=>SignInUsecase(sl()));
  sl.registerLazySingleton(()=>SignUpUsecase(sl()));
  sl.registerLazySingleton(()=>SignOutUsecase(sl()));
  sl.registerLazySingleton(()=>VerifyEmailUsecase(sl()));
  sl.registerLazySingleton(()=>EmailVerifiedUsecase(sl()));
  sl.registerLazySingleton(()=>ResetPasswordUsecase(sl()));
  sl.registerLazySingleton(()=>UpdatePasswordUsecase(sl()));

  //? Auth Repositories
  sl.registerLazySingleton<AuthRepositories>(
    ()=>AuthRepositoriesImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    )
  );
  //? Auth Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    ()=>AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      firebaseFirestore: sl(),
      firebaseDatabase: sl(),
    )
  );



  //! Features - Settings
  //? User Profile Bloc
  sl.registerFactory(()=>UserProfileBlocBloc(
    getUserProfileUsecase: sl(),
    addUserProfileUsecase: sl(),
    updateUserProfileUsecase: sl(),
    updateSingleUserProfileUsecase: sl(),
    deletUserProfileUsecase: sl(),
    getUserStatusUsecase: sl()
  ));

  //? User Profile Usecases
  sl.registerLazySingleton(()=>GetUserProfileUsecase(sl()));
  sl.registerLazySingleton(()=>AddUserProfileUsecase(sl()));
  sl.registerLazySingleton(()=>UpdateUserProfileUsecase(sl()));
  sl.registerLazySingleton(()=>UpdateSingleUserProfileUsecase(sl()));
  sl.registerLazySingleton(()=>DeletUserProfileUsecase(sl()));
  sl.registerLazySingleton(()=>GetUserStatusUsecase(sl()));

  //? User Profile Repositories
  sl.registerLazySingleton<UserProfileRepo>(
    ()=>UserProfileRepoImpl(
      userProfileRemote: sl(),
      networkInfo: sl(),
      userProfileLocal: sl()
    )
  );

  //? User Profile Data Sources
  sl.registerLazySingleton<UserProfileRemote>(
    ()=>UserProfileRemoteImpl(
      firebaseFirestore: sl(),
      firebaseDatabase: sl(),
    )
  );
  sl.registerLazySingleton<UserProfileLocal>(
    ()=>UserProfileLocalImpl()
  );


  
  //! Features - Friends
  
  //? Friends Bloc
  sl.registerFactory(()=>FriendsBloc(
    getFriendsUseCases: sl(), 
    getRandomFriendsUseCases: sl()));

  //? Friends Usecases
  sl.registerLazySingleton(()=>GetFriendsUseCases(sl()));
  sl.registerLazySingleton(()=>GetFriendUseCases(sl()));
  sl.registerLazySingleton(()=>GetFriendsByListIdUsecases(sl()));
  sl.registerLazySingleton(()=>GetRandomFriendsUseCases(sl()));
  sl.registerLazySingleton(()=>SyncFriendsUseCase(sl()));
  sl.registerLazySingleton(()=>DisposeFriendSyncUseCase(sl()));

  //? Friends Repositories
  sl.registerLazySingleton<FriendsRepo>(()=>FriendsRepoImpl(
    networkInfo: sl(), 
    friendsLocal: sl(), 
    friendsRemote: sl()));
  sl.registerLazySingleton<FriendsSyncRepository>(
    () => FriendsSyncRepositoryImpl(
      syncService: sl(),
    ),
  );

  //? Friends Data Sources
  sl.registerLazySingleton<FriendsLocalDS>(
    ()=>FriendsLocalDsImpl(
      friendsBox: sl(),
      sharedPreferences: sl()
      )
    );
  sl.registerLazySingleton<FriendsRemoteDS>(()=>FriendsRemoteDsImpl(sl()));
  sl.registerLazySingleton<FriendSyncService>(() => FriendSyncServiceImpl(
    localDatasource: sl(),
    remoteDatasource: sl(),
  ));

  //! Features - Chats
  //? Chats Bloc
  sl.registerFactory(()=>ChatsBloc(
    createChatUseCase: sl(),
    getChatUseCase: sl(),
    getChatsUseCase: sl(),
    getChatByIdUseCase: sl(),
    watchChatsUseCase: sl(),
    updateChatUseCase: sl(),
    deleteChatUseCase: sl(),
    muteChatUseCase: sl(),
    updateLastMessageUseCase: sl(),
    chatSyncUsecase: sl()
  ));

  //? Chats Usecases
  sl.registerLazySingleton(()=>CreateChatUseCase(sl())); 
  sl.registerLazySingleton(()=>GetChatUseCase(sl()));
  sl.registerLazySingleton(()=>GetChatsUseCase(sl()));
  sl.registerLazySingleton(()=>GetChatByIdUseCase(sl()));
  sl.registerLazySingleton(()=>WatchChatsUseCase(sl()));
  sl.registerLazySingleton(()=>UpdateChatUseCase(sl()));
  sl.registerLazySingleton(()=>DeleteChatUseCase(sl()));
  sl.registerLazySingleton(()=>MuteChatUseCase(sl()));
  sl.registerLazySingleton(()=>UpdateLastMessageUseCase(sl()));
  sl.registerLazySingleton(()=>ChatSyncUsecase(sl()));

  //? Chats Repositories
  sl.registerLazySingleton<ChatRepository>(()=>ChatsRepoImpl(
    localDatasource: sl(),
    remoteDatasource: sl(),
    networkInfo: sl(),
    syncFromLToR: sl(),
    syncFromRtoL: sl()
  ));

  //? Chats Data Sources
  sl.registerLazySingleton<ChatLocalDatasource>(
    () => ChatLocalDatasourceImpl(
      chatBox: sl(),
      operationsBox: sl(),
    ),
  );

  sl.registerLazySingleton<ChatRemoteDatasource>(
    ()=>ChatRemoteDatasourceImpl(
      firestore: sl(),
    )
  );

  //?ChatSyncService
  sl.registerLazySingleton(()=>ChatSyncServiceFromLocalToRemote(
    localDatasource: sl(),
    remoteDatasource: sl(),
  ));

  sl.registerLazySingleton(()=>ChatSyncServiceFromRemoteToLocal(
    localDatasource: sl(),
    remoteDatasource: sl(),
  ));

}