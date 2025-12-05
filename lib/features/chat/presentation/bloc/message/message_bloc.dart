import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/chat/domain/entities/chat_entities.dart';
import 'package:social_app_fe/features/chat/domain/entities/message_response_entity.dart';
import 'package:social_app_fe/features/chat/domain/usecases/chat_usecases.dart';
import 'package:social_app_fe/features/chat/presentation/bloc/bloc.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final GetMessagesUseCase _getMessagesUseCase;
  final GetMessagesAroundIdUseCase _getMessagesAroundIdUseCase;
  final TypingStartUseCase _typingStartUseCase;
  final TypingStopUseCase _typingStopUseCase;
  final ListenTypingStartUseCase _listenTypingStartUseCase;
  final ListenTypingStopUseCase _listenTypingStopUseCase;
  final ListenNewMessageUseCase _listenNewMessageUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final MarkAsReadUseCase _markAsReadUseCase;

  StreamSubscription<Map<String, dynamic>>? _typingStartSubscription;
  StreamSubscription<Map<String, dynamic>>? _typingStopSubscription;
  StreamSubscription<MessageEntity>? _newMessageSubscription;
  Timer? _typingDebounce;
  String? _currentConversationId;
  String? _currentUserId;

  MessageBloc({
    required GetMessagesUseCase getMessagesUseCase,
    required GetMessagesAroundIdUseCase getMessagesAroundIdUseCase,
    required TypingStartUseCase typingStartUseCase,
    required TypingStopUseCase typingStopUseCase,
    required ListenTypingStartUseCase listenTypingStartUseCase,
    required ListenTypingStopUseCase listenTypingStopUseCase,
    required ListenNewMessageUseCase listenNewMessageUseCase,
    required SendMessageUseCase sendMessageUseCase,
    required MarkAsReadUseCase markAsReadUseCase,
  }) : _getMessagesUseCase = getMessagesUseCase,
       _getMessagesAroundIdUseCase = getMessagesAroundIdUseCase,
       _typingStartUseCase = typingStartUseCase,
       _typingStopUseCase = typingStopUseCase,
       _listenTypingStartUseCase = listenTypingStartUseCase,
       _listenTypingStopUseCase = listenTypingStopUseCase,
       _listenNewMessageUseCase = listenNewMessageUseCase,
       _sendMessageUseCase = sendMessageUseCase,
       _markAsReadUseCase = markAsReadUseCase,
       super(const MessageInitial()) {
    on<LoadMessagesEvent>(_onLoadMessages);
    on<LoadMoreOldMessagesEvent>(_onLoadMoreOldMessages);
    on<LoadMoreNewMessagesEvent>(_onLoadMoreNewMessages);
    on<LoadMessagesAroundIdEvent>(_onLoadMessagesAroundId);
    on<TypingStartEvent>(_onTypingStart);
    on<TypingStopEvent>(_onTypingStop);
    on<NewMessageReceivedEvent>(_onNewMessageReceived);
    on<SendMessageEvent>(_onSendMessage);
    on<MarkAsReadEvent>(_onMarkAsRead);

    _setupTypingListeners();
    _setupNewMessageListener();
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

  void _setupNewMessageListener() {
    // Listen to message:new events through usecase
    _newMessageSubscription = _listenNewMessageUseCase(params: const NoParams())
        .listen((messageEntity) {
          add(NewMessageReceivedEvent(messageEntity));
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

  Future<void> _onLoadMoreOldMessages(
    LoadMoreOldMessagesEvent event,
    Emitter<MessageState> emit,
  ) async {
    final currentState = state;
    if (currentState is! MessagesLoaded) return;

    // hasPrevPage = false nghĩa là đang ở Page 1 (không còn trang trước/mới hơn)
    final bool wasStartReached = !currentState.messages.pagination.hasPrevPage;

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
        // Merge old messages với messages mới
        final newMessages = result.data!.data;
        final existingMessages = currentState.messages.data;

        // Tạo Set để track các message ID đã có
        final existingMessageIds = existingMessages.map((m) => m.id).toSet();

        // Lọc bỏ các messages đã tồn tại (tránh duplicate)
        final uniqueNewMessages = newMessages
            .where((msg) => !existingMessageIds.contains(msg.id))
            .toList();

        // Chỉ merge nếu có messages mới
        if (uniqueNewMessages.isNotEmpty) {
          // Append messages mới vào cuối list (messages cũ hơn)
          final mergedMessages = [...existingMessages, ...uniqueNewMessages];

          final newPagePagination = result.data!.pagination;
          //   final currentPage = currentState.messages.pagination.currentPage;
          final combinedPagination = newPagePagination.copyWith(
            //   currentPage: currentPage,
            // hasNextPage (Cũ hơn)
            hasNextPage: newPagePagination.hasNextPage,

            // hasPrevPage (Mới hơn): Giữ nguyên trạng thái cũ
            // Nếu trước đó wasStartReached=true (đang ở đỉnh), thì ép false.
            // Ngược lại thì lấy theo API.
            hasPrevPage: wasStartReached
                ? false
                : newPagePagination.hasPrevPage,
          );
          final updatedResponse = MessageResponseEntity(
            data: mergedMessages,
            pagination: combinedPagination,
          );

          _currentMessages = updatedResponse;
          emit(
            MessagesLoaded(
              updatedResponse,
              typingUserId: currentState.typingUserId,
              isTyping: currentState.isTyping,
            ),
          );
          print(
            'Loaded more ${uniqueNewMessages.length} unique messages (${newMessages.length - uniqueNewMessages.length} duplicates skipped), total: ${mergedMessages.length}',
          );
        } else {
          print(
            'All messages from page ${event.page} already loaded, skipping merge',
          );
        }
      } else if (result is DataStateError) {
        // Giữ nguyên state hiện tại nếu load more fail
        print('Error loading more messages: ${result.error}');
      }
    } catch (e) {
      print('Exception loading more messages: $e');
    }
  }

  Future<void> _onLoadMessagesAroundId(
    LoadMessagesAroundIdEvent event,
    Emitter<MessageState> emit,
  ) async {
    emit(const MessagesLoading());

    // Store current conversation info for typing
    _currentConversationId = event.conversationId;
    _currentUserId = event.userId;

    try {
      final result = await _getMessagesAroundIdUseCase(
        params: GetMessagesAroundIdParams(
          userId: event.userId,
          conversationId: event.conversationId,
          messageId: event.messageId,
          limit: event.limit,
        ),
      );

      if (result is DataStateSuccess) {
        _currentMessages = result.data!;
        emit(MessagesLoaded(_currentMessages!));
        print('Loaded messages around ID ${event.messageId} successfully');
      } else if (result is DataStateError) {
        emit(
          MessagesError(
            result.error?.message ?? 'Failed to load messages around ID',
          ),
        );
        print('Error loading messages around ID: ${result.error}');
      }
    } catch (e) {
      emit(MessagesError('Failed to load messages around ID: $e'));
      print('Exception loading messages around ID: $e');
    }
  }

  Future<void> _onLoadMoreNewMessages(
    LoadMoreNewMessagesEvent event,
    Emitter<MessageState> emit,
  ) async {
    final currentState = state;
    if (currentState is! MessagesLoaded) return;

    // Nếu hasNextPage đang là false (đang hiện Profile Header)
    final bool wasEndReached = !currentState.messages.pagination.hasNextPage;

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
        // Append new messages vào đầu list (messages mới hơn)
        final newMessages = result.data!.data;
        final existingMessages = currentState.messages.data;

        // Tạo Set để track các message ID đã có
        final existingMessageIds = existingMessages.map((m) => m.id).toSet();

        // Lọc bỏ các messages đã tồn tại (tránh duplicate)
        final uniqueNewMessages = newMessages
            .where((msg) => !existingMessageIds.contains(msg.id))
            .toList();

        // Chỉ merge nếu có messages mới
        if (uniqueNewMessages.isNotEmpty) {
          // Prepend messages mới vào đầu list (messages mới hơn)
          final mergedMessages = [...uniqueNewMessages, ...existingMessages];

          final newPagePagination = result.data!.pagination;

          final combinedPagination = newPagePagination.copyWith(
            // hasPrevPage (Mới hơn): Lấy từ API mới (để biết còn tin mới nữa ko)
            hasPrevPage: newPagePagination.hasPrevPage,

            // hasNextPage (Cũ hơn): Giữ nguyên trạng thái cũ
            // Nếu trước đó wasEndReached=true (đã thấy Header), thì ép false.
            hasNextPage: wasEndReached ? false : newPagePagination.hasNextPage,
          );

          final updatedResponse = MessageResponseEntity(
            data: mergedMessages,
            pagination: combinedPagination,
          );

          _currentMessages = updatedResponse;
          emit(
            MessagesLoaded(
              updatedResponse,
              typingUserId: currentState.typingUserId,
              isTyping: currentState.isTyping,
            ),
          );
          print(
            'Loaded more new ${uniqueNewMessages.length} unique messages (${newMessages.length - uniqueNewMessages.length} duplicates skipped), total: ${mergedMessages.length}',
          );
        } else {
          print(
            'All messages from page ${event.page} already loaded, skipping merge',
          );
        }
      } else if (result is DataStateError) {
        print('Error loading more new messages: ${result.error}');
      }
    } catch (e) {
      print('Exception loading more new messages: $e');
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

  void _onNewMessageReceived(
    NewMessageReceivedEvent event,
    Emitter<MessageState> emit,
  ) {
    try {
      // Check if message is for current conversation
      if (event.messageData.conversationId == _currentConversationId) {
        final currentState = state;

        if (currentState is MessagesLoaded) {
          // Check if message already exists (avoid duplicates)
          final messageExists = currentState.messages.data.any(
            (msg) => msg.id == event.messageData.id,
          );

          // Only add if message doesn't exist
          if (!messageExists) {
            // Create new messages list with new message at the end
            final updatedMessages = [
              event.messageData,
              ...currentState.messages.data,
            ];

            // Create new MessageResponseEntity with updated data
            final updatedResponse = MessageResponseEntity(
              data: updatedMessages,
              pagination: currentState.messages.pagination,
            );

            // Emit updated state
            emit(
              MessagesLoaded(
                updatedResponse,
                typingUserId: currentState.typingUserId,
                isTyping: currentState.isTyping,
              ),
            );

            print('New message added: ${event.messageData.id}');
          }
        }
      }
    } catch (e) {
      print('Error handling new message: $e');
    }
  }

  void _onSendMessage(SendMessageEvent event, Emitter<MessageState> emit) {
    // Validate message
    if (event.text == null || event.text!.isEmpty) {
      if (event.attachments == null || event.attachments!.isEmpty) {
        print('Cannot send empty message');
        return;
      }
    }

    // Send message through usecase
    _sendMessageUseCase(
      userId: event.userId,
      conversationId: event.conversationId,
      text: event.text,
      attachments: event.attachments,
      replyTo: event.replyTo,
    );

    print('Message sent to conversation: ${event.conversationId}');
    // Note: Message will be added to list via message:new event from backend
  }

  void _onMarkAsRead(MarkAsReadEvent event, Emitter<MessageState> emit) {
    // Mark messages as read through usecase
    _markAsReadUseCase(
      userId: event.userId,
      conversationId: event.conversationId,
      messageId: event.messageId,
    );

    print(
      'Marked messages as read for conversation: ${event.conversationId}${event.messageId != null ? ', messageId: ${event.messageId}' : ''}',
    );
  }

  @override
  Future<void> close() {
    _typingDebounce?.cancel();
    _typingStartSubscription?.cancel();
    _typingStopSubscription?.cancel();
    _newMessageSubscription?.cancel();
    return super.close();
  }
}
