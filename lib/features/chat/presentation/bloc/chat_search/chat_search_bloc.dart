import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/friend/domain/entities/friend_suggestion_entity.dart';
import 'package:social_app_fe/features/friend/domain/entities/friend_request_entity.dart';
import 'package:social_app_fe/features/friend/domain/usecases/get_friend_suggestions_usecase.dart';
import 'package:social_app_fe/features/friend/domain/usecases/send_friend_request_usecase.dart';
import 'package:social_app_fe/features/friend/domain/usecases/cancel_friend_request_usecase.dart';

part 'chat_search_event.dart';
part 'chat_search_state.dart';

class ChatSearchBloc extends Bloc<ChatSearchEvent, ChatSearchState> {
  final GetFriendSuggestionsUseCase getFriendSuggestionsUseCase;
  final SendFriendRequestUseCase sendFriendRequestUseCase;
  final CancelFriendRequestUseCase cancelFriendRequestUseCase;

  ChatSearchBloc({
    required this.getFriendSuggestionsUseCase,
    required this.sendFriendRequestUseCase,
    required this.cancelFriendRequestUseCase,
  }) : super(ChatSearchInitial()) {
    on<LoadFriendSuggestions>(_onLoadFriendSuggestions);
    on<SendFriendRequestFromSearch>(_onSendFriendRequest);
    on<CancelFriendRequestFromSearch>(_onCancelFriendRequest);
  }

  Future<void> _onLoadFriendSuggestions(
    LoadFriendSuggestions event,
    Emitter<ChatSearchState> emit,
  ) async {
    emit(ChatSearchLoading());

    final result = await getFriendSuggestionsUseCase(
      page: event.page,
      limit: event.limit,
    );

    if (result is DataStateSuccess<List<FriendSuggestionEntity>>) {
      final suggestions = result.data ?? [];
      emit(
        ChatSearchLoaded(
          suggestions: suggestions,
          sentRequestUserIds: const {},
          userIdToRequestIdMap: const {},
        ),
      );
    } else if (result is DataStateError) {
      emit(
        ChatSearchError(
          message: result.error?.message ?? 'Lỗi khi tải gợi ý bạn bè',
        ),
      );
    }
  }

  Future<void> _onSendFriendRequest(
    SendFriendRequestFromSearch event,
    Emitter<ChatSearchState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ChatSearchLoaded) return;

    final result = await sendFriendRequestUseCase(event.receiverId);

    if (result is DataStateSuccess<FriendRequestEntity>) {
      final friendRequest = result.data!;
      // Cập nhật state để đánh dấu đã gửi lời mời và lưu requestId
      final updatedSentIds = Set<String>.from(currentState.sentRequestUserIds)
        ..add(event.receiverId);

      final updatedMapping = Map<String, String>.from(
        currentState.userIdToRequestIdMap,
      )..[event.receiverId] = friendRequest.requestId;

      emit(
        currentState.copyWith(
          sentRequestUserIds: updatedSentIds,
          userIdToRequestIdMap: updatedMapping,
        ),
      );
    } else if (result is DataStateError) {
      emit(
        ChatSearchError(
          message: result.error?.message ?? 'Lỗi khi gửi lời mời kết bạn',
        ),
      );
    }
  }

  Future<void> _onCancelFriendRequest(
    CancelFriendRequestFromSearch event,
    Emitter<ChatSearchState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ChatSearchLoaded) return;

    // Lấy requestId từ mapping
    final requestId = currentState.userIdToRequestIdMap[event.userId];
    if (requestId == null) {
      emit(ChatSearchError(message: 'Không tìm thấy lời mời để hủy'));
      return;
    }

    final result = await cancelFriendRequestUseCase(requestId);

    if (result is DataStateSuccess) {
      // Cập nhật state để đánh dấu đã hủy lời mời
      final updatedSentIds = Set<String>.from(currentState.sentRequestUserIds)
        ..remove(event.userId);

      final updatedMapping = Map<String, String>.from(
        currentState.userIdToRequestIdMap,
      )..remove(event.userId);

      emit(
        currentState.copyWith(
          sentRequestUserIds: updatedSentIds,
          userIdToRequestIdMap: updatedMapping,
        ),
      );
    } else if (result is DataStateError) {
      emit(
        ChatSearchError(
          message: result.error?.message ?? 'Lỗi khi hủy lời mời kết bạn',
        ),
      );
    }
  }
}
