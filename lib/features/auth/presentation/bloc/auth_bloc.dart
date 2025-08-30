import 'package:flutter_bloc/flutter_bloc.dart';
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
    // Call your login API here
    final user = await loginUsecase.login(
      email: event.email,
      password: event.password,
    );
    emit(AuthLoaded(user));
  }

  void _register(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    // Call your register API here
    final user = await registerUsecase.register(
      email: event.email,
      password: event.password,
    );
    emit(AuthLoaded(user));
  }
}
