import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/profile/domain/repository/user_repository.dart';

class ReportUserUseCase implements UseCase<DataState<void>, ReportUserParams> {
  final UserRepository _repository;

  ReportUserUseCase(this._repository);

  @override
  Future<DataState<void>> call({ReportUserParams? params}) {
    return _repository.reportUser(
      reportedUserId: params!.reportedUserId,
      reason: params.reason,
      description: params.description,
    );
  }
}

class ReportUserParams {
  final String reportedUserId;
  final String reason;
  final String? description;

  const ReportUserParams({
    required this.reportedUserId,
    required this.reason,
    this.description,
  });
}
