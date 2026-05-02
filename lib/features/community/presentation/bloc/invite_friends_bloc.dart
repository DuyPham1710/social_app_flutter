import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/community/domain/usecases/get_available_friends_usecase.dart';
import 'package:social_app_fe/features/community/domain/usecases/invite_friend_usecase.dart';

part 'invite_friends_event.dart';
part 'invite_friends_state.dart';

class InviteFriendsBloc extends Bloc<InviteFriendsEvent, InviteFriendsState> {
  final GetAvailableFriendsUseCase _getAvailableFriendsUseCase;
  final InviteFriendUseCase _inviteFriendUseCase;

  InviteFriendsBloc({
    required GetAvailableFriendsUseCase getAvailableFriendsUseCase,
    required InviteFriendUseCase inviteFriendUseCase,
  }) : _getAvailableFriendsUseCase = getAvailableFriendsUseCase,
       _inviteFriendUseCase = inviteFriendUseCase,
       super(InviteFriendsInitial()) {
    on<GetAvailableFriendsEvent>(_onGetAvailableFriends);
    on<InviteFriendEvent>(_onInviteFriend);
  }

  Future<void> _onGetAvailableFriends(
    GetAvailableFriendsEvent event,
    Emitter<InviteFriendsState> emit,
  ) async {
    emit(InviteFriendsLoading());

    final dataState = await _getAvailableFriendsUseCase.call(
      params: GetAvailableFriendsParams(communityId: event.communityId),
    );

    if (dataState is DataStateSuccess) {
      emit(InviteFriendsLoaded(friends: dataState.data ?? []));
    } else if (dataState is DataStateError) {
      emit(
        InviteFriendsError(
          message: dataState.error?.message ?? 'Lỗi khi tải danh sách bạn bè',
        ),
      );
    }
  }

  Future<void> _onInviteFriend(
    InviteFriendEvent event,
    Emitter<InviteFriendsState> emit,
  ) async {
    final currentState = state;

    // Get current friends list from either Loaded or Success state
    List<dynamic> currentFriends = [];
    if (currentState is InviteFriendsLoaded) {
      currentFriends = currentState.friends;
    } else if (currentState is InviteFriendsSuccess) {
      currentFriends = currentState.friends;
    } else {
      return; // Can't invite without a valid friend list
    }

    emit(InviteFriendsInviting());

    final dataState = await _inviteFriendUseCase.call(
      params: InviteFriendParams(
        communityId: event.communityId,
        userId: event.userId,
      ),
    );

    if (dataState is DataStateSuccess) {
      // Safely filter out the invited friend from the list
      final updatedFriends = <dynamic>[];
      try {
        for (var friend in currentFriends) {
          String friendId = '';
          if (friend is Map) {
            friendId = (friend['_id'] ?? friend['id'] ?? friend['userId'] ?? '')
                .toString();
          }
          if (friendId.isNotEmpty && friendId != event.userId) {
            updatedFriends.add(friend);
          }
        }
      } catch (e) {
        // If filtering fails, keep all friends
        updatedFriends.addAll(currentFriends);
      }

      emit(
        InviteFriendsSuccess(
          message: 'Đã gửi lời mời thành công',
          friends: updatedFriends,
        ),
      );
    } else if (dataState is DataStateError) {
      // Restore to loaded state with current friends if error occurs
      emit(InviteFriendsLoaded(friends: currentFriends));
      emit(
        InviteFriendsError(
          message: dataState.error?.message ?? 'Không thể gửi lời mời',
        ),
      );
    }
  }
}
