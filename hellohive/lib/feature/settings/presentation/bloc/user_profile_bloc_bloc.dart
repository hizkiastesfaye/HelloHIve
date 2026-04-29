import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hellohive/core/errors/failure.dart';
import 'package:hellohive/feature/settings/domain/entities/user_profile_entities.dart';
import 'package:hellohive/feature/settings/domain/usecases/user_profile_useCase.dart';
import 'package:meta/meta.dart';

import '../../userProfile_core/user_profile_core.dart';

part 'user_profile_bloc_event.dart';
part 'user_profile_bloc_state.dart';

const String SUCCESS_MESSAGE = 'successful';
const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String UNKNOWN_FAILURE_MESSAGE = 'Unknown Failure';
const String INVALID_INPUT_FAILURE_MESSAGE = 'Invalid Input - Please check the entered data.';
const String USER_NOT_FOUND_FAILURE_MESSAGE = 'User not found. Please check the user ID.';


class UserProfileBlocBloc extends Bloc<UserProfileBlocEvent, UserProfileBlocState> {
  final GetUserProfileUsecase getUserProfileUsecase;
  final AddUserProfileUsecase addUserProfileUsecase;
  final UpdateSingleUserProfileUsecase updateSingleUserProfileUsecase;
  final UpdateUserProfileUsecase updateUserProfileUsecase;
  final DeletUserProfileUsecase deletUserProfileUsecase;
  final GetUserStatusUsecase getUserStatusUsecase;
  UserProfileBlocBloc({
    required this.getUserProfileUsecase,
    required this.addUserProfileUsecase,
    required this.updateSingleUserProfileUsecase,
    required this.updateUserProfileUsecase,
    required this.deletUserProfileUsecase,
    required this.getUserStatusUsecase
  }) : super(UserProfileBlocInitial()) {
    on<GetUserProfileEvent>((event, emit) async{
      emit(UserProfileLoading());
      final profileResult = await getUserProfileUsecase(event.uId);
      profileResult.fold(
        (failure) async{
          // print("#############################@@@@@@@@@@@@@@@@");
          emit(UserProfileGetError(_mapFailureToMessage(failure)));},
        (data){
          // print("#############################@@@@@@@@@@@@@@@@");
          // print(data.photoUrl);
          // print("#############################@@@@@@@@@@@@@@@@");
          emit(UserProfileLoaded(data));}
      );
    });

    on<AddUserProfileEvent>((event, emit) async{
      emit(UserProfileLoading());
      final UserProfParams profileFields =UserProfParams(
        uId: event.uId,         
        phone: event.phone, 
        username: event.username, 
        firstName: event.firstName, 
        lastName: event.lastName, 
        photoUrl: event.photoUrl, 
        description:event.description
      );
      
      final addResult = await addUserProfileUsecase(profileFields);
      addResult.fold(
        (failure) async=> emit(UserProfileAddError(_mapFailureToMessage(failure))),
        (data)=>emit(UserProfileAdded(SUCCESS_MESSAGE))
      );
    });
    on<UpdateSingleUserProfileEvent>((event, emit) async{
      emit(UserProfileLoading());
      final UserSingleParams singleField = UserSingleParams(
        uId: event.uId,
        fieldName: event.fieldName,
        value: event.value
      );
      final updateResult = await updateSingleUserProfileUsecase(singleField);
      updateResult.fold(
        (failure) async=> emit(UserProfileSingleUpdateError(_mapFailureToMessage(failure))),
        (data)=>emit(SingleUserProfileUpdated(SUCCESS_MESSAGE))
      );
    });
     on<UpdateUserProfileEvent>((event, emit) async{
      emit(UserProfileLoading());
      final UserProfParams profileFields =UserProfParams(
        uId: event.uId,         
        phone: event.phone, 
        username: event.username, 
        firstName: event.firstName, 
        lastName: event.lastName, 
        description:event.description 
      );
      final updateResult = await updateUserProfileUsecase(profileFields);
      updateResult.fold(
        (failure) async=> emit(UserProfileUpdateError(_mapFailureToMessage(failure))),
        (data)=>emit(UserProfileUpdated(SUCCESS_MESSAGE))
      );
    });
      on<DeleteUserProfileEvent>((event, emit) async{
        emit(UserProfileLoading());
        final UserProfParams uuId = UserProfParams(uId: event.uId);
        final deleteResult = await deletUserProfileUsecase(uuId);
        deleteResult.fold(
          (failure) async=> emit(UserProfileDeleteError(_mapFailureToMessage(failure))),
          (data)=>emit(UserProfileDeleted(SUCCESS_MESSAGE))
        );
      });
  
      on<GetUserStatusEvent>((event, emit) async{
        emit(UserProfileLoading());
        final statusResult = await getUserStatusUsecase(event.uId);
        await emit.forEach(
          statusResult,
          onData: (statusResult)=> statusResult.fold(
            (failure) => UserStatusError(_mapFailureToMessage(failure)),
            (status) => UserStatusLoaded(status)
          )
        );
      });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
