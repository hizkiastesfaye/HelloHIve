import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hellohive/core/usecases/usecase.dart';
import 'package:hellohive/feature/friends/domain/entities/friends_entities.dart';
import 'package:hellohive/feature/friends/domain/usecases/friends_usecases.dart';
import 'package:hellohive/feature/friends/friends_core/friends_usecases_core.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failure.dart';

part 'friends_event.dart';
part 'friends_state.dart';

const String SUCCESS_MESSAGE = 'successful';
const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String UNKNOWN_FAILURE_MESSAGE = 'Unknown Failure';
const String INVALID_INPUT_FAILURE_MESSAGE = 'Invalid Input - Please check the entered data.';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  final GetFriendsUseCases getFriendsUseCases;
  final GetRandomFriendsUseCases getRandomFriendsUseCases;
  FriendsBloc({
    required this.getFriendsUseCases,
    required this.getRandomFriendsUseCases
  }) : super(FriendsInitial()) {
    on<GetFriendsEvent>((event, emit) async{
      emit(FriendsLoading());
      final friendParams = FriendsParams(value: event.value, fieldName: event.fieldName);
      final friendsResult = await getFriendsUseCases(friendParams);
      friendsResult.fold(
        (failure) async => emit(FriendsStateError(_mapFailureToMessage(failure))),
        (friends) async => emit(FriendsLoaded(friends))
      );
    });
    on<GetRandomFriendsEvent>((event, emit) async{
      emit(FriendsLoading());
      final friendsResult = await getRandomFriendsUseCases(NoParams());
    
      friendsResult.fold(
        (failure) async => emit(FriendsStateError(_mapFailureToMessage(failure))),
        (friends) async => emit(RandomFriendsLoaded(friends))
      );
    });


  }
  String _mapFailureToMessage(Failure failure){
    switch (failure.runtimeType){
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      case UnknownFailure:
        return UNKNOWN_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
