import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:social_app_fe/features/post/domain/entities/post_entity.dart';

abstract class HomeState extends Equatable {
  final List<PostEntity>? posts;
  final DioException? error;
  final String? errorMessage;

  const HomeState({this.posts, this.error, this.errorMessage});

  @override
  List<Object?> get props => [posts, error, errorMessage];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeRefreshing extends HomeState {}

class HomeLoaded extends HomeState {
  const HomeLoaded(List<PostEntity> posts) : super(posts: posts);
}

class HomeError extends HomeState {
  const HomeError(DioException error, {super.errorMessage})
    : super(error: error);
}
