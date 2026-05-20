import 'package:equatable/equatable.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/friend/domain/entities/relationship_status_entity.dart';
import 'package:social_app_fe/features/post/domain/entities/post_entity.dart';

class OtherProfileState extends Equatable {
  final List<PostEntity>? posts;
  final Map<String, int>? commentCounts;
  final UserEntity? user;
  final RelationshipStatusEntity? relationship;

  final int? currentPage;
  final bool? hasNext;
  final String? error;
  final bool isLoadingMore;

  const OtherProfileState({
    this.posts,
    this.commentCounts,
    this.user,
    this.relationship,
    this.currentPage,
    this.hasNext,
    this.error,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [
    posts,
    commentCounts,
    user,
    relationship,
    currentPage,
    hasNext,
    error,
    isLoadingMore,
  ];

  get errorMessage => null;
}

class OtherProfileInitial extends OtherProfileState {}

class OtherProfileLoading extends OtherProfileState {}

class OtherProfileLoaded extends OtherProfileState {
  const OtherProfileLoaded(
    List<PostEntity> posts, {
    super.commentCounts,
    super.user,
    super.relationship,
    super.currentPage,
    super.hasNext,
    super.isLoadingMore,
  }) : super(posts: posts);

  OtherProfileLoaded copyWith({
    List<PostEntity>? posts,
    Map<String, int>? commentCounts,
    UserEntity? user,
    RelationshipStatusEntity? relationship,
    int? currentPage,
    bool? hasNext,
    bool? isLoadingMore,
  }) {
    return OtherProfileLoaded(
      posts ?? this.posts ?? [],
      commentCounts: commentCounts ?? this.commentCounts,
      user: user ?? this.user,
      relationship: relationship ?? this.relationship,
      currentPage: currentPage ?? this.currentPage,
      hasNext: hasNext ?? this.hasNext,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class OtherProfileError extends OtherProfileState {
  const OtherProfileError(String message) : super(error: message);
}
