import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/save/data/models/saved_list_model.dart';
import 'package:social_app_fe/features/save/domain/repository/save_repository.dart';

class GetSavedItemsParams {
  final String? type;
  final String? collection;
  final int page;
  final int limit;

  GetSavedItemsParams({
    this.type,
    this.collection,
    this.page = 1,
    this.limit = 20,
  });
}

class GetSavedItemsUsecase
    implements UseCase<DataState<SavedListModel>, GetSavedItemsParams> {
  final SaveRepository _saveRepository;

  GetSavedItemsUsecase(this._saveRepository);

  @override
  Future<DataState<SavedListModel>> call({GetSavedItemsParams? params}) {
    return _saveRepository.getSavedByUser(
      type: params?.type,
      collection: params?.collection,
      page: params?.page,
      limit: params?.limit,
    );
  }
}
