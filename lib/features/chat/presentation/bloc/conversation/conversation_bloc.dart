import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/chat/domain/usecases/chat_usecases.dart';
import 'conversation_event.dart';
import 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final GetConversationsUseCase _getConversationsUseCase;
  final JoinConversationUseCase _joinConversationUseCase;
  // bool _isConnected = false;

  ConversationBloc({
    required GetConversationsUseCase getConversationsUseCase,
    required JoinConversationUseCase joinConversationUseCase,
  }) : _getConversationsUseCase = getConversationsUseCase,
       _joinConversationUseCase = joinConversationUseCase,
       super(const ConversationInitial()) {
    on<LoadConversationsEvent>(_onLoadConversations);
    on<JoinConversationEvent>(_onJoinConversation);
  }

  Future<void> _onLoadConversations(
    LoadConversationsEvent event,
    Emitter<ConversationState> emit,
  ) async {
    emit(const ConversationsLoading());

    try {
      final result = await _getConversationsUseCase(
        params: GetConversationsParams(
          userId: event.userId,
          page: event.page,
          limit: event.limit,
        ),
      );

      if (result is DataStateSuccess) {
        emit(ConversationsLoaded(result.data!));
        print('Loaded ${result.data!.data.length} conversations successfully');
      } else if (result is DataStateError) {
        emit(
          ConversationsError(
            message: result.error?.message ?? 'Failed to load conversations',
          ),
        );
        print('Error loading conversations: ${result.error}');
      }
    } catch (e) {
      emit(ConversationsError(message: 'Failed to load conversations: $e'));
      print('Exception loading conversations: $e');
    }
  }

  Future<void> _onJoinConversation(
    JoinConversationEvent event,
    Emitter<ConversationState> emit,
  ) async {
    emit(const JoinConversationLoading());

    try {
      final result = await _joinConversationUseCase(
        params: JoinConversationParams(
          userId: event.userId,
          conversationId: event.conversationId,
        ),
      );

      if (result is DataStateSuccess) {
        emit(JoinConversationSuccess(event.conversationId));
        print('Joined conversation ${event.conversationId} successfully');
      } else if (result is DataStateError) {
        emit(
          JoinConversationError(
            result.error?.message ?? 'Failed to join conversation',
          ),
        );
        print('Error joining conversation: ${result.error}');
      }
    } catch (e) {
      emit(JoinConversationError('Failed to join conversation: $e'));
      print('Exception joining conversation: $e');
    }
  }

  // Future<void> _onConnectChat(
  //   ConnectChatEvent event,
  //   Emitter<ChatState> emit,
  // ) async {
  //   if (_isConnected) {
  //     print('Chat already connected');
  //     return;
  //   }

  //   try {
  //     emit(const ChatConnecting());

  //     // Lấy userId từ token storage giống như HomeBloc
  //     final userData = await TokenStorage.getUserData();
  //     final userId = userData?['id'];
  //     final username = userData?['username'];

  //     if (userId == null) {
  //       emit(const ChatError('User not found. Please login again.'));
  //       return;
  //     }

  //     print('Connecting to chat with userId: $userId, username: $username');

  //     // Connect to chat namespace and wait for connection
  //     await _connectChatUseCase(
  //       params: ConnectChatSocketParams(userId, username ?? 'Unknown'),
  //     );
  //     _isConnected = true;

  //     emit(ChatConnected(userId: userId, username: username));

  //     print('Chat connected successfully');
  //   } catch (e) {
  //     print('Error connecting to chat: $e');
  //     emit(ChatError('Failed to connect to chat: $e'));
  //   }
  // }

  // Future<void> _onDisconnectChat(
  //   DisconnectChatEvent event,
  //   Emitter<ChatState> emit,
  // ) async {
  //   if (!_isConnected) {
  //     print('Chat already disconnected');
  //     return;
  //   }

  //   try {
  //     print('Disconnecting from chat...');

  //     _disconnectChatUseCase();
  //     _isConnected = false;

  //     emit(const ChatDisconnected());
  //     print('Chat disconnected successfully');
  //   } catch (e) {
  //     print('Error disconnecting from chat: $e');
  //     emit(ChatError('Failed to disconnect from chat: $e'));
  //   }
  // }

  @override
  Future<void> close() {
    // if (_isConnected) {
    //   _disconnectChatUseCase();
    // }
    return super.close();
  }
}
