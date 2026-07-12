import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/core/utils/error_utils.dart';
import 'package:social_app_fe/features/profile/domain/usecases/update_user_profile_usecase.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_state.dart';
import 'package:social_app_fe/features/post/domain/usecases/get_profile_posts_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/listen_comment_count_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/load_comment_usecase.dart';
import 'dart:async';
import 'package:social_app_fe/features/profile/domain/usecases/get_user_profile_usecase.dart';

import 'package:social_app_fe/features/auth/domain/usecases/delete_face_registration_usecase.dart';
import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/core/di/injection.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final GetProfilePostsUseCase getProfilePostsUseCase;
  final ListenCommentCountUseCase listenCommentCountUseCase;
  final LoadCommentsUseCase loadCommentsUseCase;

  final UpdateUserProfileUseCase updateUserProfileUseCase;
  final DeleteFaceRegistrationUsecase deleteFaceRegistrationUsecase;

  StreamSubscription? _commentCountSubscription;
  ProfileBloc({
    required this.getProfilePostsUseCase,
    required this.listenCommentCountUseCase,
    required this.loadCommentsUseCase,
    required this.getUserProfileUseCase,
    required this.updateUserProfileUseCase,
    required this.deleteFaceRegistrationUsecase,
  }) : super(ProfileInitial()) {
    on<LoadUserProfileEvent>(_onLoadUserProfile);
    on<LoadProfilePostsEvent>(_onLoadProfilePosts);
    on<LoadMoreProfilePostsEvent>(_onLoadMoreProfilePosts);
    on<UpdateProfileCommentCountsEvent>(_onUpdateCommentCounts);

    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
    on<DeleteFaceDataEvent>(_onDeleteFaceData);
    _commentCountSubscription =
        listenCommentCountUseCase(params: const NoParams()).listen((counts) {
          add(UpdateProfileCommentCountsEvent(counts));
        });
  }

  Future<void> _onUpdateUserProfile(
    UpdateUserProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;

    // Chỉ thực hiện khi đang ở trạng thái Loaded (đã có data để sửa)
    if (currentState is ProfileLoaded) {
      // 1. Emit trạng thái đang update (loading quay vòng)
      emit(
        currentState.copyWith(
          isUpdating: true,
          updateSuccess: false,
          updateError: null,
        ),
      );

      // 2. Gọi API
      final result = await updateUserProfileUseCase(event.params);

      // 3. Xử lý kết quả
      if (result is DataStateSuccess && result.data != null) {
        if (result.data is UserModel) {
          final updatedUser = result.data as UserModel;
          TokenStorage.saveUserData({
            'id': updatedUser.userId,
            'fullName': updatedUser.fullName,
            'email': updatedUser.email,
            'username': updatedUser.username,
            'avatarUrl': updatedUser.avatarUrl,
          });
        }

        // Thành công: Cập nhật user mới vào state -> UI tự đổi
        emit(
          currentState.copyWith(
            isUpdating: false,
            updateSuccess: true,
            user: result.data,
          ),
        );
      } else {
        // Thất bại
        emit(
          currentState.copyWith(
            isUpdating: false,
            updateSuccess: false,
            updateError: result.error?.message ?? "Cập nhật thất bại",
          ),
        );
      }
    }
  }

  Future<void> _onLoadProfilePosts(
    LoadProfilePostsEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    emit(
      ProfileLoading(
        posts: currentState.posts,
        commentCounts: currentState.commentCounts,
        user: currentState.user,
      ),
    );

    final result = await getProfilePostsUseCase(
      params: GetProfilePostsParams(page: event.page, limit: event.limit),
    );

    if (result is DataStateSuccess && result.data != null) {
      final postListEntity = result.data!;

      for (final post in postListEntity.data) {
        loadCommentsUseCase(params: LoadCommentsParams(post.id));
      }

      emit(
        ProfileLoaded(
          postListEntity.data,
          currentPage: postListEntity.page,
          limit: postListEntity.limit,
          hasNext: postListEntity.hasNext,
          commentCounts: {},
          user: currentState.user,
        ),
      );
    } else {
      emit(ProfileError(ErrorUtils.getErrorMessage(result.error!)));
    }
  }

  Future<void> _onLoadMoreProfilePosts(
    LoadMoreProfilePostsEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;

    if (currentState is! ProfileLoaded ||
        currentState.hasNext != true ||
        currentState.isLoadingMore)
      return;

    emit(
      ProfileLoaded(
        currentState.posts!,
        commentCounts: currentState.commentCounts,
        currentPage: currentState.currentPage,
        limit: currentState.limit,
        hasNext: currentState.hasNext,
        isLoadingMore: true,
        user: currentState.user,
      ),
    );

    final nextPage = (currentState.currentPage ?? 1) + 1;

    final result = await getProfilePostsUseCase(
      params: GetProfilePostsParams(
        page: nextPage,
        limit: currentState.limit ?? 4,
      ),
    );

    if (result is DataStateSuccess && result.data != null) {
      final newPosts = [...currentState.posts!, ...result.data!.data];

      for (final post in result.data!.data) {
        loadCommentsUseCase(params: LoadCommentsParams(post.id));
      }

      emit(
        ProfileLoaded(
          newPosts,
          commentCounts: currentState.commentCounts,
          currentPage: result.data!.page,
          limit: result.data!.limit,
          hasNext: result.data!.hasNext,
          isLoadingMore: false,
          user: currentState.user,
        ),
      );
    } else {
      emit(
        ProfileLoaded(
          currentState.posts!,
          commentCounts: currentState.commentCounts,
          currentPage: currentState.currentPage,
          limit: currentState.limit,
          hasNext: currentState.hasNext,
          isLoadingMore: false,
          user: currentState.user,
        ),
      );
    }
  }

  Future<void> _onLoadUserProfile(
    LoadUserProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());

    final result = await getUserProfileUseCase();

    if (result is DataStateSuccess && result.data != null) {
      emit(ProfileLoaded([], user: result.data));
      add(LoadProfilePostsEvent());
    } else {
      emit(ProfileError(result.error?.toString() ?? "Không thể tải user"));
    }
  }

  void _onUpdateCommentCounts(
    UpdateProfileCommentCountsEvent event,
    Emitter<ProfileState> emit,
  ) {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      emit(
        ProfileLoaded(
          currentState.posts!,
          commentCounts: event.commentCounts,
          currentPage: currentState.currentPage,
          limit: currentState.limit,
          hasNext: currentState.hasNext,
          isLoadingMore: currentState.isLoadingMore,
          user: currentState.user,
        ),
      );
    }
  }

  Future<void> _onDeleteFaceData(
    DeleteFaceDataEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProfileLoaded && currentState.user != null) {
      emit(
        currentState.copyWith(
          isDeletingFace: true,
          deleteFaceSuccess: false,
          deleteFaceError: null,
        ),
      );

      final result = await deleteFaceRegistrationUsecase();

      if (result is DataStateSuccess) {
        // Cập nhật isFaceRegistered = false trong UserModel hiện tại
        final updatedUser = (currentState.user as UserModel).copyWith(
          isFaceRegistered: false,
        );

        emit(
          currentState.copyWith(
            user: updatedUser,
            isDeletingFace: false,
            deleteFaceSuccess: true,
          ),
        );
      } else {
        emit(
          currentState.copyWith(
            isDeletingFace: false,
            deleteFaceSuccess: false,
            deleteFaceError: result.error?.message ?? "Xóa thất bại",
          ),
        );
      }
    }
  }

  @override
  Future<void> close() {
    _commentCountSubscription?.cancel();
    return super.close();
  }
}
