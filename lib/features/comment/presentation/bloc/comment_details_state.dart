import 'package:equatable/equatable.dart';
import 'package:social_app_fe/features/comment/domain/entities/comments_loaded_entity.dart';
import 'package:dio/dio.dart';

abstract class CommentDetailsState extends Equatable {
  final CommentsLoadedEntity? commentsData;
  final DioException? error;
  final String? errorMessage;

  const CommentDetailsState({this.commentsData, this.error, this.errorMessage});

  @override
  List<Object?> get props => [commentsData, error, errorMessage];
}

class CommentDetailsInitial extends CommentDetailsState {}

class CommentDetailsLoading extends CommentDetailsState {}

class CommentDetailsLoaded extends CommentDetailsState {
  const CommentDetailsLoaded(CommentsLoadedEntity commentsData)
    : super(commentsData: commentsData);
}

class CommentDetailsEmpty extends CommentDetailsState {
  final String postId;

  const CommentDetailsEmpty(this.postId);

  @override
  List<Object?> get props => [...super.props, postId];
}

class CommentDetailsError extends CommentDetailsState {
  const CommentDetailsError(DioException error, {super.errorMessage})
    : super(error: error);
}
