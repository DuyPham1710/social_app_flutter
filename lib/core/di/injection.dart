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
import 'package:social_app_fe/features/chat/data/data_sources/chat_remote_data_source.dart';
import 'package:social_app_fe/features/chat/data/data_sources/chat_remote_data_source_impl.dart';
import 'package:social_app_fe/features/chat/data/repository/chat_repository_impl.dart';
import 'package:social_app_fe/features/chat/domain/repository/chat_repository.dart';
import 'package:social_app_fe/features/chat/domain/usecases/chat_usecases.dart';
import 'package:social_app_fe/features/chat/domain/usecases/send_message_with_files_usecase.dart';
import 'package:social_app_fe/features/chat/presentation/bloc/bloc.dart';
import 'package:social_app_fe/features/video_call/data/data_sources/video_call_remote_data_source.dart';
import 'package:social_app_fe/features/video_call/data/repository/video_call_repository_impl.dart';
import 'package:social_app_fe/features/video_call/domain/repository/video_call_repository.dart';
import 'package:social_app_fe/features/video_call/domain/usecases/video_call_usecases.dart';
import 'package:social_app_fe/features/video_call/presentation/bloc/bloc.dart';
import 'package:social_app_fe/features/comment/data/data_sources/remote/comment_remote_data_source.dart';
import 'package:social_app_fe/features/comment/data/repository/comment_repository_impl.dart';
import 'package:social_app_fe/features/comment/domain/repository/comment_repository.dart';
import 'package:social_app_fe/features/comment/domain/usecases/add_comment_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/clear_comments_cache_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/connect_comment_socket_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/delete_comment_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/emit_typing_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/get_comment_count_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/get_comments_loaded_data_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/join_post_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/leave_post_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/listen_comment_count_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/listen_comments_loaded_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/listen_typing_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/load_comment_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/load_comment_history_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/listen_comment_history_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/update_comment_usecase.dart';
import 'package:social_app_fe/features/comment/presentation/bloc/comment_bloc.dart';
import 'package:social_app_fe/features/comment/presentation/bloc/comment_details_bloc.dart';
import 'package:social_app_fe/features/friend/data/data_sources/friend_service.dart';
import 'package:social_app_fe/features/friend/data/repository/friend_repository_impl.dart';
import 'package:social_app_fe/features/friend/domain/repository/friend_repository.dart';
import 'package:social_app_fe/features/friend/domain/usecases/accept_friend_request_usecase.dart';
import 'package:social_app_fe/features/friend/domain/usecases/cancel_friend_request_usecase.dart';
import 'package:social_app_fe/features/friend/domain/usecases/get_friend_relationship_usecase.dart';
import 'package:social_app_fe/features/friend/domain/usecases/get_friend_requests_usecase.dart';
import 'package:social_app_fe/features/friend/domain/usecases/get_friend_suggestions_usecase.dart';
import 'package:social_app_fe/features/friend/domain/usecases/get_friends_by_userid_usecase.dart';
import 'package:social_app_fe/features/friend/domain/usecases/get_friends_usecase.dart';
import 'package:social_app_fe/features/friend/domain/usecases/get_sent_friend_requests_usecase.dart';
import 'package:social_app_fe/features/friend/domain/usecases/reject_friend_request_usecase.dart';
import 'package:social_app_fe/features/friend/domain/usecases/remove_friend_usecase.dart';
import 'package:social_app_fe/features/friend/domain/usecases/send_friend_request_usecase.dart';
import 'package:social_app_fe/features/friend/presentation/bloc/friend_bloc.dart';
import 'package:social_app_fe/features/friend/presentation/bloc/friend_for_user_bloc.dart';
import 'package:social_app_fe/features/home/presentation/bloc/home_bloc.dart';
import 'package:social_app_fe/features/post/data/data_sources/remote/post_remote_data_source.dart';
import 'package:social_app_fe/features/post/data/repository/post_repository_impl.dart';
import 'package:social_app_fe/features/post/domain/repository/post_repository.dart';
import 'package:social_app_fe/features/post/domain/usecases/get_home_posts_usecase.dart';
import 'package:social_app_fe/features/post/domain/usecases/get_post_detail_usecase.dart';
import 'package:social_app_fe/features/post/domain/usecases/get_profile_posts_usecase.dart';
import 'package:social_app_fe/features/post/domain/usecases/get_user_posts_usecase.dart';
import 'package:social_app_fe/features/post/domain/usecases/react_post_usecase.dart';
import 'package:social_app_fe/features/post/domain/usecases/report_post_usecase.dart';
import 'package:social_app_fe/features/post/domain/usecases/create_post_usecase.dart';
import 'package:social_app_fe/features/post/presentation/bloc/post_detail_bloc.dart';
import 'package:social_app_fe/features/post/presentation/bloc/post_bloc.dart';
import 'package:social_app_fe/features/profile/data/repository/user_repository_impl.dart';
import 'package:social_app_fe/features/profile/domain/repository/user_repository.dart';
import 'package:social_app_fe/features/profile/domain/usecases/get_other_user_profile_usecase.dart';
import 'package:social_app_fe/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:social_app_fe/features/profile/domain/usecases/update_user_profile_usecase.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/friend_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:social_app_fe/features/story/data/data_sources/remote/story_remote_data_source.dart';
import 'package:social_app_fe/features/story/data/repository/story_repository_impl.dart';
import 'package:social_app_fe/features/story/domain/repository/story_repository.dart';
import 'package:social_app_fe/features/story/domain/usecases/get_home_stories_usecase.dart';
import 'package:social_app_fe/features/story/presentation/bloc/home_stories_bloc.dart';
import 'package:social_app_fe/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:social_app_fe/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:social_app_fe/features/profile/data/data_sources/user_remote_data_source.dart';
import 'package:social_app_fe/features/privacy/data/data_sources/remote/privacy_remote_data_source.dart';
import 'package:social_app_fe/features/privacy/data/repository/privacy_repository_impl.dart';
import 'package:social_app_fe/features/privacy/domain/repository/privacy_repository.dart';
import 'package:social_app_fe/features/privacy/domain/usecases/get_default_privacy_usecase.dart';
import 'package:social_app_fe/features/privacy/domain/usecases/set_default_privacy_usecase.dart';
import 'package:social_app_fe/features/privacy/presentation/bloc/privacy_bloc.dart';
import 'package:social_app_fe/features/search/data/data_sources/search_remote_data_source.dart';
import 'package:social_app_fe/features/search/data/repository/search_repository_impl.dart';
import 'package:social_app_fe/features/search/domain/repository/search_repository.dart';
import 'package:social_app_fe/features/search/domain/usecases/clear_all_search_history_usecase.dart';
import 'package:social_app_fe/features/search/domain/usecases/delete_search_history_usecase.dart';
import 'package:social_app_fe/features/search/domain/usecases/get_search_history_usecase.dart';
import 'package:social_app_fe/features/search/domain/usecases/search_users_usecase.dart';
import 'package:social_app_fe/features/search/presentation/bloc/search_bloc.dart';

final s1 = GetIt.instance;

Future<void> initializeDependencies() async {
  // Dio
  s1.registerSingleton<Dio>(DioClient.instance);

  // WebSocket - Tạo instance riêng cho mỗi namespace
  // Comment namespace
  s1.registerSingleton<SocketClient>(
    SocketClient(),
    instanceName: 'commentSocket',
  );
  // Chat namespace
  s1.registerSingleton<SocketClient>(
    SocketClient(),
    instanceName: 'chatSocket',
  );
  // Video call namespace
  s1.registerSingleton<SocketClient>(
    SocketClient(),
    instanceName: 'videoCallSocket',
  );

  // DataSources
  s1.registerLazySingleton<AuthService>(() => AuthService(s1()));
  s1.registerLazySingleton<FriendService>(() => FriendService(s1()));
  s1.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSource(s1()),
  );

  s1.registerLazySingleton<CommentRemoteDataSource>(
    () => CommentRemoteDataSource(s1(instanceName: 'commentSocket')),
  );

  s1.registerLazySingleton<StoryRemoteDataSource>(
    () => StoryRemoteDataSource(s1()),
  );

  s1.registerLazySingleton<PrivacyRemoteDataSource>(
    () => PrivacyRemoteDataSource(s1()),
  );

  s1.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSource(s1()),
  );

  s1.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(s1(instanceName: 'chatSocket'), s1()),
  );

  s1.registerLazySingleton<VideoCallRemoteDataSource>(
    () => VideoCallRemoteDataSource(s1(instanceName: 'videoCallSocket')),
  );

  // Repositories
  s1.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(s1()));
  s1.registerLazySingleton<FriendRepository>(() => FriendRepositoryImpl(s1()));
  s1.registerLazySingleton<PostRepository>(() => PostRepositoryImpl(s1()));
  s1.registerLazySingleton<CommentRepository>(
    () => CommentRepositoryImpl(s1()),
  );
  s1.registerLazySingleton<StoryRepository>(() => StoryRepositoryImpl(s1()));
  s1.registerLazySingleton<PrivacyRepository>(
    () => PrivacyRepositoryImpl(s1()),
  );
  s1.registerLazySingleton<SearchRepository>(() => SearchRepositoryImpl(s1()));
  s1.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(remoteDataSource: s1()),
  );
  s1.registerLazySingleton<VideoCallRepository>(
    () => VideoCallRepositoryImpl(remoteDataSource: s1()),
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

  // post usecase
  s1.registerLazySingleton<GetHomePostsUseCase>(
    () => GetHomePostsUseCase(s1()),
  );

  s1.registerLazySingleton<ReactPostUsecase>(() => ReactPostUsecase(s1()));
  s1.registerLazySingleton<GetPostDetailUsecase>(
    () => GetPostDetailUsecase(s1()),
  );
  s1.registerLazySingleton<CreatePostUsecase>(() => CreatePostUsecase(s1()));
  s1.registerLazySingleton<ReportPostUseCase>(() => ReportPostUseCase(s1()));

  s1.registerLazySingleton<GetProfilePostsUseCase>(
    () => GetProfilePostsUseCase(s1()),
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
  s1.registerLazySingleton<UpdateCommentUsecase>(
    () => UpdateCommentUsecase(s1()),
  );
  s1.registerLazySingleton<DeleteCommentUsecase>(
    () => DeleteCommentUsecase(s1()),
  );
  s1.registerLazySingleton<LoadCommentHistoryUseCase>(
    () => LoadCommentHistoryUseCase(s1()),
  );
  s1.registerLazySingleton<ListenCommentHistoryUseCase>(
    () => ListenCommentHistoryUseCase(s1()),
  );

  // Friend Usecases
  s1.registerLazySingleton<GetFriendsUseCase>(() => GetFriendsUseCase(s1()));
  s1.registerLazySingleton<GetFriendRequestsUseCase>(
    () => GetFriendRequestsUseCase(s1()),
  );
  s1.registerLazySingleton<GetSentFriendRequestsUseCase>(
    () => GetSentFriendRequestsUseCase(s1()),
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
  s1.registerLazySingleton<CancelFriendRequestUseCase>(
    () => CancelFriendRequestUseCase(s1()),
  );
  s1.registerLazySingleton<RemoveFriendUseCase>(
    () => RemoveFriendUseCase(s1()),
  );

  s1.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(s1()),
  );
  s1.registerLazySingleton<GetFriendsByUserIdUseCase>(
    () => GetFriendsByUserIdUseCase(s1()),
  );

  //profile
  // Profile Data Source
  s1.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSource(s1()),
  );

  // Profile Repository
  s1.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(s1()));

  // Profile UseCase
  s1.registerLazySingleton<GetUserProfileUseCase>(
    () => GetUserProfileUseCase(s1()),
  );
  s1.registerLazySingleton(() => GetOtherUserProfileUseCase(s1()));

  s1.registerLazySingleton(() => GetUserPostsUseCase(s1()));

  s1.registerLazySingleton(() => GetFriendRelationshipUseCase(s1()));

  s1.registerLazySingleton(() => UpdateUserProfileUseCase(s1()));
  // Chat UseCases
  s1.registerLazySingleton<ConnectChatUseCase>(() => ConnectChatUseCase(s1()));
  s1.registerLazySingleton<DisconnectChatUsecase>(
    () => DisconnectChatUsecase(s1()),
  );
  s1.registerLazySingleton<GetConversationsUseCase>(
    () => GetConversationsUseCase(s1()),
  );
  s1.registerLazySingleton<CreateConversationUseCase>(
    () => CreateConversationUseCase(s1()),
  );
  s1.registerLazySingleton<JoinConversationUseCase>(
    () => JoinConversationUseCase(s1()),
  );
  s1.registerLazySingleton<LeaveConversationUseCase>(
    () => LeaveConversationUseCase(s1()),
  );
  s1.registerLazySingleton<GetMessagesUseCase>(() => GetMessagesUseCase(s1()));
  s1.registerLazySingleton<GetMessagesAroundIdUseCase>(
    () => GetMessagesAroundIdUseCase(s1()),
  );
  s1.registerLazySingleton<TypingStartUseCase>(() => TypingStartUseCase(s1()));
  s1.registerLazySingleton<TypingStopUseCase>(() => TypingStopUseCase(s1()));
  s1.registerLazySingleton<ListenTypingStartUseCase>(
    () => ListenTypingStartUseCase(s1()),
  );
  s1.registerLazySingleton<ListenTypingStopUseCase>(
    () => ListenTypingStopUseCase(s1()),
  );
  s1.registerLazySingleton<ListenNewMessageUseCase>(
    () => ListenNewMessageUseCase(s1()),
  );
  s1.registerLazySingleton<SendMessageUseCase>(() => SendMessageUseCase(s1()));
  s1.registerLazySingleton<SendMessageWithFilesUseCase>(
    () => SendMessageWithFilesUseCase(s1()),
  );
  s1.registerLazySingleton<EditMessageUseCase>(() => EditMessageUseCase(s1()));
  s1.registerLazySingleton<DeleteMessageUseCase>(() => DeleteMessageUseCase(s1()));
  s1.registerLazySingleton<ReactMessageUseCase>(() => ReactMessageUseCase(s1()));
  s1.registerLazySingleton<ListenMessageUpdatedUseCase>(
    () => ListenMessageUpdatedUseCase(s1()),
  );
  s1.registerLazySingleton<ListenMessageReadUseCase>(
    () => ListenMessageReadUseCase(s1()),
  );
  s1.registerLazySingleton<GetMessageEditLogsUseCase>(
    () => GetMessageEditLogsUseCase(s1()),
  );
  s1.registerLazySingleton<MarkAsReadUseCase>(() => MarkAsReadUseCase(s1()));
  s1.registerLazySingleton<ListenConversationUpdateUseCase>(
    () => ListenConversationUpdateUseCase(s1()),
  );

  // Video Call UseCases
  s1.registerLazySingleton<ConnectVideoCallUseCase>(
    () => ConnectVideoCallUseCase(s1()),
  );
  s1.registerLazySingleton<CreateCallUseCase>(() => CreateCallUseCase(s1()));
  s1.registerLazySingleton<AcceptCallUseCase>(() => AcceptCallUseCase(s1()));
  s1.registerLazySingleton<RejectCallUseCase>(() => RejectCallUseCase(s1()));
  s1.registerLazySingleton<EndCallUseCase>(() => EndCallUseCase(s1()));
  s1.registerLazySingleton<ListenIncomingCallUseCase>(
    () => ListenIncomingCallUseCase(s1()),
  );
  s1.registerLazySingleton<ListenCallAcceptedUseCase>(
    () => ListenCallAcceptedUseCase(s1()),
  );
  s1.registerLazySingleton<ListenCallRejectedUseCase>(
    () => ListenCallRejectedUseCase(s1()),
  );
  s1.registerLazySingleton<ListenCallEndedUseCase>(
    () => ListenCallEndedUseCase(s1()),
  );
  s1.registerLazySingleton<DisconnectVideoCallUseCase>(
    () => DisconnectVideoCallUseCase(s1()),
  );

  // Video Call Bloc
  s1.registerFactory<VideoCallBloc>(
    () => VideoCallBloc(
      connectVideoCallUseCase: s1(),
      createCallUseCase: s1(),
      acceptCallUseCase: s1(),
      rejectCallUseCase: s1(),
      endCallUseCase: s1(),
      listenIncomingCallUseCase: s1(),
      listenCallAcceptedUseCase: s1(),
      listenCallRejectedUseCase: s1(),
      listenCallEndedUseCase: s1(),
      disconnectVideoCallUseCase: s1(),
    ),
  );

  // Profile Bloc
  s1.registerFactory(
    () => ProfileBloc(
      getProfilePostsUseCase: s1(),
      listenCommentCountUseCase: s1(),
      loadCommentsUseCase: s1(),
      getUserProfileUseCase: s1(),
      updateUserProfileUseCase: s1(),
    ),
  );
  // Trong injection_container.dart (hoặc file DI)
  s1.registerFactory(
    () => OtherProfileBloc(
      getOtherUserProfileUseCase: s1(),
      getUserPostsUseCase: s1(),
      getFriendRelationshipUseCase: s1(),
      listenCommentCountUseCase: s1(),
      loadCommentsUseCase: s1(),
    ),
  );
  // Story Usecases
  s1.registerLazySingleton<GetHomeStoriesUsecase>(
    () => GetHomeStoriesUsecase(s1()),
  );

  // Privacy UseCases
  s1.registerLazySingleton<GetDefaultPrivacyUseCase>(
    () => GetDefaultPrivacyUseCase(s1()),
  );

  s1.registerLazySingleton<SetDefaultPrivacyUseCase>(
    () => SetDefaultPrivacyUseCase(s1()),
  );

  // Search UseCase
  s1.registerLazySingleton<SearchUsersUseCase>(() => SearchUsersUseCase(s1()));
  s1.registerLazySingleton<GetSearchHistoryUseCase>(
    () => GetSearchHistoryUseCase(s1()),
  );
  s1.registerLazySingleton<DeleteSearchHistoryUseCase>(
    () => DeleteSearchHistoryUseCase(s1()),
  );
  s1.registerLazySingleton<ClearAllSearchHistoryUseCase>(
    () => ClearAllSearchHistoryUseCase(s1()),
  );

  s1.registerFactory(() => MenuBloc(s1()));

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
      reactPostUseCase: s1(),
      getPostDetailUsecase: s1(),
      connectChatUseCase: s1(),
      disconnectChatUseCase: s1(),
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

  s1.registerFactory<PostBloc>(() => PostBloc(s1()));

  s1.registerFactory<CommentBloc>(
    () => CommentBloc(
      joinPostUseCase: s1(),
      leavePostUseCase: s1(),
      emitTypingUseCase: s1(),
      listenTypingUseCase: s1(),
      addCommentUseCase: s1(),
      updateCommentUseCase: s1(),
      deleteCommentUsecase: s1(),
      loadCommentHistoryUseCase: s1(),
      listenCommentHistoryUseCase: s1(),
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
      removeFriendUseCase: s1(),
      getFriendsByUserIdUseCase: s1(),
    ),
  );

  s1.registerFactory<FriendForUserBloc>(
    () => FriendForUserBloc(
      getFriendsUseCase: s1(),
      getFriendRequestsUseCase: s1(),
      getSentFriendRequestsUseCase: s1(),
      getFriendSuggestionsUseCase: s1(),
      sendFriendRequestUseCase: s1(),
      acceptFriendRequestUseCase: s1(),
      rejectFriendRequestUseCase: s1(),
      cancelFriendRequestUseCase: s1(),
      removeFriendUseCase: s1(),
      getFriendsByUserIdUseCase: s1(),
    ),
  );

  s1.registerFactory<FriendProfileBloc>(
    () => FriendProfileBloc(
      getFriendsUseCase: s1(),
      getFriendRequestsUseCase: s1(),
      getSentFriendRequestsUseCase: s1(),
      getFriendSuggestionsUseCase: s1(),
      sendFriendRequestUseCase: s1(),
      acceptFriendRequestUseCase: s1(),
      rejectFriendRequestUseCase: s1(),
      cancelFriendRequestUseCase: s1(),
      removeFriendUseCase: s1(),
      getFriendsByUserIdUseCase: s1(),
    ),
  );

  s1.registerFactory<HomeStoriesBloc>(
    () => HomeStoriesBloc(getHomeStoriesUseCase: s1()),
  );

  s1.registerFactory<PrivacyBloc>(() => PrivacyBloc(s1(), s1()));

  s1.registerFactory<SearchBloc>(
    () => SearchBloc(
      searchUsersUseCase: s1(),
      getSearchHistoryUseCase: s1(),
      deleteSearchHistoryUseCase: s1(),
      clearAllSearchHistoryUseCase: s1(),
    ),
  );

  s1.registerFactory<ConversationBloc>(
    () => ConversationBloc(
      getConversationsUseCase: s1(),
      createConversationUseCase: s1(),
      joinConversationUseCase: s1(),
      leaveConversationUseCase: s1(),
      listenConversationUpdateUseCase: s1(),
    ),
  );

  s1.registerFactory<MessageBloc>(
    () => MessageBloc(
      getMessagesUseCase: s1(),
      getMessagesAroundIdUseCase: s1(),
      typingStartUseCase: s1(),
      typingStopUseCase: s1(),
      listenTypingStartUseCase: s1(),
      listenTypingStopUseCase: s1(),
      listenNewMessageUseCase: s1(),
      sendMessageUseCase: s1(),
      sendMessageWithFilesUseCase: s1(),
      editMessageUseCase: s1(),
      deleteMessageUseCase: s1(),
      reactMessageUseCase: s1(),
      listenMessageUpdatedUseCase: s1(),
      listenMessageReadUseCase: s1(),
      markAsReadUseCase: s1(),
    ),
  );
}

Future<void> resetDependencies() async {
  await s1.reset(dispose: true);
  await initializeDependencies(); // đăng ký lại DI toàn bộ
}
