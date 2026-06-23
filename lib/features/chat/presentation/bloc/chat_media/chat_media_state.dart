import 'package:equatable/equatable.dart';
import '../../../domain/entities/chat_media_entity.dart';

abstract class ChatMediaState extends Equatable {
  const ChatMediaState();

  @override
  List<Object?> get props => [];
}

class ChatMediaInitial extends ChatMediaState {}

class ChatMediaLoading extends ChatMediaState {
  final List<ChatMediaEntity> oldItems;
  final bool isFirstFetch;

  const ChatMediaLoading(this.oldItems, {this.isFirstFetch = false});

  @override
  List<Object?> get props => [oldItems, isFirstFetch];
}

class ChatMediaLoaded extends ChatMediaState {
  final List<ChatMediaEntity> items;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  const ChatMediaLoaded({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
  });

  @override
  List<Object?> get props => [items, currentPage, totalPages, hasMore];
}

class ChatMediaError extends ChatMediaState {
  final String message;

  const ChatMediaError(this.message);

  @override
  List<Object?> get props => [message];
}
