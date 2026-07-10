import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/friend/domain/entities/activity_summary_entity.dart';
import 'package:social_app_fe/features/friend/domain/repository/friend_repository.dart';

class GetFriendActivitiesSummaryUseCase
    implements
        UseCase<
          DataState<ActivitySummaryEntity>,
          GetFriendActivitiesSummaryParams
        > {
  final FriendRepository _friendRepository;

  GetFriendActivitiesSummaryUseCase(this._friendRepository);

  @override
  Future<DataState<ActivitySummaryEntity>> call({
    GetFriendActivitiesSummaryParams? params,
  }) {
    return _friendRepository.getFriendActivitiesSummary(
      params!.targetUserId,
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}

class GetFriendActivitiesSummaryParams {
  final String targetUserId;
  final String? startDate;
  final String? endDate;

  GetFriendActivitiesSummaryParams({
    required this.targetUserId,
    this.startDate,
    this.endDate,
  });
}
