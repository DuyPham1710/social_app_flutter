import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/friend/domain/usecases/get_friend_activities_summary.dart';
import 'friend_activity_summary_state.dart';

class FriendActivitySummaryCubit extends Cubit<FriendActivitySummaryState> {
  final GetFriendActivitiesSummaryUseCase _getFriendActivitiesSummaryUseCase;

  FriendActivitySummaryCubit(this._getFriendActivitiesSummaryUseCase)
      : super(FriendActivitySummaryInitial());

  Future<void> loadSummary(String targetUserId, {String? startDate, String? endDate, String? language}) async {
    emit(FriendActivitySummaryLoading());
    
    final result = await _getFriendActivitiesSummaryUseCase(
      params: GetFriendActivitiesSummaryParams(
        targetUserId: targetUserId,
        startDate: startDate,
        endDate: endDate,
        language: language,
      ),
    );

    if (result is DataStateSuccess && result.data != null) {
      emit(FriendActivitySummaryLoaded(result.data!));
    } else if (result is DataStateError) {
      emit(FriendActivitySummaryError(result.error?.message ?? 'Đã xảy ra lỗi khi lấy tóm tắt hoạt động'));
    } else {
      emit(const FriendActivitySummaryError('Lỗi không xác định'));
    }
  }
}
