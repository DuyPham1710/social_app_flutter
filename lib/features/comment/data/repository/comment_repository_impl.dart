import 'package:dio/dio.dart';
import 'package:social_app_fe/core/network/dio_client.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/comment/data/data_sources/remote/comment_remote_data_source.dart';
import 'package:social_app_fe/features/comment/data/models/comments_loaded_model.dart';
import 'package:social_app_fe/features/comment/domain/entities/comment-log_loaded_entity.dart';
import 'package:social_app_fe/features/comment/data/models/react_comment_model.dart';
import 'package:social_app_fe/features/comment/domain/entities/typing_entity.dart';
import 'package:social_app_fe/features/comment/domain/params/add_comment_params.dart';
import 'package:social_app_fe/features/comment/domain/params/delete_comment_params.dart';
import 'package:social_app_fe/features/comment/domain/params/update_comment_params.dart';
import 'package:social_app_fe/features/comment/domain/repository/comment_repository.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDataSource _remoteDataSource;

  CommentRepositoryImpl(this._remoteDataSource);

  @override
  void connect(String userId, String username) {
    _remoteDataSource.connect(userId, username);
  }

  @override
  void joinPost(String postId) {
    _remoteDataSource.joinPost(postId);
  }

  @override
  void leavePost(String postId) {
    _remoteDataSource.leavePost(postId);
  }

  @override
  void emitTyping({required String postId, required bool isTyping}) {
    _remoteDataSource.emitTyping(postId: postId, isTyping: isTyping);
  }

  @override
  void loadComments(String postId) {
    _remoteDataSource.loadComments(postId);
  }

  @override
  int getCommentCount(String postId) {
    return _remoteDataSource.getCommentCount(postId);
  }

  @override
  Stream<TypingEntity> get typingStream => _remoteDataSource.typingStream;

  @override
  Stream<Map<String, int>> get commentCountStream =>
      _remoteDataSource.commentCountStream;

  @override
  Stream<CommentsLoadedModel> get commentsLoadedStream =>
      _remoteDataSource.commentsLoadedStream.map(
        (model) => CommentsLoadedModel(
          postId: model.postId,
          comments: model.comments, // Tạm thời empty, sẽ implement sau
          count: model.count,
          timestamp: model.timestamp,
        ),
      );

  @override
  Stream<CommentLogsLoadedEntity> get commentHistoryLoadedStream =>
      _remoteDataSource.commentHistoryLoadedStream;

  @override
  Future<DataState<CommentsLoadedModel?>> getCommentsLoadedData(
    String postId,
  ) async {
    try {
      final commentsLoadedModel = _remoteDataSource.getCommentsLoadedData(
        postId,
      );
      if (commentsLoadedModel == null ||
          commentsLoadedModel.comments.isEmpty ||
          commentsLoadedModel.count == 0) {
        return const DataStateSuccess(null);
      }

      return DataStateSuccess(commentsLoadedModel);
    } catch (e) {
      return DataStateError(
        DioException(requestOptions: RequestOptions(), message: e.toString()),
      );
    }
  }

  @override
  Future<void> clearCommentsCache(String postId) async {
    _remoteDataSource.clearCommentsCache(postId);
  }

  @override
  Future<DataState<ReactCommentModel>> reactComment({
    required String commentId,
    required String emoji,
  }) async {
    try {
      final dio = DioClient.instance;
      final response = await dio.post(
        '/react-comment',
        data: {'commentId': commentId, 'emojiId': emoji},
      );
      return DataStateSuccess(ReactCommentModel.fromJson(response.data));
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  void addComment(AddCommentParams params) async {
    _remoteDataSource.addComment(params);
  }

  @override
  void deleteComment(DeleteCommentParams params) async {
    _remoteDataSource.deleteComment(params);
  }

  @override
  void updateComment(UpdateCommentParams params) async {
    _remoteDataSource.updateComment(params);
  }

  @override
  void loadCommentHistory(String commentId) {
    _remoteDataSource.loadCommentHistory(commentId);
  }

  @override
  void disconnect() {
    _remoteDataSource.disconnect();
  }
}
