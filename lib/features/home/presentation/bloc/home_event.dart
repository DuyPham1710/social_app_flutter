import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadPostsEvent extends HomeEvent {
  final int page;
  final int limit;

  const LoadPostsEvent({this.page = 1, this.limit = 10});

  @override
  List<Object?> get props => [page, limit];
}
