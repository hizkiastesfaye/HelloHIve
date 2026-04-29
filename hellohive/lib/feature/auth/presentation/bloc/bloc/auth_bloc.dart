import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hellohive/feature/auth/domain/entities/auth_entities.dart';
import 'package:meta/meta.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../auth_core/auth_usecase/auth_core_usecase.dart';
import '../../../domain/usecases/auth_usecases.dart';
import 'package:hellohive/core/errors/failure.dart';
import 'package:hellohive/core/utils/validators.dart' as pass_check;

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUsecase signInUsecase;
  final SignUpUsecase signUpUsecase;
  final SignOutUsecase signOutUsecase;
  final VerifyEmailUsecase verifyEmailUsecase;
  final EmailVerifiedUsecase emailVerifiedUsecase;
  final ResetPasswordUsecase resetPasswordUsecase;

  AuthBloc({
    required this.signInUsecase,
    required this.signUpUsecase,
    required this.signOutUsecase,
    required this.emailVerifiedUsecase,
    required this.verifyEmailUsecase,
    required this.resetPasswordUsecase,
    }) : super(AuthInitial()) {
    on<SignUpEvent>((event, emit) async{
      
      emit(AuthLoading());
      final signUpResult = await signUpUsecase(AuthParams(
        email: event.email, 
        password: event.password)
      );
      signUpResult.fold(
        (failure)=> emit(AuthError(failure.message)),
        (authUser)=>emit(AuthSignedUpState(authEntities: authUser))
      );
    });
    on<SignInEvent>((event, emit) async {
      emit(AuthLoading());
      final signInResult = await signInUsecase(AuthParams(
        email: event.email, 
        password: event.password)
      );
      signInResult.fold(
        (failure)=> emit(AuthError(failure.message)),
        (authUser)=>emit(AuthSignedInState(authEntities: authUser))
      );
    });
    on<SignOutEvent>((event, emit) async {
      emit(AuthLoading());
      final signOutResult = await signOutUsecase(NoParams());
      signOutResult.fold(
        (failure)=> emit(AuthError(failure.message)),
        (_)=>emit(AuthSignedOutState())
      );
    });
    on<VerifyEmailEvent>((event,emit) async{
      emit(AuthLoading());
      final verifyEmailResult = await verifyEmailUsecase(NoParams());
      verifyEmailResult.fold(
        (failure)=>emit(AuthError(failure.message)),
        (_)=>emit(AuthVerifyEmailState())
      );
    });
    on<EmailVerifiedEvent>((event,emit) async{
      emit(AuthLoading());
      final emailVerifiedResult= await emailVerifiedUsecase(NoParams());
      emailVerifiedResult.fold(
        (failure)=>emit(AuthError(failure.message)),
        (_)=>emit(EmailVerifiedState())
      );
    });
    on<ForgotPasswordEvent>((event,emit) async{
      emit(AuthLoading());
      final forgorPasswordResult = await resetPasswordUsecase(event.email);
      forgorPasswordResult.fold(
        (error)=>emit(AuthError(error.message)),
        (_)=>emit(ResetPasswordState())
      );
    });
  }
}
