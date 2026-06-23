import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/chat/domain/entities/chat_media_entity.dart';
import 'package:social_app_fe/features/chat/domain/usecases/get_conversation_media_usecase.dart';
import 'chat_media_state.dart';

class ChatMediaCubit extends Cubit<ChatMediaState> {
  final GetConversationMediaUseCase _getConversationMediaUseCase;
  final String conversationId;
  final String type;
  
  int _currentPage = 1;
  bool _isFetching = false;

  ChatMediaCubit({
    required GetConversationMediaUseCase getConversationMediaUseCase,
    required this.conversationId,
    required this.type,
  })  : _getConversationMediaUseCase = getConversationMediaUseCase,
        super(ChatMediaInitial());

  Future<void> loadMedia({bool isRefresh = false}) async {
    if (_isFetching) return;
    
    if (isRefresh) {
      _currentPage = 1;
    }

    final currentState = state;
    List<ChatMediaEntity> currentItems = [];
    if (currentState is ChatMediaLoaded && !isRefresh) {
      currentItems = currentState.items;
      if (!currentState.hasMore) return;
    }

    _isFetching = true;
    emit(ChatMediaLoading(currentItems, isFirstFetch: _currentPage == 1));

    final result = await _getConversationMediaUseCase(
      conversationId: conversationId,
      type: type,
      page: _currentPage,
      limit: 30,
    );

    _isFetching = false;

    if (result is DataStateSuccess && result.data != null) {
      final mediaResponse = result.data!;
      final newItems = mediaResponse.data;
      
      final updatedItems = isRefresh ? newItems : [...currentItems, ...newItems];
      final hasMore = mediaResponse.pagination.hasNextPage;

      if (hasMore) {
        _currentPage++;
      }

      emit(ChatMediaLoaded(
        items: updatedItems,
        currentPage: mediaResponse.pagination.currentPage,
        totalPages: mediaResponse.pagination.totalPages,
        hasMore: hasMore,
      ));
    } else {
      emit(ChatMediaError(result.error?.message ?? 'Failed to load media'));
    }
  }
}
