import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/chat/domain/entities/chat_entities.dart';
import 'package:social_app_fe/features/chat/domain/entities/message_response_entity.dart';
import 'package:social_app_fe/features/chat/domain/usecases/chat_usecases.dart';
import 'package:social_app_fe/features/chat/domain/usecases/send_message_with_files_usecase.dart';
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
  final SendMessageWithFilesUseCase _sendMessageWithFilesUseCase;
  final EditMessageUseCase _editMessageUseCase;
  final DeleteMessageUseCase _deleteMessageUseCase;
  final ReactMessageUseCase _reactMessageUseCase;
  final ListenMessageUpdatedUseCase _listenMessageUpdatedUseCase;
  final ListenMessageReadUseCase _listenMessageReadUseCase;
  final MarkAsReadUseCase _markAsReadUseCase;
  final TranslateMessageUseCase _translateMessageUseCase;

  StreamSubscription<Map<String, dynamic>>? _typingStartSubscription;
  StreamSubscription<Map<String, dynamic>>? _typingStopSubscription;
  StreamSubscription<MessageEntity>? _newMessageSubscription;
  StreamSubscription<MessageEntity>? _messageUpdatedSubscription;
  StreamSubscription<Map<String, dynamic>>? _messageReadSubscription;
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
    required SendMessageWithFilesUseCase sendMessageWithFilesUseCase,
    required EditMessageUseCase editMessageUseCase,
    required DeleteMessageUseCase deleteMessageUseCase,
    required ReactMessageUseCase reactMessageUseCase,
    required ListenMessageUpdatedUseCase listenMessageUpdatedUseCase,
    required ListenMessageReadUseCase listenMessageReadUseCase,
    required MarkAsReadUseCase markAsReadUseCase,
    required TranslateMessageUseCase translateMessageUseCase,
  }) : _getMessagesUseCase = getMessagesUseCase,
       _getMessagesAroundIdUseCase = getMessagesAroundIdUseCase,
       _typingStartUseCase = typingStartUseCase,
       _typingStopUseCase = typingStopUseCase,
       _listenTypingStartUseCase = listenTypingStartUseCase,
       _listenTypingStopUseCase = listenTypingStopUseCase,
       _listenNewMessageUseCase = listenNewMessageUseCase,
       _sendMessageUseCase = sendMessageUseCase,
       _sendMessageWithFilesUseCase = sendMessageWithFilesUseCase,
       _editMessageUseCase = editMessageUseCase,
       _deleteMessageUseCase = deleteMessageUseCase,
       _reactMessageUseCase = reactMessageUseCase,
       _listenMessageUpdatedUseCase = listenMessageUpdatedUseCase,
       _listenMessageReadUseCase = listenMessageReadUseCase,
       _markAsReadUseCase = markAsReadUseCase,
       _translateMessageUseCase = translateMessageUseCase,
       super(const MessageInitial()) {
    on<LoadMessagesEvent>(_onLoadMessages);
    on<LoadMoreOldMessagesEvent>(_onLoadMoreOldMessages);
    on<LoadMoreNewMessagesEvent>(_onLoadMoreNewMessages);
    on<LoadMessagesAroundIdEvent>(_onLoadMessagesAroundId);
    on<TranslateMessageEvent>(_onTranslateMessage);
    on<ToggleMessageTranslationEvent>(_onToggleMessageTranslation);
    on<TypingStartEvent>(_onTypingStart);
    on<TypingStopEvent>(_onTypingStop);
    on<NewMessageReceivedEvent>(_onNewMessageReceived);
    on<SendMessageEvent>(_onSendMessage);
    on<SendMessageWithFilesEvent>(_onSendMessageWithFiles);
    on<EditMessageEvent>(_onEditMessage);
    on<DeleteMessageEvent>(_onDeleteMessage);
    on<ReactMessageEvent>(_onReactMessage);
    on<MessageUpdatedReceivedEvent>(_onMessageUpdatedReceived);
    on<MessageReadReceivedEvent>(_onMessageReadReceived);
    on<MarkAsReadEvent>(_onMarkAsRead);

    _setupTypingListeners();
    _setupNewMessageListener();
    _setupMessageUpdatedListener();
    _setupMessageReadListener();
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

  void _setupMessageUpdatedListener() {
    // Listen to message:updated events through usecase
    _messageUpdatedSubscription =
        _listenMessageUpdatedUseCase(params: const NoParams()).listen((
          messageEntity,
        ) {
          add(MessageUpdatedReceivedEvent(messageEntity));
        });
  }

  void _setupMessageReadListener() {
    // Listen to message:read events through usecase
    _messageReadSubscription =
        _listenMessageReadUseCase(params: const NoParams()).listen((data) {
          final messageId = data['messageId'] as String?;
          final userId = data['userId'] as String?;
          final userInfo = data['user'] as Map<String, dynamic>?;
          final readAtStr = data['readAt'] as String?;

          // Allow messageId to be null (when marking all messages as read)
          if (userId != null && userInfo != null && readAtStr != null) {
            try {
              final readAt = DateTime.parse(readAtStr);
              add(
                MessageReadReceivedEvent(
                  messageId: messageId ?? '', // Use empty string if null
                  userId: userId,
                  userInfo: userInfo,
                  readAt: readAt,
                ),
              );
            } catch (e) {
              print('Error parsing readAt: $e');
            }
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
            _currentMessages = updatedResponse;

            add(
              MarkAsReadEvent(
                userId: _currentUserId!,
                conversationId: _currentConversationId!,
                messageId: event.messageData.id,
              ),
            );
            // Emit updated state
            emit(
              MessagesLoaded(
                updatedResponse,
                typingUserId: currentState.typingUserId,
                isTyping: currentState.isTyping,
                isUploadingFiles: currentState.isUploadingFiles,
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
    // Validate message - phải có text hoặc attachments hoặc metadata hoặc storyId
    if ((event.text == null || event.text!.isEmpty) &&
        (event.attachments == null || event.attachments!.isEmpty) &&
        (event.metadata == null || event.metadata!.isEmpty) &&
        (event.storyId == null || event.storyId!.isEmpty)) {
      print('Cannot send empty message');
      return;
    }

    // Send message through usecase
    _sendMessageUseCase(
      userId: event.userId,
      conversationId: event.conversationId,
      text: event.text,
      attachments: event.attachments,
      replyTo: event.replyTo,
      metadata: event.metadata,
      storyId: event.storyId,
      postId: event.postId,
    );
    // Note: Message will be added to list via message:new event from backend
  }

  Future<void> _onSendMessageWithFiles(
    SendMessageWithFilesEvent event,
    Emitter<MessageState> emit,
  ) async {
    try {
      print('Uploading files for conversation: ${event.conversationId}');

      final currentState = state;
      if (currentState is MessagesLoaded) {
        emit(
          MessagesLoaded(
            currentState.messages,
            typingUserId: currentState.typingUserId,
            isTyping: currentState.isTyping,
            isUploadingFiles: true,
          ),
        );
      }

      // Upload files và nhận về attachments URLs
      final attachments = await _sendMessageWithFilesUseCase(
        conversationId: event.conversationId,
        text: event.text,
        filePaths: event.filePaths,
        replyTo: event.replyTo,
      );

      print('Files uploaded successfully, attachments: $attachments');

      // Sau khi có attachments URLs, gửi message qua WebSocket
      if (attachments.isNotEmpty) {
        // Nếu có duration và waveform (voice message), thêm vào attachment đầu tiên
        List<Map<String, dynamic>> finalAttachments = attachments;

        if (event.audioDuration != null && event.audioWaveform != null) {
          print(
            'Adding voice metadata: duration=${event.audioDuration}s, waveform=${event.audioWaveform!.length} bars',
          );

          // Clone attachment đầu tiên và thêm duration + waveform
          finalAttachments = attachments.map((attachment) {
            // Chỉ thêm vào attachment đầu tiên (voice message)
            if (attachment == attachments.first &&
                attachment['type'] == 'audio') {
              return {
                ...attachment,
                'duration': event.audioDuration,
                'waveform': event.audioWaveform,
              };
            }
            return attachment;
          }).toList();
        }

        add(
          SendMessageEvent(
            userId: event.userId,
            conversationId: event.conversationId,
            text: event.text,
            attachments: finalAttachments,
            replyTo: event.replyTo,
          ),
        );
      }
    } catch (e) {
      print('Error uploading files: $e');
      // Optionally emit error state
    } finally {
      final latestState = state;
      if (latestState is MessagesLoaded) {
        emit(
          MessagesLoaded(
            latestState.messages,
            typingUserId: latestState.typingUserId,
            isTyping: latestState.isTyping,
            isUploadingFiles: false,
          ),
        );
      }
    }
  }

  void _onEditMessage(EditMessageEvent event, Emitter<MessageState> emit) {
    // Validate message
    if (event.newText.isEmpty) {
      print('Cannot edit message to empty');
      return;
    }

    // Edit message through usecase
    _editMessageUseCase(
      userId: event.userId,
      messageId: event.messageId,
      newText: event.newText,
    );

    print('Message edited: ${event.messageId}');
    // Note: Message will be updated in list via message:updated event from backend
  }

  void _onDeleteMessage(DeleteMessageEvent event, Emitter<MessageState> emit) {
    // Delete message through usecase
    _deleteMessageUseCase(
      userId: event.userId,
      messageId: event.messageId,
      deleteForEveryone: event.deleteForEveryone,
    );

    print(
      'Message deleted: ${event.messageId}, deleteForEveryone: ${event.deleteForEveryone}',
    );
    // Note: Message will be updated in list via message:deleted event from backend
  }

  void _onReactMessage(ReactMessageEvent event, Emitter<MessageState> emit) {
    // React to message through usecase
    _reactMessageUseCase(
      userId: event.userId,
      conversationId: event.conversationId,
      messageId: event.messageId,
      emojiId: event.emojiId,
    );

    print('Message reacted: ${event.messageId} with emoji: ${event.emojiId}');
    // Note: Message will be updated in list via message:updated event from backend
  }

  void _onMessageUpdatedReceived(
    MessageUpdatedReceivedEvent event,
    Emitter<MessageState> emit,
  ) {
    try {
      // Check if message is for current conversation
      if (event.messageData.conversationId == _currentConversationId) {
        final currentState = state;

        if (currentState is MessagesLoaded) {
          // Find and update the message in the list
          final updatedMessages = currentState.messages.data.map((msg) {
            if (msg.id == event.messageData.id) {
              return event.messageData; // Replace with updated message
            }
            return msg;
          }).toList();

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

          print('Message updated: ${event.messageData.id}');
        }
      }
    } catch (e) {
      print('Error handling message updated: $e');
    }
  }

  void _onMessageReadReceived(
    MessageReadReceivedEvent event,
    Emitter<MessageState> emit,
  ) {
    try {
      final currentState = state;

      if (currentState is MessagesLoaded) {
        // Create UserEntity from userInfo
        final userEntity = UserEntity(
          userId: event.userInfo['userId'] as String? ?? event.userId,
          username: event.userInfo['username'] as String? ?? '',
          fullName: event.userInfo['fullName'] as String?,
          avatarUrl: event.userInfo['avatarUrl'] as String?,
        );

        // Create SeenByEntity
        final seenByEntity = SeenByEntity(
          user: userEntity,
          seenAt: event.readAt,
        );

        final updatedMessages = currentState.messages.data.map((msg) {
          // Only update messages in current conversation
          if (msg.conversationId != _currentConversationId) {
            return msg;
          }

          // Check if user already in seenBy
          final alreadySeen = msg.seenBy.any(
            (seenBy) => seenBy.user.userId == event.userId,
          );

          if (alreadySeen) {
            return msg; // Already seen, no update needed
          }

          // If messageId is provided and not empty, only update that message and messages before it
          if (event.messageId.isNotEmpty) {
            // Find the target message to get its createdAt
            final targetMessage = currentState.messages.data.firstWhere(
              (m) => m.id == event.messageId,
              orElse: () => msg,
            );

            // Only update if this message was created before or at the same time as target
            if (msg.createdAt.isAfter(targetMessage.createdAt)) {
              return msg; // Message is newer than target, don't update
            }
          }
          // If messageId is empty, update all messages (mark all as read)

          // Add new seenBy entry
          return msg.copyWith(seenBy: [...msg.seenBy, seenByEntity]);
        }).toList();

        // Create new MessageResponseEntity with updated data
        final updatedResponse = MessageResponseEntity(
          data: updatedMessages,
          pagination: currentState.messages.pagination,
        );

        // Emit updated state
        _currentMessages = updatedResponse;
        emit(
          MessagesLoaded(
            updatedResponse,
            typingUserId: currentState.typingUserId,
            isTyping: currentState.isTyping,
          ),
        );

        print('Message read updated: ${event.messageId} by ${event.userId}');
      }
    } catch (e) {
      print('Error handling message read: $e');
    }
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

  Future<void> _onTranslateMessage(
    TranslateMessageEvent event,
    Emitter<MessageState> emit,
  ) async {
    final currentState = state;
    if (currentState is! MessagesLoaded) return;

    try {
      final result = await _translateMessageUseCase(
        params: TranslateMessageParams(
          messageId: event.messageId,
          targetLang: event.targetLang,
        ),
      );

      if (result is DataStateSuccess) {
        final translation = result.data!;

        final updatedMessages = currentState.messages.data.map((msg) {
          if (msg.id == event.messageId) {
            return msg.copyWith(
              translatedText: translation.translatedText,
              sourceLang: translation.sourceLang,
              targetLang: translation.targetLang,
              translationNotNeeded: translation.translationNotNeeded,
              showTranslation: !translation.translationNotNeeded,
            );
          }
          return msg;
        }).toList();

        final updatedResponse = MessageResponseEntity(
          data: updatedMessages,
          pagination: currentState.messages.pagination,
        );

        _currentMessages = updatedResponse;
        emit(
          MessagesLoaded(
            updatedResponse,
            typingUserId: currentState.typingUserId,
            isTyping: currentState.isTyping,
            isUploadingFiles: currentState.isUploadingFiles,
          ),
        );
      } else if (result is DataStateError) {
        print('Error translating message: ${result.error}');
      }
    } catch (e) {
      print('Exception translating message: $e');
    }
  }

  void _onToggleMessageTranslation(
    ToggleMessageTranslationEvent event,
    Emitter<MessageState> emit,
  ) {
    final currentState = state;
    if (currentState is! MessagesLoaded) return;

    final updatedMessages = currentState.messages.data.map((msg) {
      if (msg.id == event.messageId) {
        return msg.copyWith(showTranslation: event.showTranslation);
      }
      return msg;
    }).toList();

    final updatedResponse = MessageResponseEntity(
      data: updatedMessages,
      pagination: currentState.messages.pagination,
    );

    _currentMessages = updatedResponse;
    emit(
      MessagesLoaded(
        updatedResponse,
        typingUserId: currentState.typingUserId,
        isTyping: currentState.isTyping,
        isUploadingFiles: currentState.isUploadingFiles,
      ),
    );
  }

  @override
  Future<void> close() {
    _typingDebounce?.cancel();
    _typingStartSubscription?.cancel();
    _typingStopSubscription?.cancel();
    _newMessageSubscription?.cancel();
    _messageUpdatedSubscription?.cancel();
    _messageReadSubscription?.cancel();
    return super.close();
  }
}
