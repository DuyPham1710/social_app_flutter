import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfilePostsEvent extends ProfileEvent {
  final String ownerId;
  final int page;
  final int limit;

  const LoadProfilePostsEvent({
    required this.ownerId,
    this.page = 1,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [ownerId, page, limit];
}

class LoadMoreProfilePostsEvent extends ProfileEvent {
  final String ownerId;

  const LoadMoreProfilePostsEvent({required this.ownerId});

  @override
  List<Object?> get props => [ownerId];
}
