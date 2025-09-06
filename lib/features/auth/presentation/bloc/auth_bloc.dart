import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/auth/data/models/auth_request.dart';
import 'package:social_app_fe/features/auth/domain/usecases/login_usecase.dart';
import 'package:social_app_fe/features/auth/domain/usecases/register_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;

  AuthBloc({required this.loginUsecase, required this.registerUsecase})
    : super(AuthInitial()) {
    on<LoginEvent>(_login);
    on<RegisterEvent>(_register);
  }

  void _login(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final dataState = await loginUsecase(
      params: AuthRequest(email: event.email, password: event.password),
    );

    if (dataState is DataStateSuccess && dataState.data != null) {
      emit(AuthLoaded(dataState.data!));
    } else {
      emit(AuthError(dataState.error!));
      return;
    }
  }

  void _register(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    // Call your register API here
    // final user = await registerUsecase(
    //   email: event.email,
    //   password: event.password,
    // );
    // emit(AuthLoaded(user));
  }
}
