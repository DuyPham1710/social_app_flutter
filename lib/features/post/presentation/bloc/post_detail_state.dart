import 'package:equatable/equatable.dart';

abstract class PostDetailState extends Equatable {
  final int commentCount;

  const PostDetailState({this.commentCount = 0});

  @override
  List<Object?> get props => [commentCount];
}

class PostDetailInitial extends PostDetailState {}

class PostDetailLoading extends PostDetailState {}

class PostDetailLoaded extends PostDetailState {
  const PostDetailLoaded({required super.commentCount});
}
