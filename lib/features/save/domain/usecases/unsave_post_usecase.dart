import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/save/domain/repository/save_repository.dart';

class UnsavePostUsecase implements UseCase<DataState<void>, UnsavePostParams> {
  final SaveRepository _saveRepository;

  UnsavePostUsecase(this._saveRepository);

  @override
  Future<DataState<void>> call({UnsavePostParams? params}) {
    return _saveRepository.unsavePost(savedId: params!.savedId);
  }
}

class UnsavePostParams {
  final String savedId;

  const UnsavePostParams({required this.savedId});
}
