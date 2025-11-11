import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/utils/privacy_util.dart';
import 'package:social_app_fe/features/privacy/domain/usecases/get_default_privacy_usecase.dart';
import 'package:social_app_fe/features/privacy/domain/usecases/set_default_privacy_usecase.dart';
import 'privacy_event.dart';
import 'privacy_state.dart';

class PrivacyBloc extends Bloc<PrivacyEvent, PrivacyState> {
  final GetDefaultPrivacyUseCase _getDefaultPrivacyUseCase;
  final SetDefaultPrivacyUseCase _setDefaultPrivacyUseCase;

  PrivacyBloc(this._getDefaultPrivacyUseCase, this._setDefaultPrivacyUseCase)
    : super(PrivacyInitial()) {
    on<GetDefaultPrivacyRequested>(_onGetDefaultPrivacyRequested);
    on<PrivacySelectionChanged>(_onPrivacySelectionChanged);
    on<SetDefaultPrivacyRequested>(_onSetDefaultPrivacyRequested);
  }

  Future<void> _onGetDefaultPrivacyRequested(
    GetDefaultPrivacyRequested event,
    Emitter<PrivacyState> emit,
  ) async {
    emit(PrivacyLoading());

    try {
      final dataState = await _getDefaultPrivacyUseCase();

      if (dataState is DataStateSuccess) {
        final privacyEntity = dataState.data!;
        final defaultPrivacyLabel = PrivacyUtil.privacyTypeToLabel(
          privacyEntity.defaultPrivacy,
        );

        emit(
          PrivacyLoaded(
            privacyEntity: privacyEntity,
            selectedPrivacy: defaultPrivacyLabel,
          ),
        );
      } else if (dataState is DataStateError) {
        emit(
          PrivacyError(
            message:
                dataState.error?.message ??
                'Có lỗi xảy ra khi tải privacy settings',
          ),
        );
      }
    } catch (e) {
      emit(PrivacyError(message: 'Có lỗi xảy ra: ${e.toString()}'));
    }
  }

  void _onPrivacySelectionChanged(
    PrivacySelectionChanged event,
    Emitter<PrivacyState> emit,
  ) {
    final currentState = state;
    if (currentState is PrivacyLoaded) {
      emit(currentState.copyWith(selectedPrivacy: event.selectedPrivacy));
    }
  }

  Future<void> _onSetDefaultPrivacyRequested(
    SetDefaultPrivacyRequested event,
    Emitter<PrivacyState> emit,
  ) async {
    final currentState = state;
    if (currentState is PrivacyLoaded) {
      emit(PrivacyUpdating());

      try {
        final dataState = await _setDefaultPrivacyUseCase(
          params: event.privacyEntity,
        );

        if (dataState is DataStateSuccess) {
          final updatedPrivacyEntity = dataState.data!;
          final defaultPrivacyLabel = PrivacyUtil.privacyTypeToLabel(
            updatedPrivacyEntity.defaultPrivacy,
          );

          emit(
            PrivacyUpdated(
              privacyEntity: updatedPrivacyEntity,
              message: 'Đã cập nhật privacy mặc định thành công',
            ),
          );

          // Return to loaded state with updated data
          emit(
            PrivacyLoaded(
              privacyEntity: updatedPrivacyEntity,
              selectedPrivacy: defaultPrivacyLabel,
            ),
          );
        } else if (dataState is DataStateError) {
          emit(
            PrivacyError(
              message:
                  dataState.error?.message ??
                  'Có lỗi xảy ra khi cập nhật privacy settings',
            ),
          );

          // Return to previous loaded state
          emit(currentState);
        }
      } catch (e) {
        emit(PrivacyError(message: 'Có lỗi xảy ra: ${e.toString()}'));

        // Return to previous loaded state
        emit(currentState);
      }
    }
  }
}
