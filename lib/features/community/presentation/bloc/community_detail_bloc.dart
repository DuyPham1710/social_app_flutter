import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/community/data/models/community_model.dart';
import 'package:social_app_fe/features/community/domain/usecases/get_community_detail_usecase.dart';
import 'package:social_app_fe/features/community/domain/usecases/get_member_status_usecase.dart';
import 'package:social_app_fe/features/community/domain/usecases/join_community_usecase.dart';
import 'package:social_app_fe/features/community/domain/usecases/cancel_join_request_usecase.dart';
import 'package:social_app_fe/features/community/domain/usecases/leave_community_usecase.dart';
import 'package:social_app_fe/features/community/domain/usecases/respond_to_invite_usecase.dart';
import 'package:social_app_fe/features/community/domain/usecases/delete_community_usecase.dart';

part 'community_detail_event.dart';
part 'community_detail_state.dart';

class CommunityDetailBloc
    extends Bloc<CommunityDetailEvent, CommunityDetailState> {
  final GetCommunityDetailUseCase _getCommunityDetailUseCase;
  final GetMemberStatusUseCase _getMemberStatusUseCase;
  final JoinCommunityUseCase _joinCommunityUseCase;
  final CancelJoinRequestUseCase _cancelJoinRequestUseCase;
  final LeaveCommunityUseCase _leaveCommunityUseCase;
  final RespondToInviteUseCase _respondToInviteUseCase;
  final DeleteCommunityUseCase _deleteCommunityUseCase;

  CommunityDetailBloc({
    required GetCommunityDetailUseCase getCommunityDetailUseCase,
    required GetMemberStatusUseCase getMemberStatusUseCase,
    required JoinCommunityUseCase joinCommunityUseCase,
    required CancelJoinRequestUseCase cancelJoinRequestUseCase,
    required LeaveCommunityUseCase leaveCommunityUseCase,
    required RespondToInviteUseCase respondToInviteUseCase,
    required DeleteCommunityUseCase deleteCommunityUseCase,
  })  : _getCommunityDetailUseCase = getCommunityDetailUseCase,
        _getMemberStatusUseCase = getMemberStatusUseCase,
        _joinCommunityUseCase = joinCommunityUseCase,
        _cancelJoinRequestUseCase = cancelJoinRequestUseCase,
        _leaveCommunityUseCase = leaveCommunityUseCase,
        _respondToInviteUseCase = respondToInviteUseCase,
        _deleteCommunityUseCase = deleteCommunityUseCase,
        super(CommunityDetailInitial()) {
    on<CommunityDetailFetched>(_onCommunityDetailFetched);
    on<JoinCommunityRequested>(_onJoinCommunityRequested);
    on<CancelJoinRequestRequested>(_onCancelJoinRequestRequested);
    on<LeaveCommunityRequested>(_onLeaveCommunityRequested);
    on<MemberStatusFetched>(_onMemberStatusFetched);
    on<RespondToInviteRequested>(_onRespondToInviteRequested);
    on<DeleteCommunityRequested>(_onDeleteCommunityRequested);
  }

  Future<void> _onCommunityDetailFetched(
    CommunityDetailFetched event,
    Emitter<CommunityDetailState> emit,
  ) async {
    emit(CommunityDetailLoading());

    try {
      final dataState = await _getCommunityDetailUseCase(
        params: event.communityId,
      );

      if (dataState is DataStateSuccess) {
        final statusDataState = await _getMemberStatusUseCase(
          params: event.communityId,
        );

        if (statusDataState is DataStateSuccess) {
          final memberStatus = statusDataState.data!.status;
          final userRole = statusDataState.data!.role;

          emit(
            CommunityDetailLoaded(
              community: dataState.data!,
              memberStatus: memberStatus,
              userRole: userRole,
            ),
          );
        } else {
          emit(
            CommunityDetailLoaded(
              community: dataState.data!,
              memberStatus: 'none',
              userRole: null,
            ),
          );
        }
      } else if (dataState is DataStateError) {
        final errorMessage =
            '${dataState.error?.response?.data?['message'] ?? dataState.error?.message ?? 'Đã xảy ra lỗi'}';
        emit(
          CommunityDetailError(errorMessage, communityId: event.communityId),
        );
      }
    } catch (e) {
      emit(
        CommunityDetailError(
          'Đã xảy ra lỗi: ${e.toString()}',
          communityId: event.communityId,
        ),
      );
    }
  }

  Future<void> _onJoinCommunityRequested(
    JoinCommunityRequested event,
    Emitter<CommunityDetailState> emit,
  ) async {
    try {
      final dataState = await _joinCommunityUseCase(params: event.communityId);

      if (dataState is DataStateSuccess) {
        emit(
          CommunityActionSuccess(
            'Đã gửi yêu cầu tham gia cộng đồng',
            communityId: event.communityId,
          ),
        );
        // Refresh detail
        add(CommunityDetailFetched(event.communityId));
      } else if (dataState is DataStateError) {
        final errorMessage =
            '${dataState.error?.response?.data?['message'] ?? dataState.error?.message ?? 'Đã xảy ra lỗi'}';
        emit(
          CommunityDetailError(errorMessage, communityId: event.communityId),
        );
      }
    } catch (e) {
      emit(
        CommunityDetailError(
          'Đã xảy ra lỗi: ${e.toString()}',
          communityId: event.communityId,
        ),
      );
    }
  }

  Future<void> _onLeaveCommunityRequested(
    LeaveCommunityRequested event,
    Emitter<CommunityDetailState> emit,
  ) async {
    try {
      final dataState = await _leaveCommunityUseCase(params: event.communityId);

      if (dataState is DataStateSuccess) {
        emit(
          CommunityActionSuccess(
            'Đã rời khỏi cộng đồng',
            communityId: event.communityId,
          ),
        );
      } else if (dataState is DataStateError) {
        final errorMessage =
            '${dataState.error?.response?.data?['message'] ?? dataState.error?.message ?? 'Đã xảy ra lỗi'}';
        emit(
          CommunityDetailError(errorMessage, communityId: event.communityId),
        );
      }
    } catch (e) {
      emit(
        CommunityDetailError(
          'Đã xảy ra lỗi: ${e.toString()}',
          communityId: event.communityId,
        ),
      );
    }
  }

  Future<void> _onCancelJoinRequestRequested(
    CancelJoinRequestRequested event,
    Emitter<CommunityDetailState> emit,
  ) async {
    try {
      final dataState = await _cancelJoinRequestUseCase(
        params: event.communityId,
      );

      if (dataState is DataStateSuccess) {
        emit(
          CommunityActionSuccess(
            'Đã hủy yêu cầu tham gia',
            communityId: event.communityId,
          ),
        );
        add(CommunityDetailFetched(event.communityId));
      } else if (dataState is DataStateError) {
        final errorMessage =
            '${dataState.error?.response?.data?['message'] ?? dataState.error?.message ?? 'Đã xảy ra lỗi'}';
        emit(
          CommunityDetailError(errorMessage, communityId: event.communityId),
        );
      }
    } catch (e) {
      emit(
        CommunityDetailError(
          'Đã xảy ra lỗi: ${e.toString()}',
          communityId: event.communityId,
        ),
      );
    }
  }

  Future<void> _onMemberStatusFetched(
    MemberStatusFetched event,
    Emitter<CommunityDetailState> emit,
  ) async {
    try {
      final dataState = await _getMemberStatusUseCase(
        params: event.communityId,
      );

      if (dataState is DataStateSuccess) {
        final memberStatus = dataState.data!.status;
        final userRole = dataState.data!.role;

        if (state is CommunityDetailLoaded) {
          final currentState = state as CommunityDetailLoaded;
          emit(
            CommunityDetailLoaded(
              community: currentState.community,
              memberStatus: memberStatus,
              userRole: userRole,
            ),
          );
        }
      }
    } catch (e) {
      // Silent fail for status check
    }
  }

  Future<void> _onRespondToInviteRequested(
    RespondToInviteRequested event,
    Emitter<CommunityDetailState> emit,
  ) async {
    try {
      final dataState = await _respondToInviteUseCase(
        params: RespondToInviteParams(
          communityId: event.communityId,
          requestId: event.requestId,
          action: event.action,
        ),
      );

      if (dataState is DataStateSuccess) {
        emit(
          CommunityActionSuccess(
            event.action == 'approve'
                ? 'Đã chấp nhận lời mời'
                : 'Đã từ chối lời mời',
            requestId: event.requestId,
            communityId: event.communityId,
          ),
        );
        // Refresh
        add(CommunityDetailFetched(event.communityId));
      } else if (dataState is DataStateError) {
        final errorMessage =
            '${dataState.error?.response?.data?['message'] ?? dataState.error?.message ?? 'Đã xảy ra lỗi'}';
        emit(
          CommunityDetailError(errorMessage, communityId: event.communityId),
        );
      }
    } catch (e) {
      emit(
        CommunityDetailError(
          'Đã xảy ra lỗi: ${e.toString()}',
          communityId: event.communityId,
        ),
      );
    }
  }

  Future<void> _onDeleteCommunityRequested(
    DeleteCommunityRequested event,
    Emitter<CommunityDetailState> emit,
  ) async {
    emit(CommunityDetailLoading());
    try {
      final dataState = await _deleteCommunityUseCase(
        params: event.communityId,
      );

      if (dataState is DataStateSuccess) {
        emit(
          CommunityActionSuccess(
            'Đã xóa cộng đồng thành công',
            communityId: event.communityId,
          ),
        );
      } else if (dataState is DataStateError) {
        final errorMessage =
            '${dataState.error?.response?.data?['message'] ?? dataState.error?.message ?? 'Đã xảy ra lỗi'}';
        emit(
          CommunityDetailError(errorMessage, communityId: event.communityId),
        );
      }
    } catch (e) {
      emit(
        CommunityDetailError(
          'Đã xảy ra lỗi: ${e.toString()}',
          communityId: event.communityId,
        ),
      );
    }
  }
}
