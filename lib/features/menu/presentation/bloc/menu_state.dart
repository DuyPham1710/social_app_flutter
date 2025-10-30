import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';

abstract class MenuState {}
class MenuInitial extends MenuState {}
class MenuLoadingState extends MenuState {}
class MenuLoadedState extends MenuState {
  final UserEntity user;
  MenuLoadedState(this.user);
}
class MenuErrorState extends MenuState {
  final String message;
  MenuErrorState(this.message);
}
