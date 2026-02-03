import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/chat/domain/entities/chat_entities.dart';
import 'package:social_app_fe/features/chat/domain/usecases/chat_usecases.dart';
import 'conversation_event.dart';
import 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final GetConversationsUseCase _getConversationsUseCase;
  final CreateConversationUseCase _createConversationUseCase;
  final JoinConversationUseCase _joinConversationUseCase;
  final LeaveConversationUseCase _leaveConversationUseCase;
  final ListenConversationUpdateUseCase _listenConversationUpdateUseCase;
  final UpdateConversationUseCase _updateConversationUseCase;
  // bool _isConnected = false;

  StreamSubscription<ConversationEntity>? _conversationUpdateSubscription;

  ConversationBloc({
    required GetConversationsUseCase getConversationsUseCase,
    required CreateConversationUseCase createConversationUseCase,
    required JoinConversationUseCase joinConversationUseCase,
    required LeaveConversationUseCase leaveConversationUseCase,
    required ListenConversationUpdateUseCase listenConversationUpdateUseCase,
    required UpdateConversationUseCase updateConversationUseCase,
  }) : _getConversationsUseCase = getConversationsUseCase,
       _createConversationUseCase = createConversationUseCase,
       _joinConversationUseCase = joinConversationUseCase,
       _leaveConversationUseCase = leaveConversationUseCase,
       _listenConversationUpdateUseCase = listenConversationUpdateUseCase,
       _updateConversationUseCase = updateConversationUseCase,
       super(const ConversationInitial()) {
    on<LoadConversationsEvent>(_onLoadConversations);
    on<CreateConversationEvent>(_onCreateConversation);
    on<JoinConversationEvent>(_onJoinConversation);
    on<LeaveConversationEvent>(_onLeaveConversation);
    on<UpdateConversationEvent>(_onUpdateConversation);
    on<ConversationUpdatedEvent>(_onConversationUpdated);

    _setupConversationUpdateListener();
  }

  Future<void> _onLoadConversations(
    LoadConversationsEvent event,
    Emitter<ConversationState> emit,
  ) async {
    final currentState = state;
    final isFirstPage = event.page == 1;

    // Chỉ emit loading state khi load page đầu tiên
    if (isFirstPage) {
      emit(const ConversationsLoading());
    }

    try {
      final result = await _getConversationsUseCase(
        params: GetConversationsParams(
          userId: event.userId,
          page: event.page,
          limit: event.limit,
        ),
      );

      if (result is DataStateSuccess) {
        // Join vào tất cả conversation rooms để nhận real-time updates
        // khi user đang ở ChatListPage
        for (final conversation in result.data!.data) {
          _joinConversationUseCase(
            params: JoinConversationParams(
              userId: event.userId,
              conversationId: conversation.id,
            ),
            // ignore: body_might_complete_normally_catch_error
          ).catchError((error) {
            // Log error nhưng không block flow
            print('Error joining conversation ${conversation.id}: $error');
          });
        }

        // Nếu là page đầu tiên, emit data mới
        if (isFirstPage) {
          emit(ConversationsLoaded(result.data!));
          print(
            'Loaded ${result.data!.data.length} conversations successfully (page ${event.page})',
          );
        } else {
          // Nếu là page tiếp theo, merge với data hiện có
          if (currentState is ConversationsLoaded) {
            final existingConversations = currentState.conversations.data;
            final newConversations = result.data!.data;

            // Lọc ra các conversations chưa có trong list hiện tại (tránh duplicate)
            final existingIds = existingConversations.map((c) => c.id).toSet();
            final uniqueNewConversations = newConversations
                .where((c) => !existingIds.contains(c.id))
                .toList();

            if (uniqueNewConversations.isNotEmpty) {
              // Merge conversations mới vào cuối list
              final mergedConversations = [
                ...existingConversations,
                ...uniqueNewConversations,
              ];

              // Cập nhật pagination với thông tin từ page mới
              final updatedPagination = result.data!.pagination;
              final mergedResponse = currentState.conversations.copyWith(
                data: mergedConversations,
                pagination: updatedPagination,
              );

              emit(ConversationsLoaded(mergedResponse));
              print(
                'Loaded more ${uniqueNewConversations.length} conversations (${newConversations.length - uniqueNewConversations.length} duplicates skipped), total: ${mergedConversations.length} (page ${event.page})',
              );
            } else {
              print(
                'All conversations from page ${event.page} already loaded, skipping merge',
              );
            }
          } else {
            // Nếu state không phải ConversationsLoaded, emit data mới
            emit(ConversationsLoaded(result.data!));
            print(
              'Loaded ${result.data!.data.length} conversations successfully (page ${event.page})',
            );
          }
        }
      } else if (result is DataStateError) {
        // Chỉ emit error nếu là page đầu tiên
        if (isFirstPage) {
          emit(
            ConversationsError(
              message: result.error?.message ?? 'Failed to load conversations',
            ),
          );
        }
        print('Error loading conversations: ${result.error}');
      }
    } catch (e) {
      // Chỉ emit error nếu là page đầu tiên
      if (isFirstPage) {
        emit(ConversationsError(message: 'Failed to load conversations: $e'));
      }
      print('Exception loading conversations: $e');
    }
  }

  Future<void> _onCreateConversation(
    CreateConversationEvent event,
    Emitter<ConversationState> emit,
  ) async {
    emit(const CreateConversationLoading());

    try {
      final result = await _createConversationUseCase(
        params: CreateConversationParams(
          userId: event.userId,
          participantIds: event.participantIds,
          isGroup: event.isGroup,
          name: event.name,
          avatar: event.avatar,
        ),
      );

      if (result is DataStateSuccess) {
        // Join vào conversation vừa tạo
        await _joinConversationUseCase(
          params: JoinConversationParams(
            userId: event.userId,
            conversationId: result.data!.id,
          ),
        );

        // Emit success state trước
        emit(CreateConversationSuccess(result.data!));
        print('Created conversation successfully: ${result.data!.id}');
      } else if (result is DataStateError) {
        emit(
          CreateConversationError(
            message: result.error?.message ?? 'Failed to create conversation',
          ),
        );
        print('Error creating conversation: ${result.error}');
      }
    } catch (e) {
      emit(
        CreateConversationError(message: 'Failed to create conversation: $e'),
      );
      print('Exception creating conversation: $e');
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

        // reload conversations after joining
        //   add(LoadConversationsEvent(userId: event.userId));
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

  Future<void> _onLeaveConversation(
    LeaveConversationEvent event,
    Emitter<ConversationState> emit,
  ) async {
    try {
      final result = await _leaveConversationUseCase(
        params: LeaveConversationParams(
          conversationId: event.conversationId,
          userId: event.userId,
        ),
      );

      if (result is DataStateSuccess) {
        print('Left conversation ${event.conversationId} successfully');
        // Optional: emit state nếu cần
        // emit(ConversationInitial());
      } else if (result is DataStateError) {
        print('Error leaving conversation: ${result.error}');
        // Optional: emit error state nếu muốn bắt UI
      }
    } catch (e) {
      print('Exception leaving conversation: $e');
    }
  }

  Future<void> _onUpdateConversation(
    UpdateConversationEvent event,
    Emitter<ConversationState> emit,
  ) async {
    try {
      _updateConversationUseCase(
        userId: event.userId,
        conversationId: event.conversationId,
        name: event.name,
        avatar: event.avatar,
        createdBy: event.createdBy,
        participantIds: event.participantIds,
      );
      print('Update conversation ${event.conversationId} successfully');
    } catch (e) {
      print('Exception updating conversation: $e');
    }
  }

  void _setupConversationUpdateListener() {
    _conversationUpdateSubscription =
        _listenConversationUpdateUseCase(params: const NoParams()).listen((
          conversation,
        ) {
          add(ConversationUpdatedEvent(conversation));
        });
  }

  Future<void> _onConversationUpdated(
    ConversationUpdatedEvent event,
    Emitter<ConversationState> emit,
  ) async {
    final currentState = state;

    if (currentState is ConversationsLoaded) {
      final currentList = currentState.conversations.data;
      final index = currentList.indexWhere(
        (c) => c.id == event.conversation.id,
      );

      if (index != -1) {
        final updatedList = List<ConversationEntity>.from(currentList);
        final oldConversation = updatedList[index];

        // Kiểm tra xem lastMessage có thay đổi không
        final hasNewMessage =
            oldConversation.lastMessage?.id !=
            event.conversation.lastMessage?.id;

        if (hasNewMessage) {
          // Xóa conversation cũ và đưa lên đầu
          updatedList.remove(updatedList[index]);
          updatedList.insert(0, event.conversation);
        } else {
          // Chỉ có unreadCount thay đổi thì Cập nhật tại chỗ
          updatedList[index] = event.conversation;
        }

        final updatedResponse = currentState.conversations.copyWith(
          data: updatedList,
        );

        emit(ConversationsLoaded(updatedResponse));
      }
    }
  }

  @override
  Future<void> close() {
    _conversationUpdateSubscription?.cancel();
    return super.close();
  }
}
