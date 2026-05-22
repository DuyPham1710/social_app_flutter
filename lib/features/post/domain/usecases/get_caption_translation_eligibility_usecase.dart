import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/post/domain/entities/caption_translation_eligibility_entity.dart';
import 'package:social_app_fe/features/post/domain/repository/post_repository.dart';

class GetCaptionTranslationEligibilityUsecase
    implements
        UseCase<
          DataState<CaptionTranslationEligibilityEntity>,
          GetCaptionTranslationEligibilityParams
        > {
  final PostRepository _repository;

  GetCaptionTranslationEligibilityUsecase(this._repository);

  @override
  Future<DataState<CaptionTranslationEligibilityEntity>> call({
    GetCaptionTranslationEligibilityParams? params,
  }) {
    return _repository.getCaptionTranslationEligibility(
      postId: params!.postId,
      targetLang: params.targetLang,
    );
  }
}

class GetCaptionTranslationEligibilityParams {
  final String postId;
  final String targetLang;

  const GetCaptionTranslationEligibilityParams({
    required this.postId,
    this.targetLang = 'en',
  });
}
