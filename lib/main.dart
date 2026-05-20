import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/config/theme/app_theme.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/permission_helper.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/local/app_preferences.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/core/network/my_http_overrides.dart';
import 'package:social_app_fe/core/services/callkit_service.dart';
import 'package:social_app_fe/core/services/fcm_service.dart';
import 'package:social_app_fe/core/services/firebase_background_handler.dart';
import 'package:social_app_fe/features/notification/presentation/services/notification_fcm_service.dart';
import 'package:social_app_fe/features/app/presentation/pages/main_page.dart';
import 'package:social_app_fe/features/app/presentation/pages/splash_page.dart';
import 'package:social_app_fe/features/app/presentation/widgets/restart_widget.dart';
import 'package:social_app_fe/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:social_app_fe/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:social_app_fe/features/auth/presentation/pages/login_page.dart';
import 'package:social_app_fe/features/auth/presentation/pages/otp_page.dart';
import 'package:social_app_fe/features/auth/presentation/pages/personal_info_page.dart';
import 'package:social_app_fe/features/auth/presentation/pages/register_page.dart';
import 'package:social_app_fe/features/auth/presentation/pages/reset_password_page.dart';
import 'package:social_app_fe/features/auth/presentation/pages/face_registration_page.dart';
import 'package:social_app_fe/features/auth/presentation/pages/face_scan_page.dart';
import 'package:social_app_fe/features/chat/presentation/bloc/bloc.dart';
import 'package:social_app_fe/features/friend/presentation/bloc/friend_bloc.dart';
import 'package:social_app_fe/features/friend/presentation/bloc/friend_for_user_bloc.dart';
import 'package:social_app_fe/features/home/presentation/bloc/home_bloc.dart';
import 'package:social_app_fe/features/home/presentation/pages/home_page.dart';
import 'package:social_app_fe/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:social_app_fe/features/post/presentation/bloc/post_bloc.dart';
import 'package:social_app_fe/features/story/presentation/bloc/home_stories_bloc.dart';
import 'package:social_app_fe/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/friend_bloc.dart';
import 'package:social_app_fe/features/search/presentation/pages/search_page.dart';
import 'package:social_app_fe/features/video_call/presentation/bloc/bloc.dart';
import 'package:social_app_fe/features/video_call/presentation/pages/video_call_screen.dart';
import 'package:social_app_fe/firebase_options.dart';
import 'package:social_app_fe/features/chat/presentation/pages/chat_detail_page.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  HttpOverrides.global = MyHttpOverrides();

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('[Firebase] Initialized successfully');
  } catch (e) {
    debugPrint('[Firebase] Initialization error: $e');
  }

  // Register FCM background message handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await initializeDependencies();

  runApp(
    RestartWidget(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => s1<AuthBloc>()),
          BlocProvider(create: (_) => s1<HomeBloc>()),
          BlocProvider(create: (_) => s1<FriendBloc>()),
          BlocProvider(create: (_) => s1<FriendProfileBloc>()),
          BlocProvider(create: (_) => s1<HomeStoriesBloc>()),
          BlocProvider(create: (_) => s1<MenuBloc>()),
          BlocProvider(create: (_) => s1<PostBloc>()),
          BlocProvider(create: (_) => s1<ConversationBloc>()),
          BlocProvider(create: (_) => s1<FriendForUserBloc>()),
          BlocProvider(create: (_) => s1<NotificationBloc>()),

          BlocProvider(create: (_) => s1<VideoCallBloc>()),
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, dynamic>? userData;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _getUserInfo();
    await _initializeServices();
  }

  Future<void> _getUserInfo() async {
    userData = await TokenStorage.getUserData();
    if (userData == null) return;
  }

  Future<void> _initializeServices() async {
    try {
      // Initialize FCM Service
      debugPrint('[App] Initializing FCM service...');
      await FcmService().initialize();

      // Initialize CallKit Service
      debugPrint('[App] Initializing CallKit service...');
      await CallKitService().initialize();

      // Setup CallKit callbacks
      CallKitService().onCallAccepted = _handleCallAccepted;
      CallKitService().onCallRejected = _handleCallRejected;
      CallKitService().onCallEnded = _handleCallEnded;

      // Register navigation callback for chat notifications
      NotificationNavigationHelper.registerNavigationCallback(
        _handleNavigateToConversation,
      );

      // Initialize Notification FCM Service
      debugPrint('[App] Initializing Notification FCM service...');
      await NotificationFcmService().initialize();

      // Register navigation callback for app notifications
      AppNotificationNavigationHelper.registerNavigationCallback(
        _handleNavigateToAppNotification,
      );

      // Handle pending notification if app was opened from terminated state
      debugPrint('[App] Checking for pending notification navigation...');
      await FcmService().handlePendingNavigation();
      await NotificationFcmService().handlePendingNavigation();

      debugPrint('[App] Services initialized successfully');
    } catch (e) {
      debugPrint('[App] Error initializing services: $e');
    }
  }

  void _handleCallAccepted(Map<String, dynamic> callData) async {
    debugPrint('[App] Call accepted from CallKit: $callData');

    final callId = callData['callId'] as String?;
    final userId = callData['receiverId'] as String?;
    final callType = callData['callType'] as String? ?? 'video';

    if (callId == null || userId == null) {
      debugPrint('[App] Missing callId or userId, cannot accept call');
      return;
    }

    // Check permissions before accepting call
    final hasPermissions = await PermissionHelper.checkCallPermissions(
      callType,
    );
    if (!hasPermissions) {
      debugPrint('[App] Permissions denied, rejecting call');
      // End the call if permissions are denied
      await CallKitService().endCall(callId);

      // Show error message to user
      final context = _navigatorKey.currentContext;
      if (context != null) {
        PermissionHelper.showPermissionDeniedError(context, callType);
      }
      return;
    }

    final videoCallBloc = context.read<VideoCallBloc>();

    if (videoCallBloc.state.status != VideoCallStatus.connected) {
      debugPrint('[App] Socket not connected, connecting first...');

      final currentUserId = userData?['id'] ?? userId;
      final username = userData?['username'] ?? 'User';

      videoCallBloc.add(
        ConnectVideoCall(userId: currentUserId, username: username),
      );

      await Future.delayed(const Duration(seconds: 2));
    }

    // Dispatch AcceptCall event
    videoCallBloc.add(AcceptCall(userId: userId, callId: callId));

    // Navigation will be handled by BlocListener in ChatDetailPage or global listener
  }

  void _handleCallRejected(Map<String, dynamic> callData) async {
    debugPrint('[App] Call rejected from CallKit: $callData');

    final callId = callData['callId'] as String?;
    final userId = callData['receiverId'] as String?;

    if (callId != null && userId != null) {
      final videoCallBloc = context.read<VideoCallBloc>();

      if (videoCallBloc.state.status != VideoCallStatus.connected) {
        debugPrint('[App] Socket not connected, connecting first...');

        final currentUserId = userData?['id'] ?? userId;
        final username = userData?['username'] ?? 'User';

        videoCallBloc.add(
          ConnectVideoCall(userId: currentUserId, username: username),
        );

        await Future.delayed(const Duration(seconds: 2));
      }

      // Dispatch RejectCall event
      videoCallBloc.add(RejectCall(userId: userId, callId: callId));
    }
  }

  void _handleCallEnded(Map<String, dynamic> callData) {
    debugPrint('[App] Call ended from CallKit: $callData');

    // Just cleanup, no need to send socket event
    // The call already ended on the other side
  }

  void _handleNavigateToAppNotification(
    String type, {
    String? targetId,
    String? senderId,
    String? notificationId,
  }) async {
    debugPrint('[App] Navigating to notification page from FCM: type=$type');

    try {
      // Wait for app to be ready
      await Future.delayed(const Duration(milliseconds: 600));

      // Get current context
      final context = _navigatorKey.currentContext;
      if (context == null || !context.mounted) {
        debugPrint('[App] Context not available');
        return;
      }

      // Navigate to main page with notification tab (index 3)
      await _navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/main',
        (route) => false,
        arguments: {'initialTab': 3}, // Open notification tab
      );
    } catch (e) {
      debugPrint('[App] Error navigating to notification page: $e');
    }
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    if (settings.name == '/chat-detail') {
      final args = settings.arguments as Map<String, dynamic>?;
      if (args != null && args['conversationId'] != null) {
        final conversationId = args['conversationId'] as String;
        final senderId = args['senderId'] as String?;
        final senderName = args['senderName'] as String?;
        final senderAvatar = args['senderAvatar'] as String?;
        final unreadCount = args['unreadCount'] as int? ?? 0;
        final firstUnreadMessageIndex =
            args['firstUnreadMessageIndex'] as int? ?? -1;

        debugPrint(
          '[App] Navigating to ChatDetailPage for conversation: $conversationId (unreadCount: $unreadCount, firstUnreadIndex: $firstUnreadMessageIndex)',
        );

        // Create MessageBloc instance
        final messageBloc = s1<MessageBloc>();

        // Create friendInfo from notification data
        UserEntity? friendInfo;
        if (senderId != null && senderName != null) {
          friendInfo = UserEntity(
            userId: senderId,
            fullName: senderName,
            avatarUrl: senderAvatar,
          );
          debugPrint(
            '[App] Created friendInfo from notification data: $senderName',
          );
        }

        return MaterialPageRoute(
          builder: (context) => FutureBuilder<Map<String, dynamic>?>(
            future: userData != null
                ? Future.value(userData)
                : TokenStorage.getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                );
              }

              final currentUserData = snapshot.data;
              final userId = currentUserData?['id'];
              final username = currentUserData?['username'];

              if (userId == null || username == null) {
                return Scaffold(
                  appBar: AppBar(title: const Text('Error')),
                  body: const Center(child: Text('Unable to load user data')),
                );
              }

              messageBloc.add(
                MarkAsReadEvent(
                  userId: userId!,
                  conversationId: conversationId,
                ),
              );

              return BlocProvider<MessageBloc>(
                create: (_) => messageBloc,
                child: ChatDetailPage(
                  userId: userId,
                  username: username,
                  conversationId: conversationId,
                  friendInfo: friendInfo,
                  friendId: senderId,
                  unreadCount: unreadCount,
                  firstUnreadMessageIndex: firstUnreadMessageIndex != -1
                      ? firstUnreadMessageIndex
                      : null,
                ),
              );
            },
          ),
        );
      }
    }
    return null;
  }

  void _handleNavigateToConversation(
    String conversationId,
    String? senderId,
    String? senderName,
    String? senderAvatar, {
    int unreadCount = 0,
    int firstUnreadMessageIndex = -1,
  }) async {
    debugPrint(
      '[App] Navigating to conversation: $conversationId (unreadCount: $unreadCount, firstUnreadIndex: $firstUnreadMessageIndex)',
    );

    try {
      // Navigate to main first
      // await _navigatorKey.currentState?.pushNamedAndRemoveUntil(
      //   '/main',
      //   (route) => false,
      // );

      // Wait for main page to build
      await Future.delayed(const Duration(milliseconds: 400));

      // Get current context
      final context = _navigatorKey.currentContext;
      if (context == null || !context.mounted) {
        debugPrint('[App] Context not available');
        return;
      }

      try {
        debugPrint('[App] joining conversation...');

        // Join conversation before navigating to chat detail
        final conversationBloc = context.read<ConversationBloc>();
        conversationBloc.add(
          JoinConversationEvent(
            userId: userData?['id'] ?? '',
            conversationId: conversationId,
          ),
        );

        // Wait for join to complete
        await Future.delayed(const Duration(milliseconds: 500));

        debugPrint('[App] Joined conversation, proceeding to chat detail page');
      } catch (e) {
        debugPrint('[App] Error ensuring chat socket: $e');
        // Continue anyway, ChatDetailPage will handle the error
      }

      await Navigator.of(context)
          .pushNamed(
            '/chat-detail',
            arguments: {
              'conversationId': conversationId,
              'senderId': senderId,
              'senderName': senderName,
              'senderAvatar': senderAvatar,
              'unreadCount': unreadCount,
              'firstUnreadMessageIndex': firstUnreadMessageIndex,
            },
          )
          .then((_) {
            final userId = userData?['id'];
            if (userId != null) {
              context.read<ConversationBloc>().add(
                LeaveConversationEvent(
                  conversationId: conversationId,
                  userId: userId,
                ),
              );
            }
          });
    } catch (e) {
      debugPrint('[App] Error navigating to conversation: $e');
    }
  }

  bool _isNavigatingToCall = false;

  void _handleVideoCallStateChange(BuildContext context, VideoCallState state) {
    debugPrint('[App] VideoCall state changed: ${state.status}');

    if (state.status == VideoCallStatus.inCall && state.tokenEntity != null) {
      // Prevent duplicate navigation
      if (_isNavigatingToCall) {
        debugPrint('[App] Already navigating to VideoCallScreen, ignoring...');
        return;
      }
      _isNavigatingToCall = true;

      final tokenEntity = state.tokenEntity!;
      final incomingCall = state.incomingCall;

      debugPrint('[App] Navigating to VideoCallScreen...');
      debugPrint('[App] - channelId: ${tokenEntity.channelId}');
      debugPrint('[App] - callId: ${tokenEntity.callId}');
      debugPrint('[App] - isCaller: false (accepting call)');

      _navigatorKey.currentState
          ?.push(
            MaterialPageRoute(
              builder: (_) => VideoCallScreen(
                channelId: tokenEntity.channelId,
                token: tokenEntity.token,
                appId: tokenEntity.appId,
                callId: tokenEntity.callId,
                userId: userData?['id'] ?? '', // Current user (receiver)
                isVideo: incomingCall?.callType == 'video',
                isCaller: false, // Always false when accepting
                callerName:
                    incomingCall?.callerInfo?.fullName ??
                    incomingCall?.callerInfo?.username ??
                    'Unknown',
                callerAvatar: incomingCall?.callerInfo?.avatarUrl,
                receiverName:
                    userData?['fullName'] ?? userData?['username'] ?? 'You',
                receiverAvatar: userData?['avatarUrl'],
              ),
            ),
          )
          .then((_) {
            _isNavigatingToCall = false;
            // Disconnect socket after call ends (for receiver)
            // context.read<VideoCallBloc>().add(const DisconnectVideoCall());
          });
    } else if (state.status == VideoCallStatus.error) {
      debugPrint('[App] Video call error occurred: ${state.errorMessage}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocListener<VideoCallBloc, VideoCallState>(
          listener: (context, state) {
            _handleVideoCallStateChange(context, state);
          },
          child: ListenableBuilder(
            listenable: s1<AppPreferences>(),
            builder: (context, child) {
              return MaterialApp(
                navigatorKey: _navigatorKey, // Add global navigator key
                title: 'Namer App',
                debugShowCheckedModeBanner: false,
                theme: theme(),
                darkTheme: darkTheme(),
                themeMode: s1<AppPreferences>().themeMode,
                initialRoute: '/splash',
                onGenerateRoute: _onGenerateRoute,
                routes: <String, WidgetBuilder>{
                  '/face-registration': (context) =>
                      const FaceRegistrationPage(),
                  '/face-scan': (context) => const FaceScanPage(),
                  '/splash': (context) => const SplashPage(),
                  '/main': (BuildContext context) {
                    final args =
                        ModalRoute.of(context)?.settings.arguments
                            as Map<String, dynamic>?;
                    return MainPage(
                      userData: userData,
                      initialTab: args?['initialTab'] as int?,
                    );
                  },
                  '/login': (BuildContext context) => const LoginPage(),
                  '/home': (BuildContext context) => const HomePage(),
                  '/signup': (BuildContext context) => const RegisterPage(),
                  '/forgot-password': (BuildContext context) =>
                      const ForgotPasswordPage(),
                  '/otp': (BuildContext context) => const OtpPage(),
                  '/personal-info': (BuildContext context) =>
                      const PersonalInfoPage(),
                  '/reset-password': (BuildContext context) =>
                      const ResetPasswordPage(),
                  '/search': (BuildContext context) => const SearchPage(),
                },
              );
            },
          ),
        );
      },
    );
  }
}
