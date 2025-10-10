import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:social_app_fe/features/post/domain/entities/post_entity.dart';

abstract class HomeState extends Equatable {
  final List<PostEntity>? posts;
  final DioException? error;
  final String? errorMessage;
  final int? currentPage;
  final int? limit;
  final bool? hasNext;
  final bool isLoadingMore;

  const HomeState({
    this.posts,
    this.error,
    this.errorMessage,
    this.currentPage,
    this.limit,
    this.hasNext,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [
        posts,
        error,
        errorMessage,
        currentPage,
        limit,
        hasNext,
        isLoadingMore,
      ];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeRefreshing extends HomeState {}

class HomeLoaded extends HomeState {
  const HomeLoaded(
    List<PostEntity> posts, {
    int? currentPage,
    int? limit,
    bool? hasNext,
    bool isLoadingMore = false,
  }) : super(
          posts: posts,
          currentPage: currentPage,
          limit: limit,
          hasNext: hasNext,
          isLoadingMore: isLoadingMore,
        );
}

class HomeError extends HomeState {
  const HomeError(DioException error, {super.errorMessage})
      : super(error: error);
}
