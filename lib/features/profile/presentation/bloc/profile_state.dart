import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:social_app_fe/features/post/domain/entities/post_entity.dart';

abstract class ProfileState extends Equatable {
  final List<PostEntity>? posts;
  final DioException? error;
  final String? errorMessage;
  final int? currentPage;
  final int? limit;
  final bool? hasNext;
  final bool isLoadingMore;

  const ProfileState({
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

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded(
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

class ProfileError extends ProfileState {
  const ProfileError(DioException error, {super.errorMessage})
      : super(error: error);
}
