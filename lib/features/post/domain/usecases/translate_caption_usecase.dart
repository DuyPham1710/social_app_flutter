import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/post/domain/entities/post_translation_entity.dart';
import 'package:social_app_fe/features/post/domain/repository/post_repository.dart';

class TranslateCaptionUsecase
    implements UseCase<DataState<PostTranslationEntity>, TranslateCaptionParams> {
  final PostRepository _repository;

  TranslateCaptionUsecase(this._repository);

  @override
  Future<DataState<PostTranslationEntity>> call(
      {TranslateCaptionParams? params}) {
    final postId = params!.postId;
    final targetLang = params.targetLang;

    return _repository.translateCaption(
      postId: postId,
      targetLang: targetLang,
    );
  }
}

class TranslateCaptionParams {
  final String postId;
  final String targetLang;

  const TranslateCaptionParams({
    required this.postId,
    this.targetLang = 'vi',
  });
}

