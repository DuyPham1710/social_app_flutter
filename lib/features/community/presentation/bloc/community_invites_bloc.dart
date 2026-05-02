import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/community/domain/usecases/get_my_invites_usecase.dart';
import 'package:social_app_fe/features/community/domain/usecases/respond_to_invite_usecase.dart';

part 'community_invites_event.dart';
part 'community_invites_state.dart';

class CommunityInvitesBloc
    extends Bloc<CommunityInvitesEvent, CommunityInvitesState> {
  final GetMyInvitesUseCase _getMyInvitesUseCase;
  final RespondToInviteUseCase _respondToInviteUseCase;

  CommunityInvitesBloc({
    required GetMyInvitesUseCase getMyInvitesUseCase,
    required RespondToInviteUseCase respondToInviteUseCase,
  }) : _getMyInvitesUseCase = getMyInvitesUseCase,
       _respondToInviteUseCase = respondToInviteUseCase,
       super(const CommunityInvitesInitial()) {
    on<FetchCommunityInvitesEvent>(_onFetchInvites);
    on<RespondToInviteEvent>(_onRespondToInvite);
    on<RefreshInvitesEvent>(_onRefreshInvites);
  }

  Future<void> _onFetchInvites(
    FetchCommunityInvitesEvent event,
    Emitter<CommunityInvitesState> emit,
  ) async {
    emit(CommunityInvitesLoading());

    final dataState = await _getMyInvitesUseCase.call(params: null);

    if (dataState is DataStateSuccess) {
      final invites = dataState.data ?? [];
      if (invites.isEmpty) {
        emit(CommunityInvitesEmpty());
      } else {
        emit(CommunityInvitesLoaded(invites: invites));
      }
    } else if (dataState is DataStateError) {
      emit(
        CommunityInvitesError(
          message: dataState.error?.message ?? 'Không thể tải lời mời',
        ),
      );
    }
  }

  Future<void> _onRespondToInvite(
    RespondToInviteEvent event,
    Emitter<CommunityInvitesState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CommunityInvitesLoaded &&
        currentState is! CommunityInvitesSuccess) {
      return;
    }

    emit(CommunityInvitesProcessing());

    // Get current invites from state
    List<dynamic> currentInvites = [];
    if (currentState is CommunityInvitesLoaded) {
      currentInvites = currentState.invites;
    } else if (currentState is CommunityInvitesSuccess) {
      currentInvites = currentState.invites;
    }

    // Respond to invite
    final dataState = await _respondToInviteUseCase.call(
      params: RespondToInviteParams(
        communityId: event.communityId,
        requestId: event.requestId,
        action: event.action,
      ),
    );

    if (dataState is DataStateSuccess) {
      // Remove the responded invite from list
      final updatedInvites = currentInvites.where((invite) {
        // Safely extract ID from dynamic object
        String inviteId = '';
        if (invite is Map) {
          inviteId = (invite['_id'] ?? invite['id'] ?? '').toString();
        }
        return inviteId != event.requestId;
      }).toList();

      String message = event.action == 'approve'
          ? 'Đã chấp nhận lời mời'
          : 'Đã từ chối lời mời';

      if (updatedInvites.isEmpty) {
        emit(CommunityInvitesEmpty());
      } else {
        emit(
          CommunityInvitesSuccess(message: message, invites: updatedInvites),
        );
      }
    } else if (dataState is DataStateError) {
      // Restore to loaded state on error
      emit(CommunityInvitesLoaded(invites: currentInvites));
      emit(
        CommunityInvitesError(
          message: dataState.error?.message ?? 'Không thể xử lý lời mời',
        ),
      );
    }
  }

  Future<void> _onRefreshInvites(
    RefreshInvitesEvent event,
    Emitter<CommunityInvitesState> emit,
  ) async {
    // Fetch invites again
    add(FetchCommunityInvitesEvent());
  }
}
