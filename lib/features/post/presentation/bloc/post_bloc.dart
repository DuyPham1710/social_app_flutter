import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/post/domain/usecases/create_post_usecase.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final CreatePostUsecase _createPostUsecase;

  PostBloc(this._createPostUsecase) : super(PostInitial()) {
    on<CreatePostRequested>(_onCreatePostRequested);
  }

  Future<void> _onCreatePostRequested(
    CreatePostRequested event,
    Emitter<PostState> emit,
  ) async {
    emit(PostCreating());

    try {
      final dataState = await _createPostUsecase(params: event.postEntity);

      if (dataState is DataStateSuccess<String>) {
        emit(PostCreated(message: dataState.data!));
      } else if (dataState is DataStateError) {
        emit(
          PostCreateError(
            message:
                dataState.error?.message ?? 'Có lỗi xảy ra khi tạo bài viết',
          ),
        );
      }
    } catch (e) {
      emit(PostCreateError(message: 'Có lỗi xảy ra: ${e.toString()}'));
    }
  }
}
