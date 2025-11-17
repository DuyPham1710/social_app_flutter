import 'package:social_app_fe/features/comment/data/models/comment-log_model.dart';
import 'package:social_app_fe/features/comment/domain/entities/comment-log_loaded_entity.dart';

class CommentLogsLoadedModel extends CommentLogsLoadedEntity {
  @override
  final String commentId;
  @override
  final List<CommentLogModel> history;
  @override
  final int count;
  @override
  final DateTime timestamp;

  const CommentLogsLoadedModel({
    required this.commentId,
    required this.history,
    required this.count,
    required this.timestamp,
  }) : super(
         commentId: commentId,
         history: history,
         count: count,
         timestamp: timestamp,
       );

  factory CommentLogsLoadedModel.fromJson(Map<String, dynamic> json) {
    return CommentLogsLoadedModel(
      commentId: json['commentId'] as String,
      history: (json['history'] as List<dynamic>)
          .map((e) => CommentLogModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: json['count'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'history': history.map((e) => e.toJson()).toList(),
      'count': count,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  CommentLogsLoadedModel copyWith({
    String? commentId,
    List<CommentLogModel>? history,
    int? count,
    DateTime? timestamp,
  }) {
    return CommentLogsLoadedModel(
      commentId: commentId ?? this.commentId,
      history: history ?? this.history,
      count: count ?? this.count,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() {
    return 'CommentLogsLoadedModel(commentId: $commentId, count: $count, history: ${history.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CommentLogsLoadedModel &&
        other.commentId == commentId &&
        other.count == count &&
        other.timestamp == timestamp &&
        _listEquals(other.history, history);
  }

  @override
  int get hashCode =>
      commentId.hashCode ^
      history.hashCode ^
      count.hashCode ^
      timestamp.hashCode;

  /// Helper để so sánh list comment
  bool _listEquals(List<CommentLogModel> a, List<CommentLogModel> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
