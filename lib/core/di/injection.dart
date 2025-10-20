import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:social_app_fe/core/network/dio_client.dart';
import 'package:social_app_fe/core/network/websocket/socket_client.dart';
import 'package:social_app_fe/features/auth/data/data_sources/auth_service.dart';
import 'package:social_app_fe/features/auth/data/repository/auth_repository_impl.dart';
import 'package:social_app_fe/features/auth/domain/repository/auth_repository.dart';
import 'package:social_app_fe/features/auth/domain/usecases/login_usecase.dart';
import 'package:social_app_fe/features/auth/domain/usecases/register_usecase.dart';
import 'package:social_app_fe/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:social_app_fe/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:social_app_fe/features/auth/domain/usecases/update_personal_info_usecase.dart';
import 'package:social_app_fe/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:social_app_fe/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:social_app_fe/features/comment/data/data_sources/remote/comment_remote_data_source.dart';
import 'package:social_app_fe/features/comment/data/repository/comment_repository_impl.dart';
import 'package:social_app_fe/features/comment/domain/repository/comment_repository.dart';
import 'package:social_app_fe/features/comment/domain/usecases/add_comment_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/clear_comments_cache_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/connect_comment_socket_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/emit_typing_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/get_comment_count_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/get_comments_loaded_data_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/join_post_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/leave_post_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/listen_comment_count_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/listen_comments_loaded_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/listen_typing_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/load_comment_usecase.dart';
import 'package:social_app_fe/features/comment/presentation/bloc/comment_bloc.dart';
import 'package:social_app_fe/features/comment/presentation/bloc/comment_details_bloc.dart';
import 'package:social_app_fe/features/friend/data/data_sources/friend_service.dart';
import 'package:social_app_fe/features/friend/data/repository/friend_repository_impl.dart';
import 'package:social_app_fe/features/friend/domain/repository/friend_repository.dart';
import 'package:social_app_fe/features/friend/domain/usecases/accept_friend_request_usecase.dart';
import 'package:social_app_fe/features/friend/domain/usecases/cancel_friend_request_usecase.dart';
import 'package:social_app_fe/features/friend/domain/usecases/get_friend_requests_usecase.dart';
import 'package:social_app_fe/features/friend/domain/usecases/get_friend_suggestions_usecase.dart';
import 'package:social_app_fe/features/friend/domain/usecases/get_friends_usecase.dart';
import 'package:social_app_fe/features/friend/domain/usecases/get_sent_friend_requests_usecase.dart';
import 'package:social_app_fe/features/friend/domain/usecases/reject_friend_request_usecase.dart';
import 'package:social_app_fe/features/friend/domain/usecases/send_friend_request_usecase.dart';
import 'package:social_app_fe/features/friend/presentation/bloc/friend_bloc.dart';
import 'package:social_app_fe/features/home/presentation/bloc/home_bloc.dart';
import 'package:social_app_fe/features/post/data/data_sources/remote/post_remote_data_source.dart';
import 'package:social_app_fe/features/post/data/repository/post_repository_impl.dart';
import 'package:social_app_fe/features/post/domain/repository/post_repository.dart';
import 'package:social_app_fe/features/post/domain/usecases/get_home_posts_usecase.dart';
import 'package:social_app_fe/features/post/presentation/bloc/post_detail_bloc.dart';

final s1 = GetIt.instance;

Future<void> initializeDependencies() async {
  // Dio
  s1.registerSingleton<Dio>(DioClient.instance);

  // WebSocket - Generic SocketClient
  s1.registerSingleton<SocketClient>(SocketClient());

  // DataSources
  s1.registerLazySingleton<AuthService>(() => AuthService(s1()));
  s1.registerLazySingleton<FriendService>(() => FriendService(s1()));
  s1.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSource(s1()),
  );

  s1.registerLazySingleton<CommentRemoteDataSource>(
    () => CommentRemoteDataSource(s1()),
  );

  // Repositories
  s1.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(s1()));
  s1.registerLazySingleton<FriendRepository>(() => FriendRepositoryImpl(s1()));
  s1.registerLazySingleton<PostRepository>(() => PostRepositoryImpl(s1()));
  s1.registerLazySingleton<CommentRepository>(
    () => CommentRepositoryImpl(s1()),
  );

  // Usecases
  s1.registerLazySingleton<LoginUsecase>(() => LoginUsecase(s1()));
  s1.registerLazySingleton<RegisterUsecase>(() => RegisterUsecase(s1()));
  s1.registerLazySingleton<VerifyOtpUsecase>(() => VerifyOtpUsecase(s1()));
  s1.registerLazySingleton<ResendOtpUsecase>(() => ResendOtpUsecase(s1()));
  s1.registerLazySingleton<ResetPasswordUsecase>(
    () => ResetPasswordUsecase(s1()),
  );
  s1.registerLazySingleton<UpdatePersonalInfoUsecase>(
    () => UpdatePersonalInfoUsecase(s1()),
  );

  s1.registerLazySingleton<GetHomePostsUseCase>(
    () => GetHomePostsUseCase(s1()),
  );

  // Comment UseCases
  s1.registerLazySingleton<ConnectCommentSocketUseCase>(
    () => ConnectCommentSocketUseCase(s1()),
  );
  s1.registerLazySingleton<JoinPostUseCase>(() => JoinPostUseCase(s1()));
  s1.registerLazySingleton<LeavePostUseCase>(() => LeavePostUseCase(s1()));
  s1.registerLazySingleton<EmitTypingUseCase>(() => EmitTypingUseCase(s1()));
  s1.registerLazySingleton<ListenTypingUseCase>(
    () => ListenTypingUseCase(s1()),
  );
  s1.registerLazySingleton<GetCommentCountUseCase>(
    () => GetCommentCountUseCase(s1()),
  );
  s1.registerLazySingleton<ListenCommentCountUseCase>(
    () => ListenCommentCountUseCase(s1()),
  );
  s1.registerLazySingleton<LoadCommentsUseCase>(
    () => LoadCommentsUseCase(s1()),
  );

  s1.registerLazySingleton<GetCommentsLoadedDataUseCase>(
    () => GetCommentsLoadedDataUseCase(s1()),
  );

  s1.registerLazySingleton<ListenCommentsLoadedUseCase>(
    () => ListenCommentsLoadedUseCase(s1()),
  );

  s1.registerLazySingleton<ClearCommentsCacheUseCase>(
    () => ClearCommentsCacheUseCase(s1()),
  );

  s1.registerLazySingleton<AddCommentUseCase>(() => AddCommentUseCase(s1()));

  // Friend Usecases
  s1.registerLazySingleton<GetFriendsUseCase>(() => GetFriendsUseCase(s1()));
  s1.registerLazySingleton<GetFriendRequestsUseCase>(
    () => GetFriendRequestsUseCase(s1()),
  );
  s1.registerLazySingleton<GetFriendSuggestionsUseCase>(
    () => GetFriendSuggestionsUseCase(s1()),
  );
  s1.registerLazySingleton<SendFriendRequestUseCase>(
    () => SendFriendRequestUseCase(s1()),
  );
  s1.registerLazySingleton<AcceptFriendRequestUseCase>(
    () => AcceptFriendRequestUseCase(s1()),
  );
  s1.registerLazySingleton<RejectFriendRequestUseCase>(
    () => RejectFriendRequestUseCase(s1()),
  );
  s1.registerLazySingleton<CancelFriendRequestUseCase>(() => CancelFriendRequestUseCase(s1()));

  // Blocs
  s1.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUsecase: s1(),
      registerUsecase: s1(),
      verifyOtpUsecase: s1(),
      resendOtpUsecase: s1(),
      resetPasswordUsecase: s1(),
      updatePersonalInfoUsecase: s1(),
    ),
  );

  s1.registerFactory<HomeBloc>(
    () => HomeBloc(
      getHomePostsUseCase: s1(),
      connectCommentSocketUseCase: s1(),
      listenCommentCountUseCase: s1(),
      loadCommentsUseCase: s1(),
    ),
  );

  s1.registerFactory<PostDetailBloc>(
    () => PostDetailBloc(
      joinPostUseCase: s1(),
      leavePostUseCase: s1(),
      listenCommentCountUseCase: s1(),
      loadCommentsUseCase: s1(),
    ),
  );

  s1.registerFactory<CommentBloc>(
    () => CommentBloc(
      joinPostUseCase: s1(),
      leavePostUseCase: s1(),
      emitTypingUseCase: s1(),
      listenTypingUseCase: s1(),
      addCommentUseCase: s1(),
    ),
  );

  s1.registerFactory<CommentDetailsBloc>(
    () => CommentDetailsBloc(
      getCommentsLoadedDataUseCase: s1(),
      listenCommentsLoadedUseCase: s1(),
      clearCommentsCacheUseCase: s1(),
    ),
  );

  s1.registerFactory<FriendBloc>(
    () => FriendBloc(
      getFriendsUseCase: s1(),
      getFriendRequestsUseCase: s1(),
      getSentFriendRequestsUseCase: s1(),
      getFriendSuggestionsUseCase: s1(),
      sendFriendRequestUseCase: s1(),
      acceptFriendRequestUseCase: s1(),
      rejectFriendRequestUseCase: s1(),
      cancelFriendRequestUseCase: s1(),
    ),
  );
}
