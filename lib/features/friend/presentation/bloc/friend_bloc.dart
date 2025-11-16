import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/friend/domain/entities/friend_entity.dart';
import 'package:social_app_fe/features/friend/domain/entities/friend_request_entity.dart';
import 'package:social_app_fe/features/friend/domain/entities/friend_suggestion_entity.dart';
import 'package:social_app_fe/features/friend/domain/entities/sent_friend_request_entity.dart';
import 'package:social_app_fe/features/friend/domain/usecases/accept_friend_request_usecase.dart';
import 'package:social_app_fe/features/friend/domain/usecases/cancel_friend_request_usecase.dart';
import 'package:social_app_fe/features/friend/domain/usecases/get_friend_requests_usecase.dart';
import 'package:social_app_fe/features/friend/domain/usecases/get_friend_suggestions_usecase.dart';
import 'package:social_app_fe/features/friend/domain/usecases/get_friends_usecase.dart';
import 'package:social_app_fe/features/friend/domain/usecases/get_sent_friend_requests_usecase.dart';
import 'package:social_app_fe/features/friend/domain/usecases/reject_friend_request_usecase.dart';
import 'package:social_app_fe/features/friend/domain/usecases/remove_friend_usecase.dart';
import 'package:social_app_fe/features/friend/domain/usecases/send_friend_request_usecase.dart';

part 'friend_event.dart';
part 'friend_state.dart';

class FriendBloc extends Bloc<FriendEvent, FriendState> {
  final GetFriendsUseCase getFriendsUseCase;
  final GetFriendRequestsUseCase getFriendRequestsUseCase;
  final GetSentFriendRequestsUseCase getSentFriendRequestsUseCase;
  final GetFriendSuggestionsUseCase getFriendSuggestionsUseCase;
  final SendFriendRequestUseCase sendFriendRequestUseCase;
  final AcceptFriendRequestUseCase acceptFriendRequestUseCase;
  final RejectFriendRequestUseCase rejectFriendRequestUseCase;
  final CancelFriendRequestUseCase cancelFriendRequestUseCase;
  final RemoveFriendUseCase removeFriendUseCase;

  FriendBloc({
    required this.getFriendsUseCase,
    required this.getFriendRequestsUseCase,
    required this.getSentFriendRequestsUseCase,
    required this.getFriendSuggestionsUseCase,
    required this.sendFriendRequestUseCase,
    required this.acceptFriendRequestUseCase,
    required this.rejectFriendRequestUseCase,
    required this.cancelFriendRequestUseCase,
    required this.removeFriendUseCase,
  }) : super(FriendInitial()) {
    on<LoadFriends>(_onLoadFriends);
    on<LoadFriendRequests>(_onLoadFriendRequests);
    on<LoadSentFriendRequests>(_onLoadSentFriendRequests);
    on<LoadFriendSuggestions>(_onLoadFriendSuggestions);
    on<LoadFriendPage>(_onLoadFriendPage);
    on<SendFriendRequest>(_onSendFriendRequest);
    on<AcceptFriendRequest>(_onAcceptFriendRequest);
    on<RejectFriendRequest>(_onRejectFriendRequest);
    on<CancelSentFriendRequest>(_onCancelSentFriendRequest);
    on<RemoveFriend>(_onRemoveFriend);
    on<RemoveFriendSuggestion>(_onRemoveFriendSuggestion);
    on<SortFriendRequests>(_onSortFriendRequests);
    on<FilterFriendRequests>(_onFilterFriendRequests);
  }

  Future<void> _onLoadFriends(
    LoadFriends event,
    Emitter<FriendState> emit,
  ) async {
    emit(FriendLoading());

    final dataState = await getFriendsUseCase();

    if (dataState is DataStateSuccess) {
      emit(FriendLoaded(friends: dataState.data!));
    } else if (dataState is DataStateError) {
      emit(
        FriendError(message: dataState.error?.message ?? 'Lỗi không xác định'),
      );
    }
  }

  Future<void> _onLoadFriendRequests(
    LoadFriendRequests event,
    Emitter<FriendState> emit,
  ) async {
    final currentState = state;

    // Nếu đã có FriendPageLoaded, chỉ cập nhật loading state
    if (currentState is FriendPageLoaded) {
      emit(currentState.copyWith(isLoadingRequests: true));
    } else {
      emit(FriendRequestsLoading());
    }

    final dataState = await getFriendRequestsUseCase(received: event.received);

    if (dataState is DataStateSuccess) {
      if (currentState is FriendPageLoaded) {
        emit(
          currentState.copyWith(
            friendRequests: dataState.data!,
            isLoadingRequests: false,
          ),
        );
      } else {
        emit(
          FriendRequestsLoaded(
            friendRequests: dataState.data!,
            isReceived: event.received,
          ),
        );
      }
    } else if (dataState is DataStateError) {
      final errorMessage = _getErrorMessage(dataState.error);
      if (currentState is FriendPageLoaded) {
        emit(currentState.copyWith(isLoadingRequests: false));
      }
      emit(FriendError(message: errorMessage));
    }
  }

  /// Helper method để xử lý error message
  String _getErrorMessage(dynamic error) {
    if (error is DioException) {
      if (error.message?.contains('Phiên đăng nhập đã hết hạn') == true) {
        return 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';
      } else if (error.message?.contains('Lỗi máy chủ') == true) {
        return 'Lỗi máy chủ. Vui lòng thử lại sau.';
      } else if (error.message?.contains('Đã xảy ra lỗi không mong muốn') ==
          true) {
        return 'Đã xảy ra lỗi không mong muốn. Vui lòng thử lại.';
      }
    }
    return error?.message ?? 'Lỗi không xác định';
  }

  Future<void> _onLoadFriendSuggestions(
    LoadFriendSuggestions event,
    Emitter<FriendState> emit,
  ) async {
    final currentState = state;

    // Nếu đã có FriendPageLoaded, chỉ cập nhật loading state
    if (currentState is FriendPageLoaded) {
      emit(currentState.copyWith(isLoadingSuggestions: true));
    } else {
      emit(FriendSuggestionsLoading());
    }

    final dataState = await getFriendSuggestionsUseCase(
      page: event.page,
      limit: event.limit,
    );

    if (dataState is DataStateSuccess) {
      if (currentState is FriendPageLoaded) {
        emit(
          currentState.copyWith(
            friendSuggestions: dataState.data!,
            isLoadingSuggestions: false,
          ),
        );
      } else {
        emit(FriendSuggestionsLoaded(friendSuggestions: dataState.data!));
      }
    } else if (dataState is DataStateError) {
      final errorMessage =
          dataState.error?.message ??
          dataState.error?.response?.data?['message'] ??
          'Lỗi không xác định khi tải gợi ý bạn bè';
      if (currentState is FriendPageLoaded) {
        emit(currentState.copyWith(isLoadingSuggestions: false));
      }
      emit(FriendError(message: errorMessage));
    }
  }

  Future<void> _onLoadFriendPage(
    LoadFriendPage event,
    Emitter<FriendState> emit,
  ) async {
    emit(
      FriendPageLoaded(
        friendRequests: const [],
        friendSuggestions: const [],
        isLoadingRequests: true,
        isLoadingSuggestions: true,
      ),
    );

    // Load cả friend requests và friend suggestions song song
    final requestsFuture = getFriendRequestsUseCase(received: true);
    final suggestionsFuture = getFriendSuggestionsUseCase(page: 1, limit: 10);

    final results = await Future.wait([requestsFuture, suggestionsFuture]);
    final requestsResult = results[0] as dynamic;
    final suggestionsResult = results[1] as dynamic;

    List<FriendRequestEntity> friendRequests = [];
    List<FriendSuggestionEntity> friendSuggestions = [];

    if (requestsResult is DataStateSuccess<List<FriendRequestEntity>>) {
      friendRequests = requestsResult.data!;
    }

    if (suggestionsResult is DataStateSuccess<List<FriendSuggestionEntity>>) {
      friendSuggestions = suggestionsResult.data!;
    }

    emit(
      FriendPageLoaded(
        friendRequests: friendRequests,
        friendSuggestions: friendSuggestions,
        isLoadingRequests: false,
        isLoadingSuggestions: false,
      ),
    );
  }

  Future<void> _onSendFriendRequest(
    SendFriendRequest event,
    Emitter<FriendState> emit,
  ) async {
    final currentState = state;

    final dataState = await sendFriendRequestUseCase(event.receiverId);

    if (dataState is DataStateSuccess) {
      // Cập nhật sentRequestUserIds trong state hiện tại
      if (currentState is FriendPageLoaded) {
        final updatedSentIds = Set<String>.from(currentState.sentRequestUserIds)
          ..add(event.receiverId);

        emit(currentState.copyWith(sentRequestUserIds: updatedSentIds));
      } else if (currentState is FriendSuggestionsLoaded) {
        final updatedSentIds = Set<String>.from(currentState.sentRequestUserIds)
          ..add(event.receiverId);

        emit(currentState.copyWith(sentRequestUserIds: updatedSentIds));
      }
      // Duy start edit
      else if (currentState is SentFriendRequestsLoaded) {
        add(LoadSentFriendRequests());
      }
      // Duy end edit
      else {
        emit(FriendActionSuccess(message: 'Đã gửi lời mời kết bạn'));
      }
    } else if (dataState is DataStateError) {
      emit(
        FriendActionError(
          message: dataState.error?.message ?? 'Lỗi không xác định',
        ),
      );
    }
  }

  Future<void> _onAcceptFriendRequest(
    AcceptFriendRequest event,
    Emitter<FriendState> emit,
  ) async {
    final currentState = state;

    final dataState = await acceptFriendRequestUseCase(event.requestId);

    if (dataState is DataStateSuccess) {
      // Cập nhật acceptedRequestIds trong state hiện tại
      if (currentState is FriendPageLoaded) {
        final updatedAcceptedIds = Set<String>.from(
          currentState.acceptedRequestIds,
        )..add(event.requestId);

        emit(currentState.copyWith(acceptedRequestIds: updatedAcceptedIds));
      } else if (currentState is FriendRequestsLoaded) {
        final updatedAcceptedIds = Set<String>.from(
          currentState.acceptedRequestIds,
        )..add(event.requestId);

        emit(currentState.copyWith(acceptedRequestIds: updatedAcceptedIds));
      } else {
        emit(FriendActionSuccess(message: 'Đã chấp nhận lời mời kết bạn'));
      }
    } else if (dataState is DataStateError) {
      final errorMessage = _getErrorMessage(dataState.error);
      emit(FriendActionError(message: errorMessage));
    }
  }

  Future<void> _onRejectFriendRequest(
    RejectFriendRequest event,
    Emitter<FriendState> emit,
  ) async {
    final currentState = state;

    final dataState = await rejectFriendRequestUseCase(event.requestId);

    if (dataState is DataStateSuccess) {
      // Cập nhật rejectedRequestIds trong state hiện tại
      if (currentState is FriendPageLoaded) {
        final updatedRejectedIds = Set<String>.from(
          currentState.rejectedRequestIds,
        )..add(event.requestId);

        emit(currentState.copyWith(rejectedRequestIds: updatedRejectedIds));
      } else if (currentState is FriendRequestsLoaded) {
        final updatedRejectedIds = Set<String>.from(
          currentState.rejectedRequestIds,
        )..add(event.requestId);

        emit(currentState.copyWith(rejectedRequestIds: updatedRejectedIds));
      } else {
        emit(FriendActionSuccess(message: 'Đã từ chối lời mời kết bạn'));
      }
    } else if (dataState is DataStateError) {
      final errorMessage = _getErrorMessage(dataState.error);
      emit(FriendActionError(message: errorMessage));
    }
  }

  Future<void> _onSortFriendRequests(
    SortFriendRequests event,
    Emitter<FriendState> emit,
  ) async {
    final currentState = state;
    if (currentState is FriendRequestsLoaded) {
      final sortedRequests = _sortFriendRequests(
        currentState.friendRequests,
        event.sortBy,
        event.ascending,
      );

      emit(
        currentState.copyWith(
          friendRequests: sortedRequests,
          sortBy: event.sortBy,
          ascending: event.ascending,
        ),
      );
    }
  }

  Future<void> _onFilterFriendRequests(
    FilterFriendRequests event,
    Emitter<FriendState> emit,
  ) async {
    final currentState = state;
    if (currentState is FriendRequestsLoaded) {
      final filteredRequests = _filterFriendRequests(
        currentState.friendRequests,
        event.searchQuery,
        event.minMutualFriends,
      );

      emit(
        currentState.copyWith(
          friendRequests: filteredRequests,
          searchQuery: event.searchQuery,
          minMutualFriends: event.minMutualFriends,
        ),
      );
    }
  }

  /// Helper method để sắp xếp friend requests
  List<FriendRequestEntity> _sortFriendRequests(
    List<FriendRequestEntity> requests,
    String sortBy,
    bool ascending,
  ) {
    final sortedRequests = List<FriendRequestEntity>.from(requests);

    switch (sortBy) {
      case 'name':
        sortedRequests.sort((a, b) {
          final comparison = a.displayName.compareTo(b.displayName);
          return ascending ? comparison : -comparison;
        });
      case 'mutualFriends':
        sortedRequests.sort((a, b) {
          final comparison = a.displayMutualFriends.compareTo(
            b.displayMutualFriends,
          );
          return ascending ? comparison : -comparison;
        });
      case 'time':
      default:
        sortedRequests.sort((a, b) {
          final aTime = a.createdAt ?? DateTime(1970);
          final bTime = b.createdAt ?? DateTime(1970);
          final comparison = aTime.compareTo(bTime);
          return ascending ? comparison : -comparison;
        });
    }

    return sortedRequests;
  }

  /// Helper method để lọc friend requests
  List<FriendRequestEntity> _filterFriendRequests(
    List<FriendRequestEntity> requests,
    String? searchQuery,
    int? minMutualFriends,
  ) {
    return requests.where((request) {
      // Lọc theo search query
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        if (!request.displayName.toLowerCase().contains(query) &&
            (request.displayUsername?.toLowerCase().contains(query) != true)) {
          return false;
        }
      }

      // Lọc theo số bạn chung tối thiểu
      if (minMutualFriends != null &&
          request.displayMutualFriends < minMutualFriends) {
        return false;
      }

      return true;
    }).toList();
  }

  Future<void> _onLoadSentFriendRequests(
    LoadSentFriendRequests event,
    Emitter<FriendState> emit,
  ) async {
    // Không emit loading nếu đang có dữ liệu (để tránh flicker)
    final currentState = state;
    if (currentState is! SentFriendRequestsLoaded) {
      emit(SentFriendRequestsLoading());
    }

    final dataState = await getSentFriendRequestsUseCase();

    if (dataState is DataStateSuccess) {
      emit(SentFriendRequestsLoaded(sentRequests: dataState.data!));
    } else if (dataState is DataStateError) {
      final errorMessage = _getErrorMessage(dataState.error);
      emit(FriendError(message: errorMessage));
    }
  }

  Future<void> _onCancelSentFriendRequest(
    CancelSentFriendRequest event,
    Emitter<FriendState> emit,
  ) async {
    final currentState = state;

    // Sử dụng cancelFriendRequest cho sent requests
    final dataState = await cancelFriendRequestUseCase(event.requestId);

    if (dataState is DataStateSuccess) {
      // Thêm requestId vào danh sách cancelled
      if (currentState is SentFriendRequestsLoaded) {
        final updatedCancelledIds = Set<String>.from(
          currentState.cancelledRequestIds,
        )..add(event.requestId);

        emit(currentState.copyWith(cancelledRequestIds: updatedCancelledIds));
      }

      // Không reload lại trang, chỉ giữ nguyên state đã cập nhật
    } else if (dataState is DataStateError) {
      final errorMessage = _getErrorMessage(dataState.error);
      emit(FriendActionError(message: errorMessage));
    }
  }

  Future<void> _onRemoveFriend(
    RemoveFriend event,
    Emitter<FriendState> emit,
  ) async {
    final dataState = await removeFriendUseCase(event.friendId);

    if (dataState is DataStateSuccess) {
      // Load lại danh sách bạn bè
      final friendsDataState = await getFriendsUseCase();
      if (friendsDataState is DataStateSuccess) {
        emit(FriendLoaded(friends: friendsDataState.data!));
      }
    } else if (dataState is DataStateError) {
      final errorMessage = _getErrorMessage(dataState.error);
      emit(FriendActionError(message: errorMessage));
    }
  }

  Future<void> _onRemoveFriendSuggestion(
    RemoveFriendSuggestion event,
    Emitter<FriendState> emit,
  ) async {
    final currentState = state;

    // Xóa gợi ý khỏi danh sách trong state hiện tại
    if (currentState is FriendPageLoaded) {
      final updatedSuggestions = currentState.friendSuggestions
          .where((suggestion) => suggestion.userId != event.userId)
          .toList();

      emit(currentState.copyWith(friendSuggestions: updatedSuggestions));
    } else if (currentState is FriendSuggestionsLoaded) {
      final updatedSuggestions = currentState.friendSuggestions
          .where((suggestion) => suggestion.userId != event.userId)
          .toList();

      emit(currentState.copyWith(friendSuggestions: updatedSuggestions));
    }
  }
}
