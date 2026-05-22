import 'package:equatable/equatable.dart';

abstract class StoryCreateState extends Equatable {
  const StoryCreateState();

  @override
  List<Object?> get props => [];
}

class StoryCreateInitial extends StoryCreateState {}

class StoryCreating extends StoryCreateState {}

/// Tạo story thành công (không cần dữ liệu chi tiết).
class StoryCreated extends StoryCreateState {}

class StoryCreateError extends StoryCreateState {
  final String message;

  const StoryCreateError({required this.message});

  @override
  List<Object?> get props => [message];
}
