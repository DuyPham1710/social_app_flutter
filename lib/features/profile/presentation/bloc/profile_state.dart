import 'package:equatable/equatable.dart';
import 'package:social_app_fe/features/post/domain/entities/post_entity.dart';
import 'package:dio/dio.dart';

abstract class ProfileState extends Equatable {
  final List<PostEntity>? posts;
  final Map<String, int>? commentCounts;
  final String? errorMessage;
  final int? currentPage;
  final int? limit;
  final bool? hasNext;
  final bool isLoadingMore;

  const ProfileState({
    this.posts,
    this.commentCounts,
    this.errorMessage,
    this.currentPage,
    this.limit,
    this.hasNext,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [
        posts,
        commentCounts,
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
    super.commentCounts,
    super.currentPage,
    super.limit,
    super.hasNext,
    super.isLoadingMore,
  }) : super(posts: posts);
}

class ProfileError extends ProfileState {
  const ProfileError(String message) : super(errorMessage: message);
}
