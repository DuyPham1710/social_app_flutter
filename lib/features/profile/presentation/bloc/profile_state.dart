import 'package:equatable/equatable.dart';
import 'package:social_app_fe/features/post/domain/entities/post_entity.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';

abstract class ProfileState extends Equatable {
  final List<PostEntity>? posts;
  final Map<String, int>? commentCounts;
  final String? errorMessage;
  final int? currentPage;
  final int? limit;
  final bool? hasNext;
  final bool isLoadingMore;
  final UserEntity? user;
  final bool isUserLoading;

  const ProfileState({
    this.posts,
    this.commentCounts,
    this.errorMessage,
    this.currentPage,
    this.limit,
    this.hasNext,
    this.isLoadingMore = false,
    this.isUserLoading = false,
    this.user,
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
    isUserLoading,
    user,
  ];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial() : super(user: null);
}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded(
    List<PostEntity> posts, {
    super.commentCounts,
    super.currentPage,
    super.limit,
    super.hasNext,
    super.isLoadingMore,
    super.isUserLoading,
    super.user,
  }) : super(posts: posts);
}

extension ProfileLoadedCopyWith on ProfileLoaded {
  ProfileLoaded copyWith({
    List<PostEntity>? posts,
    Map<String, int>? commentCounts,
    String? errorMessage,
    int? currentPage,
    int? limit,
    bool? hasNext,
    bool? isLoadingMore,
    bool? isUserLoading,
    UserEntity? user,
  }) {
    return ProfileLoaded(
      posts ?? this.posts ?? [],
      commentCounts: commentCounts ?? this.commentCounts,
      currentPage: currentPage ?? this.currentPage,
      limit: limit ?? this.limit,
      hasNext: hasNext ?? this.hasNext,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isUserLoading: isUserLoading ?? this.isUserLoading,
      user: user ?? this.user,
    );
  }
}

class ProfileError extends ProfileState {
  const ProfileError(String message) : super(errorMessage: message);
}
