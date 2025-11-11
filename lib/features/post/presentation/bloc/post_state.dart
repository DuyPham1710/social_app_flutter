import 'package:equatable/equatable.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object?> get props => [];
}

class PostInitial extends PostState {}

class PostCreating extends PostState {}

class PostCreated extends PostState {
  final String message;

  const PostCreated({required this.message});

  @override
  List<Object?> get props => [message];
}

class PostCreateError extends PostState {
  final String message;

  const PostCreateError({required this.message});

  @override
  List<Object?> get props => [message];
}
