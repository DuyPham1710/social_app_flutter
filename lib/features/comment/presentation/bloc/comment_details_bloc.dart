import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/utils/error_utils.dart';
import 'package:social_app_fe/features/comment/domain/usecases/get_comments_loaded_data_usecase.dart';
import 'package:social_app_fe/features/comment/presentation/bloc/comment_details_event.dart';
import 'package:social_app_fe/features/comment/presentation/bloc/comment_details_state.dart';

class CommentDetailsBloc
    extends Bloc<CommentDetailsEvent, CommentDetailsState> {
  final GetCommentsLoadedDataUseCase getCommentsLoadedDataUseCase;

  CommentDetailsBloc({required this.getCommentsLoadedDataUseCase})
    : super(CommentDetailsInitial()) {
    on<LoadCommentDetailsEvent>(_onLoadCommentDetails);
    on<RefreshCommentDetailsEvent>(_onRefreshCommentDetails);
  }

  Future<void> _onLoadCommentDetails(
    LoadCommentDetailsEvent event,
    Emitter<CommentDetailsState> emit,
  ) async {
    emit(CommentDetailsLoading());
    await _loadCommentDetails(event.postId, emit);
  }

  Future<void> _onRefreshCommentDetails(
    RefreshCommentDetailsEvent event,
    Emitter<CommentDetailsState> emit,
  ) async {
    // Refresh không show loading để UX tốt hơn
    await _loadCommentDetails(event.postId, emit);
  }

  Future<void> _loadCommentDetails(
    String postId,
    Emitter<CommentDetailsState> emit,
  ) async {
    final dataState = await getCommentsLoadedDataUseCase(
      params: GetCommentsLoadedDataParams(postId),
    );

    if (dataState is DataStateSuccess) {
      if (dataState.data == null) {
        // Chưa có data, hiển thị empty state
        emit(CommentDetailsEmpty(postId));
      } else {
        // Có data, hiển thị comments
        emit(CommentDetailsLoaded(dataState.data!));
      }
    } else if (dataState is DataStateError) {
      final errorMessage = ErrorUtils.getErrorMessage(dataState.error!);
      emit(CommentDetailsError(dataState.error!, errorMessage: errorMessage));
    }
  }
}
