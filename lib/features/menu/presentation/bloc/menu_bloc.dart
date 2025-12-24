import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/features/menu/presentation/bloc/menu_event.dart';
import 'package:social_app_fe/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:social_app_fe/features/menu/presentation/bloc/menu_state.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/features/home/presentation/bloc/home_bloc.dart';
import 'package:social_app_fe/features/home/presentation/bloc/home_event.dart';
import 'package:social_app_fe/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:social_app_fe/features/notification/presentation/bloc/notification_event.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;

  MenuBloc(this.getCurrentUserUseCase) : super(MenuInitial()) {
    on<LoadCurrentUserEvent>((event, emit) async {
      emit(MenuLoadingState());
      final result = await getCurrentUserUseCase();
      if (result is DataStateSuccess) {
        emit(MenuLoadedState(result.data!));
      } else {
        emit(MenuErrorState(result.error.toString()));
      }
    });

    on<LogoutEvent>(_onLogout);
  }
  Future<void> _onLogout(LogoutEvent event, Emitter<MenuState> emit) async {
    // Disconnect chat before clearing token and resetting dependencies
    try {
      final homeBloc = s1<HomeBloc>();
      homeBloc.add(const DisconnectChatEvent());
    } catch (e) {
      print('Error disconnecting chat during logout: $e');
    }

    // Disconnect notification socket and clear cache before logout
    try {
      final notificationBloc = s1<NotificationBloc>();
      notificationBloc.add(DisconnectNotificationSocket());
    } catch (e) {
      print('Error disconnecting notification socket during logout: $e');
    }

    await TokenStorage.clear();

    await resetDependencies();

    emit(MenuInitial());
  }
}
