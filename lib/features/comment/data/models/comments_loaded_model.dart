import 'package:social_app_fe/features/comment/data/models/comment_model.dart';
import 'package:social_app_fe/features/comment/domain/entities/comments_loaded_entity.dart';

class CommentsLoadedModel extends CommentsLoadedEntity {
  @override
  final String postId;
  @override
  final List<CommentModel> comments;
  @override
  final int count;
  @override
  final DateTime timestamp;

  const CommentsLoadedModel({
    required this.postId,
    required this.comments,
    required this.count,
    required this.timestamp,
  }) : super(
         postId: postId,
         comments: comments,
         count: count,
         timestamp: timestamp,
       );

  factory CommentsLoadedModel.fromJson(Map<String, dynamic> json) {
    return CommentsLoadedModel(
      postId: json['postId'] as String,
      comments: (json['comments'] as List<dynamic>)
          .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: json['count'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'comments': comments.map((e) => e.toJson()).toList(),
      'count': count,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// ⚙️ Copy method (giống `copyWith` của Freezed)
  CommentsLoadedModel copyWith({
    String? postId,
    List<CommentModel>? comments,
    int? count,
    DateTime? timestamp,
  }) {
    return CommentsLoadedModel(
      postId: postId ?? this.postId,
      comments: comments ?? this.comments,
      count: count ?? this.count,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() {
    return 'CommentsLoadedModel(postId: $postId, count: $count, comments: ${comments.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CommentsLoadedModel &&
        other.postId == postId &&
        other.count == count &&
        other.timestamp == timestamp &&
        _listEquals(other.comments, comments);
  }

  @override
  int get hashCode =>
      postId.hashCode ^ comments.hashCode ^ count.hashCode ^ timestamp.hashCode;

  /// Helper để so sánh list comment
  bool _listEquals(List<CommentModel> a, List<CommentModel> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
