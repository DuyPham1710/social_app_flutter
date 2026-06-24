import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/community/domain/usecases/get_roadmap_points_usecase.dart';
import 'package:social_app_fe/features/community/domain/usecases/get_nearby_roadmap_points_usecase.dart';
import 'community_roadmap_event.dart';
import 'community_roadmap_state.dart';

class CommunityRoadmapBloc extends Bloc<CommunityRoadmapEvent, CommunityRoadmapState> {
  final GetRoadmapPointsUseCase _getRoadmapPointsUseCase;
  final GetNearbyRoadmapPointsUseCase _getNearbyRoadmapPointsUseCase;

  CommunityRoadmapBloc(
    this._getRoadmapPointsUseCase,
    this._getNearbyRoadmapPointsUseCase,
  ) : super(const CommunityRoadmapState.initial()) {
    on<GetRoadmapPointsRequested>(_onGetRoadmapPoints);
    on<GetNearbyRoadmapPointsRequested>(_onGetNearbyRoadmapPoints);
  }

  Future<void> _onGetRoadmapPoints(
    GetRoadmapPointsRequested event,
    Emitter<CommunityRoadmapState> emit,
  ) async {
    emit(const CommunityRoadmapState.loading());
    final dataState = await _getRoadmapPointsUseCase(params: {
      'communityId': event.communityId,
      'limit': event.limit,
    });

    if (dataState is DataStateSuccess && dataState.data != null) {
      emit(CommunityRoadmapState.loaded(dataState.data!.data));
    } else {
      emit(CommunityRoadmapState.error(dataState.error?.message ?? 'Unknown error'));
    }
  }

  Future<void> _onGetNearbyRoadmapPoints(
    GetNearbyRoadmapPointsRequested event,
    Emitter<CommunityRoadmapState> emit,
  ) async {
    emit(const CommunityRoadmapState.loading());
    final dataState = await _getNearbyRoadmapPointsUseCase(params: {
      'communityId': event.communityId,
      'lat': event.lat,
      'lng': event.lng,
      'radius': event.radius,
    });

    if (dataState is DataStateSuccess && dataState.data != null) {
      emit(CommunityRoadmapState.loaded(dataState.data!.data));
    } else {
      emit(CommunityRoadmapState.error(dataState.error?.message ?? 'Unknown error'));
    }
  }
}
