import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/chat/domain/entities/message_response_entity.dart';
import 'package:social_app_fe/features/chat/domain/usecases/chat_usecases.dart';
import 'package:social_app_fe/features/chat/presentation/bloc/bloc.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final GetMessagesUseCase _getMessagesUseCase;
  final TypingStartUseCase _typingStartUseCase;
  final TypingStopUseCase _typingStopUseCase;
  final ListenTypingStartUseCase _listenTypingStartUseCase;
  final ListenTypingStopUseCase _listenTypingStopUseCase;

  StreamSubscription<Map<String, dynamic>>? _typingStartSubscription;
  StreamSubscription<Map<String, dynamic>>? _typingStopSubscription;
  Timer? _typingDebounce;
  String? _currentConversationId;
  String? _currentUserId;

  MessageBloc({
    required GetMessagesUseCase getMessagesUseCase,
    required TypingStartUseCase typingStartUseCase,
    required TypingStopUseCase typingStopUseCase,
    required ListenTypingStartUseCase listenTypingStartUseCase,
    required ListenTypingStopUseCase listenTypingStopUseCase,
  }) : _getMessagesUseCase = getMessagesUseCase,
       _typingStartUseCase = typingStartUseCase,
       _typingStopUseCase = typingStopUseCase,
       _listenTypingStartUseCase = listenTypingStartUseCase,
       _listenTypingStopUseCase = listenTypingStopUseCase,
       super(const MessageInitial()) {
    on<LoadMessagesEvent>(_onLoadMessages);
    on<TypingStartEvent>(_onTypingStart);
    on<TypingStopEvent>(_onTypingStop);

    _setupTypingListeners();
  }

  MessageResponseEntity? _currentMessages;

  void _setupTypingListeners() {
    // Listen to typing:start events through usecase
    _typingStartSubscription =
        _listenTypingStartUseCase(params: const NoParams()).listen((data) {
          final userId = data['userId'] as String?;
          final conversationId = data['conversationId'] as String?;

          if (userId != null && conversationId != null) {
            add(
              TypingStartEvent(userId: userId, conversationId: conversationId),
            );
          }
        });

    // Listen to typing:stop events through usecase
    _typingStopSubscription = _listenTypingStopUseCase(params: const NoParams())
        .listen((data) {
          final userId = data['userId'] as String?;
          final conversationId = data['conversationId'] as String?;

          if (userId != null && conversationId != null) {
            add(
              TypingStopEvent(userId: userId, conversationId: conversationId),
            );
          }
        });
  }

  Future<void> _onLoadMessages(
    LoadMessagesEvent event,
    Emitter<MessageState> emit,
  ) async {
    emit(const MessagesLoading());

    // Store current conversation info for typing
    _currentConversationId = event.conversationId;
    _currentUserId = event.userId;

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
        _currentMessages = result.data!;
        emit(MessagesLoaded(_currentMessages!));
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

  void _onTypingStart(TypingStartEvent event, Emitter<MessageState> emit) {
    // Only update typing state if it's for the current conversation
    if (event.conversationId == _currentConversationId &&
        event.userId != _currentUserId) {
      final currentState = state;
      if (currentState is MessagesLoaded) {
        // Update existing MessagesLoaded state with typing info
        emit(
          MessagesLoaded(
            currentState.messages,
            typingUserId: event.userId,
            isTyping: true,
          ),
        );
      } else {
        // Emit TypingState if messages not loaded yet
        emit(
          TypingState(
            userId: event.userId,
            conversationId: event.conversationId,
            isTyping: true,
          ),
        );
      }
    }
  }

  void _onTypingStop(TypingStopEvent event, Emitter<MessageState> emit) {
    // Only update typing state if it's for the current conversation
    if (event.conversationId == _currentConversationId &&
        event.userId != _currentUserId) {
      final currentState = state;
      if (currentState is MessagesLoaded) {
        // Update existing MessagesLoaded state to remove typing info
        emit(
          MessagesLoaded(
            currentState.messages,
            typingUserId: null,
            isTyping: false,
          ),
        );
      } else {
        // Emit TypingState if messages not loaded yet
        emit(
          TypingState(
            userId: event.userId,
            conversationId: event.conversationId,
            isTyping: false,
          ),
        );
      }
    }
  }

  void emitTypingStart(String userId, String conversationId) {
    // Cancel previous debounce timer
    _typingDebounce?.cancel();

    // Emit typing start immediately
    _typingStartUseCase(userId: userId, conversationId: conversationId);

    // Set timer to auto-stop typing after 3 seconds
    _typingDebounce = Timer(
      Duration(seconds: int.parse(dotenv.env['CHAT_DEBOUNCE_TIME'] ?? '4')),
      () {
        _typingStopUseCase(userId: userId, conversationId: conversationId);
      },
    );
  }

  void emitTypingStop(String userId, String conversationId) {
    // Cancel debounce timer
    _typingDebounce?.cancel();

    // Emit typing stop
    _typingStopUseCase(userId: userId, conversationId: conversationId);
  }

  @override
  Future<void> close() {
    _typingDebounce?.cancel();
    _typingStartSubscription?.cancel();
    _typingStopSubscription?.cancel();
    return super.close();
  }
}
