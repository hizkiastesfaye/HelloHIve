import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:hellohive/core/network/netowork_info.dart';
import 'package:hellohive/feature/auth/data/dataSources/auth_remote_data_source.dart';
import 'package:hellohive/feature/auth/data/repositories/auth_repositories_impl.dart';
import 'package:hellohive/feature/auth/domain/repositories/auth_repositories.dart';
import 'package:hellohive/feature/auth/domain/usecases/auth_usecases.dart';
import 'package:hellohive/feature/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:hellohive/feature/friends/data/datasources/friends_local_DS.dart';
import 'package:hellohive/feature/friends/data/datasources/friends_remote_DS.dart';
import 'package:hellohive/feature/friends/data/repositories/friends_repo_impl.dart';
import 'package:hellohive/feature/friends/domain/repositories/friends_repo.dart';
import 'package:hellohive/feature/friends/domain/usecases/friends_usecases.dart';
import 'package:hellohive/feature/friends/presentation/bloc/friends_bloc.dart';
import 'package:hellohive/feature/settings/data/dataSources/user_profile_local.dart';
import 'package:hellohive/feature/settings/data/dataSources/user_profile_remote.dart';
import 'package:hellohive/feature/settings/data/repositories/user_profile_repo_iml.dart';
import 'package:hellohive/feature/settings/domain/repositories/user_profile_repo.dart';
import 'package:hellohive/feature/settings/domain/usecases/user_profile_useCase.dart';
import 'package:hellohive/feature/settings/presentation/bloc/user_profile_bloc_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.I;

Future<void> init() async{

  //!core
  sl.registerLazySingleton<NetworkInfo>(()=>NetworkInfoImpl(sl()));

  //!External
  sl.registerLazySingleton(()=>InternetConnectionChecker());
  sl.registerLazySingleton(()=>FirebaseAuth.instance);
  sl.registerLazySingleton(()=>FirebaseFirestore.instance);
  sl.registerLazySingleton(()=>FirebaseDatabase.instance);
  final sharedInstance = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(()=>sharedInstance);

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
  sl.registerLazySingleton(()=>GetRandomFriendsUseCases(sl()));

  //? Friends Repositories
  sl.registerLazySingleton<FriendsRepo>(()=>FriendsRepoImpl(
    networkInfo: sl(), 
    friendsLocal: sl(), 
    friendsRemote: sl()));

  //? Friends Data Sources
  sl.registerLazySingleton<FriendsLocalDS>(()=>FriendsLocalDsImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<FriendsRemoteDS>(()=>FriendsRemoteDsImpl(sl()));
}