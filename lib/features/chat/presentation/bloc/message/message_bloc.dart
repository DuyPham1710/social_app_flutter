import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/chat/domain/usecases/chat_usecases.dart';
import 'package:social_app_fe/features/chat/presentation/bloc/bloc.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final GetMessagesUseCase _getMessagesUseCase;

  MessageBloc({required GetMessagesUseCase getMessagesUseCase})
    : _getMessagesUseCase = getMessagesUseCase,
      super(const MessageInitial()) {
    on<LoadMessagesEvent>(_onLoadMessages);
  }

  Future<void> _onLoadMessages(
    LoadMessagesEvent event,
    Emitter<MessageState> emit,
  ) async {
    emit(const MessagesLoading());

    try {
      final result = await _getMessagesUseCase(
        params: GetMessagesParams(
          userId: event.userId,
          conversationId: event.conversationId,
          page: event.page,
          limit: event.limit,
        ),
      );

      if (result is DataStateSuccess) {
        emit(MessagesLoaded(result.data!));
        print('Loaded ${result.data!.data.length} messages successfully');
      } else if (result is DataStateError) {
        emit(MessagesError(result.error?.message ?? 'Failed to load messages'));
        print('Error loading messages: ${result.error}');
      }
    } catch (e) {
      emit(MessagesError('Failed to load messages: $e'));
      print('Exception loading messages: $e');
    }
  }
}
