import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/community/data/models/community_model.dart';
import 'package:social_app_fe/features/community/data/models/community_invite_model.dart';
import 'package:social_app_fe/features/community/domain/usecases/cancel_join_request_usecase.dart';
import 'package:social_app_fe/features/community/domain/usecases/get_all_communities_usecase.dart';
import 'package:social_app_fe/features/community/domain/usecases/get_my_communities_usecase.dart';
import 'package:social_app_fe/features/community/domain/usecases/get_my_invites_usecase.dart';

part 'community_list_event.dart';
part 'community_list_state.dart';

class CommunityListBloc extends Bloc<CommunityListEvent, CommunityListState> {
  final GetAllCommunitiesUseCase _getAllCommunitiesUseCase;
  final GetMyCommunitiesUseCase _getMyCommunitiesUseCase;
  final GetMyInvitesUseCase _getMyInvitesUseCase;
  final CancelJoinRequestUseCase _cancelJoinRequestUseCase;

  CommunityListBloc(
    this._getAllCommunitiesUseCase,
    this._getMyCommunitiesUseCase,
    this._getMyInvitesUseCase,
    this._cancelJoinRequestUseCase,
  ) : super(const CommunityListInitial()) {
    on<CommunityListFetched>(_onCommunityListFetched);
    on<CommunityListSearched>(_onCommunityListSearched);
    on<MyCommunitiesFetched>(_onMyCommunitiesFetched);
    on<MyInvitesFetched>(_onMyInvitesFetched);
    on<PendingCommunitiesFetched>(_onPendingCommunitiesFetched);
    on<CancelPendingCommunityRequested>(_onCancelPendingCommunityRequested);
  }

  Future<void> _onCommunityListFetched(
    CommunityListFetched event,
    Emitter<CommunityListState> emit,
  ) async {
    emit(const CommunityListLoading());

    try {
      final dataState = await _getAllCommunitiesUseCase(
        params: GetAllCommunitiesParams(
          page: event.page,
          limit: event.limit,
          search: event.search,
        ),
      );

      if (dataState is DataStateSuccess) {
        emit(
          CommunityListLoaded(
            communities: dataState.data!.data,
            page: dataState.data!.page,
            limit: dataState.data!.limit,
            total: dataState.data!.total,
            hasNext: dataState.data!.hasNext,
            searchQuery: event.search,
          ),
        );
      } else if (dataState is DataStateError) {
        final errorMessage =
            '${dataState.error?.response?.data?['message'] ?? dataState.error?.message ?? 'Đã xảy ra lỗi'}';
        emit(CommunityListError(errorMessage));
      }
    } catch (e) {
      emit(CommunityListError('Đã xảy ra lỗi: ${e.toString()}'));
    }
  }

  Future<void> _onCommunityListSearched(
    CommunityListSearched event,
    Emitter<CommunityListState> emit,
  ) async {
    emit(const CommunityListLoading());

    try {
      final dataState = await _getAllCommunitiesUseCase(
        params: GetAllCommunitiesParams(
          page: 1,
          limit: 10,
          search: event.query.isNotEmpty ? event.query : null,
        ),
      );

      if (dataState is DataStateSuccess) {
        emit(
          CommunityListLoaded(
            communities: dataState.data!.data,
            page: dataState.data!.page,
            limit: dataState.data!.limit,
            total: dataState.data!.total,
            hasNext: dataState.data!.hasNext,
            searchQuery: event.query.isNotEmpty ? event.query : null,
          ),
        );
      } else if (dataState is DataStateError) {
        final errorMessage =
            '${dataState.error?.response?.data?['message'] ?? dataState.error?.message ?? 'Đã xảy ra lỗi'}';
        emit(CommunityListError(errorMessage));
      }
    } catch (e) {
      emit(CommunityListError('Đã xảy ra lỗi: ${e.toString()}'));
    }
  }

  Future<void> _onMyCommunitiesFetched(
    MyCommunitiesFetched event,
    Emitter<CommunityListState> emit,
  ) async {
    emit(const CommunityListLoading());

    try {
      final dataState = await _getMyCommunitiesUseCase(params: null);

      if (dataState is DataStateSuccess) {
        emit(MyCommunitiesLoaded(dataState.data!));
      } else if (dataState is DataStateError) {
        final errorMessage =
            '${dataState.error?.response?.data?['message'] ?? dataState.error?.message ?? 'Đã xảy ra lỗi'}';
        emit(CommunityListError(errorMessage));
      }
    } catch (e) {
      emit(CommunityListError('Đã xảy ra lỗi: ${e.toString()}'));
    }
  }

  Future<void> _onMyInvitesFetched(
    MyInvitesFetched event,
    Emitter<CommunityListState> emit,
  ) async {
    emit(const CommunityListLoading());

    try {
      final dataState = await _getMyInvitesUseCase(params: null);

      if (dataState is DataStateSuccess) {
        // dataState.data is already List<CommunityInviteModel> from Retrofit deserialization
        final invites = (dataState.data ?? []) as List<CommunityInviteModel>;
        emit(MyInvitesLoaded(invites));
      } else if (dataState is DataStateError) {
        final errorMessage =
            '${dataState.error?.response?.data?['message'] ?? dataState.error?.message ?? 'Đã xảy ra lỗi'}';
        emit(CommunityListError(errorMessage));
      }
    } catch (e) {
      emit(CommunityListError('Đã xảy ra lỗi: ${e.toString()}'));
    }
  }

  Future<void> _onPendingCommunitiesFetched(
    PendingCommunitiesFetched event,
    Emitter<CommunityListState> emit,
  ) async {
    emit(const CommunityListLoading());

    try {
      // Get all communities and filter for pending join requests
      final dataState = await _getAllCommunitiesUseCase(
        params: GetAllCommunitiesParams(
          page: 1,
          limit: 100, // Get more to find pending ones
          search: null,
        ),
      );

      if (dataState is DataStateSuccess) {
        // Filter communities where memberStatus == 'pending'
        final pendingCommunities = dataState.data!.data
            .where((community) => community.memberStatus == 'pending')
            .toList();

        emit(PendingCommunitiesLoaded(pendingCommunities));
      } else if (dataState is DataStateError) {
        final errorMessage =
            '${dataState.error?.response?.data?['message'] ?? dataState.error?.message ?? 'Đã xảy ra lỗi'}';
        emit(CommunityListError(errorMessage));
      }
    } catch (e) {
      emit(CommunityListError('Đã xảy ra lỗi: ${e.toString()}'));
    }
  }

  Future<void> _onCancelPendingCommunityRequested(
    CancelPendingCommunityRequested event,
    Emitter<CommunityListState> emit,
  ) async {
    try {
      final dataState = await _cancelJoinRequestUseCase(
        params: event.communityId,
      );

      if (dataState is DataStateSuccess) {
        final currentState = state;
        if (currentState is PendingCommunitiesLoaded) {
          final updatedCommunities = currentState.communities
              .where(
                (community) => community.id.toString() != event.communityId,
              )
              .toList();

          emit(const CommunityListActionSuccess('Đã hủy yêu cầu tham gia'));
          emit(PendingCommunitiesLoaded(updatedCommunities));
        } else {
          emit(const CommunityListActionSuccess('Đã hủy yêu cầu tham gia'));
          add(const PendingCommunitiesFetched());
        }
      } else if (dataState is DataStateError) {
        final errorMessage =
            '${dataState.error?.response?.data?["message"] ?? dataState.error?.message ?? 'Đã xảy ra lỗi'}';
        emit(CommunityListError(errorMessage));
      }
    } catch (e) {
      emit(CommunityListError('Đã xảy ra lỗi: ${e.toString()}'));
    }
  }
}
