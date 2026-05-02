import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/community/data/models/community_model.dart';
import 'package:social_app_fe/features/community/domain/usecases/get_community_detail_usecase.dart';
import 'package:social_app_fe/features/community/domain/usecases/get_member_status_usecase.dart';
import 'package:social_app_fe/features/community/domain/usecases/join_community_usecase.dart';
import 'package:social_app_fe/features/community/domain/usecases/cancel_join_request_usecase.dart';
import 'package:social_app_fe/features/community/domain/usecases/leave_community_usecase.dart';
import 'package:social_app_fe/features/community/domain/usecases/respond_to_invite_usecase.dart';

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

  factory CommunityDetailBloc() {
    return CommunityDetailBloc.withDeps(
      s1<GetCommunityDetailUseCase>(),
      s1<GetMemberStatusUseCase>(),
      s1<JoinCommunityUseCase>(),
      s1<CancelJoinRequestUseCase>(),
      s1<LeaveCommunityUseCase>(),
      s1<RespondToInviteUseCase>(),
    );
  }

  CommunityDetailBloc.withDeps(
    this._getCommunityDetailUseCase,
    this._getMemberStatusUseCase,
    this._joinCommunityUseCase,
    this._cancelJoinRequestUseCase,
    this._leaveCommunityUseCase,
    this._respondToInviteUseCase,
  ) : super(const CommunityDetailInitial()) {
    on<CommunityDetailFetched>(_onCommunityDetailFetched);
    on<JoinCommunityRequested>(_onJoinCommunityRequested);
    on<CancelJoinRequestRequested>(_onCancelJoinRequestRequested);
    on<LeaveCommunityRequested>(_onLeaveCommunityRequested);
    on<MemberStatusFetched>(_onMemberStatusFetched);
    on<RespondToInviteRequested>(_onRespondToInviteRequested);
  }

  Future<void> _onCommunityDetailFetched(
    CommunityDetailFetched event,
    Emitter<CommunityDetailState> emit,
  ) async {
    emit(const CommunityDetailLoading());

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
        emit(CommunityDetailError(errorMessage));
      }
    } catch (e) {
      emit(CommunityDetailError('Đã xảy ra lỗi: ${e.toString()}'));
    }
  }

  Future<void> _onJoinCommunityRequested(
    JoinCommunityRequested event,
    Emitter<CommunityDetailState> emit,
  ) async {
    try {
      final dataState = await _joinCommunityUseCase(params: event.communityId);

      if (dataState is DataStateSuccess) {
        emit(const CommunityActionSuccess('Đã gửi yêu cầu tham gia cộng đồng'));
        // Refresh detail
        add(CommunityDetailFetched(event.communityId));
      } else if (dataState is DataStateError) {
        final errorMessage =
            '${dataState.error?.response?.data?['message'] ?? dataState.error?.message ?? 'Đã xảy ra lỗi'}';
        emit(CommunityDetailError(errorMessage));
      }
    } catch (e) {
      emit(CommunityDetailError('Đã xảy ra lỗi: ${e.toString()}'));
    }
  }

  Future<void> _onLeaveCommunityRequested(
    LeaveCommunityRequested event,
    Emitter<CommunityDetailState> emit,
  ) async {
    try {
      final dataState = await _leaveCommunityUseCase(params: event.communityId);

      if (dataState is DataStateSuccess) {
        emit(const CommunityActionSuccess('Đã rời khỏi cộng đồng'));
      } else if (dataState is DataStateError) {
        final errorMessage =
            '${dataState.error?.response?.data?['message'] ?? dataState.error?.message ?? 'Đã xảy ra lỗi'}';
        emit(CommunityDetailError(errorMessage));
      }
    } catch (e) {
      emit(CommunityDetailError('Đã xảy ra lỗi: ${e.toString()}'));
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
        emit(const CommunityActionSuccess('Đã hủy yêu cầu tham gia'));
        add(CommunityDetailFetched(event.communityId));
      } else if (dataState is DataStateError) {
        final errorMessage =
            '${dataState.error?.response?.data?['message'] ?? dataState.error?.message ?? 'Đã xảy ra lỗi'}';
        emit(CommunityDetailError(errorMessage));
      }
    } catch (e) {
      emit(CommunityDetailError('Đã xảy ra lỗi: ${e.toString()}'));
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
          ),
        );
        // Refresh
        add(CommunityDetailFetched(event.communityId));
      } else if (dataState is DataStateError) {
        final errorMessage =
            '${dataState.error?.response?.data?['message'] ?? dataState.error?.message ?? 'Đã xảy ra lỗi'}';
        emit(CommunityDetailError(errorMessage));
      }
    } catch (e) {
      emit(CommunityDetailError('Đã xảy ra lỗi: ${e.toString()}'));
    }
  }
}
