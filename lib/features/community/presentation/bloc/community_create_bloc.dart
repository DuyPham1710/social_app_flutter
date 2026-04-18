import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/community/domain/usecases/create_community_usecase.dart';
import 'package:social_app_fe/features/community/presentation/bloc/community_create_event.dart';
import 'package:social_app_fe/features/community/presentation/bloc/community_create_state.dart';

class CommunityCreateBloc
    extends Bloc<CommunityCreateEvent, CommunityCreateState> {
  final CreateCommunityUseCase _createCommunityUseCase;

  CommunityCreateBloc(this._createCommunityUseCase)
      : super(const CommunityCreateInitial()) {
    on<CreateCommunityRequested>(_onCreateCommunityRequested);
  }

  Future<void> _onCreateCommunityRequested(
    CreateCommunityRequested event,
    Emitter<CommunityCreateState> emit,
  ) async {
    emit(const CommunityCreateLoading());

    try {
      final dataState = await _createCommunityUseCase(
        params: CreateCommunityParams(
          name: event.name,
          description: event.description,
          privacy: event.privacy ,
          avatar: event.avatarPath ,
          coverImage: event.coverImagePath,
        ),
      );

      if (dataState is DataStateSuccess) {
        emit(CommunityCreateSuccess(
          community: dataState.data!,
          message: 'Tạo cộng đồng thành công',
        ));
      } else if (dataState is DataStateError) {
        final errorMessage = '${dataState.error?.response?.data?['message'] ?? dataState.error?.message ?? 'Đã xảy ra lỗi'}';
        emit(CommunityCreateError(errorMessage));
      }
    } catch (e) {
      emit(CommunityCreateError('Đã xảy ra lỗi: ${e.toString()}'));
    }
  }
}
