import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/community/data/models/community_post_model.dart';
import 'package:social_app_fe/features/community/data/models/community_request_model.dart';
import 'package:social_app_fe/features/community/domain/usecases/get_pending_requests_usecase.dart';
import 'package:social_app_fe/features/community/domain/usecases/respond_to_join_request_usecase.dart';
import 'package:social_app_fe/features/community/domain/repository/community_repository.dart';

part 'community_admin_event.dart';
part 'community_admin_state.dart';

class CommunityAdminBloc
    extends Bloc<CommunityAdminEvent, CommunityAdminState> {
  final GetPendingRequestsUseCase _getPendingRequestsUseCase;
  final RespondToJoinRequestUseCase _respondToJoinRequestUseCase;
  final CommunityRepository _communityRepository;

  CommunityAdminBloc(
    this._getPendingRequestsUseCase,
    this._respondToJoinRequestUseCase,
    this._communityRepository,
  ) : super(const CommunityAdminInitial()) {
    on<GetPendingRequestsRequested>(_onGetPendingRequestsRequested);
    on<RespondToJoinRequestRequested>(_onRespondToJoinRequestRequested);
    on<GetPendingPostsRequested>(_onGetPendingPostsRequested);
    on<ApproveCommunityPostRequested>(_onApproveCommunityPostRequested);
    on<KickMemberRequested>(_onKickMemberRequested);
    on<PromoteToAdminRequested>(_onPromoteToAdminRequested);
    on<DemoteAdminRequested>(_onDemoteAdminRequested);
  }

  Future<void> _onGetPendingRequestsRequested(
    GetPendingRequestsRequested event,
    Emitter<CommunityAdminState> emit,
  ) async {
    emit(const CommunityAdminLoading());

    try {
      final dataState = await _getPendingRequestsUseCase(
        params: event.communityId,
      );

      if (dataState is DataStateSuccess) {
        emit(PendingRequestsLoaded(dataState.data!));
      } else if (dataState is DataStateError) {
        final errorMessage =
            '${dataState.error?.response?.data?['message'] ?? dataState.error?.message ?? 'Đã xảy ra lỗi'}';
        emit(CommunityAdminError(errorMessage));
      }
    } catch (e) {
      emit(CommunityAdminError('Đã xảy ra lỗi: ${e.toString()}'));
    }
  }

  Future<void> _onRespondToJoinRequestRequested(
    RespondToJoinRequestRequested event,
    Emitter<CommunityAdminState> emit,
  ) async {
    try {
      final dataState = await _respondToJoinRequestUseCase(
        params: RespondToJoinRequestParams(
          communityId: event.communityId,
          requestId: event.requestId,
          action: event.action,
        ),
      );

      if (dataState is DataStateSuccess) {
        emit(
          CommunityAdminActionSuccess(
            event.action == 'approve'
                ? 'Đã chấp nhận yêu cầu'
                : 'Đã từ chối yêu cầu',
          ),
        );
        // Refresh
        add(GetPendingRequestsRequested(event.communityId));
      } else if (dataState is DataStateError) {
        final errorMessage =
            '${dataState.error?.response?.data?['message'] ?? dataState.error?.message ?? 'Đã xảy ra lỗi'}';
        emit(CommunityAdminError(errorMessage));
      }
    } catch (e) {
      emit(CommunityAdminError('Đã xảy ra lỗi: ${e.toString()}'));
    }
  }

  Future<void> _onGetPendingPostsRequested(
    GetPendingPostsRequested event,
    Emitter<CommunityAdminState> emit,
  ) async {
    emit(const CommunityAdminLoading());

    try {
      final dataState = await _communityRepository.getPendingPosts(
        communityId: event.communityId,
        page: event.page,
        limit: event.limit,
      );

      if (dataState is DataStateSuccess) {
        emit(
          PendingPostsLoaded(
            posts: dataState.data!,
            page: event.page,
            limit: event.limit,
          ),
        );
      } else if (dataState is DataStateError) {
        final errorMessage =
            '${dataState.error?.response?.data?['message'] ?? dataState.error?.message ?? 'Đã xảy ra lỗi'}';
        emit(CommunityAdminError(errorMessage));
      }
    } catch (e) {
      emit(CommunityAdminError('Đã xảy ra lỗi: ${e.toString()}'));
    }
  }

  Future<void> _onApproveCommunityPostRequested(
    ApproveCommunityPostRequested event,
    Emitter<CommunityAdminState> emit,
  ) async {
    try {
      final dataState = await _communityRepository.approveCommunityPost(
        communityId: event.communityId,
        postId: event.postId,
        action: event.action,
      );

      if (dataState is DataStateSuccess) {
        emit(
          CommunityAdminActionSuccess(
            event.action == 'approve'
                ? 'Đã duyệt bài viết'
                : 'Đã từ chối bài viết',
          ),
        );
      } else if (dataState is DataStateError) {
        final errorMessage =
            '${dataState.error?.response?.data?['message'] ?? dataState.error?.message ?? 'Đã xảy ra lỗi'}';
        emit(CommunityAdminError(errorMessage));
      }
    } catch (e) {
      emit(CommunityAdminError('Đã xảy ra lỗi: ${e.toString()}'));
    }
  }

  Future<void> _onKickMemberRequested(
    KickMemberRequested event,
    Emitter<CommunityAdminState> emit,
  ) async {
    try {
      final dataState = await _communityRepository.kickMember(
        communityId: event.communityId,
        memberId: event.memberId,
      );

      if (dataState is DataStateSuccess) {
        emit(const CommunityAdminActionSuccess('Đã xóa thành viên'));
      } else if (dataState is DataStateError) {
        final errorMessage =
            '${dataState.error?.response?.data?['message'] ?? dataState.error?.message ?? 'Đã xảy ra lỗi'}';
        emit(CommunityAdminError(errorMessage));
      }
    } catch (e) {
      emit(CommunityAdminError('Đã xảy ra lỗi: ${e.toString()}'));
    }
  }

  Future<void> _onPromoteToAdminRequested(
    PromoteToAdminRequested event,
    Emitter<CommunityAdminState> emit,
  ) async {
    try {
      final dataState = await _communityRepository.promoteToAdmin(
        communityId: event.communityId,
        memberId: event.memberId,
      );

      if (dataState is DataStateSuccess) {
        emit(const CommunityAdminActionSuccess('Đã nâng quyền thành viên'));
      } else if (dataState is DataStateError) {
        final errorMessage =
            '${dataState.error?.response?.data?['message'] ?? dataState.error?.message ?? 'Đã xảy ra lỗi'}';
        emit(CommunityAdminError(errorMessage));
      }
    } catch (e) {
      emit(CommunityAdminError('Đã xảy ra lỗi: ${e.toString()}'));
    }
  }

  Future<void> _onDemoteAdminRequested(
    DemoteAdminRequested event,
    Emitter<CommunityAdminState> emit,
  ) async {
    try {
      final dataState = await _communityRepository.demoteAdmin(
        communityId: event.communityId,
        memberId: event.memberId,
      );

      if (dataState is DataStateSuccess) {
        emit(const CommunityAdminActionSuccess('Đã hạ quyền admin'));
      } else if (dataState is DataStateError) {
        final errorMessage =
            '${dataState.error?.response?.data?['message'] ?? dataState.error?.message ?? 'Đã xảy ra lỗi'}';
        emit(CommunityAdminError(errorMessage));
      }
    } catch (e) {
      emit(CommunityAdminError('Đã xảy ra lỗi: ${e.toString()}'));
    }
  }
}
