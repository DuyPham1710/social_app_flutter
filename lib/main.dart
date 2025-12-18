import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/config/theme/app_theme.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/core/network/my_http_overrides.dart';
import 'package:social_app_fe/core/services/callkit_service.dart';
import 'package:social_app_fe/core/services/fcm_service.dart';
import 'package:social_app_fe/core/services/firebase_background_handler.dart';
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
import 'package:social_app_fe/features/chat/presentation/bloc/conversation/conversation_bloc.dart';
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

      debugPrint('[App] Services initialized successfully');
    } catch (e) {
      debugPrint('[App] Error initializing services: $e');
    }
  }

  void _handleCallAccepted(Map<String, dynamic> callData) async {
    debugPrint('[App] Call accepted from CallKit: $callData');

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

      // Dispatch AcceptCall event
      videoCallBloc.add(AcceptCall(userId: userId, callId: callId));

      // Navigation will be handled by BlocListener in ChatDetailPage or global listener
    }
  }

  void _handleCallRejected(Map<String, dynamic> callData) async {
    debugPrint('[App] Call rejected from CallKit: $callData');

    final callId = callData['callId'] as String?;
    final userId = callData['userId'] as String?;

    if (callId != null && userId != null) {
      final videoCallBloc = context.read<VideoCallBloc>();

      if (videoCallBloc.state.status != VideoCallStatus.connected) {
        debugPrint('[App] Socket not connected, connecting first...');

        // Lấy thông tin user hiện tại từ userData đã load trong _init()
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

  void _handleVideoCallStateChange(BuildContext context, VideoCallState state) {
    debugPrint('[App] VideoCall state changed: ${state.status}');

    // if (state.status == VideoCallStatus.incomingCall &&
    //     state.incomingCall != null) {
    //   _showCallKitUI(state.incomingCall!);
    // } else
    if (state.status == VideoCallStatus.inCall && state.tokenEntity != null) {
      final tokenEntity = state.tokenEntity!;
      final incomingCall = state.incomingCall;

      debugPrint('[App] Navigating to VideoCallScreen...');
      debugPrint('[App] - channelId: ${tokenEntity.channelId}');
      debugPrint('[App] - callId: ${tokenEntity.callId}');
      debugPrint('[App] - isCaller: false (accepting call)');

      _navigatorKey.currentState?.push(
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
      );
      // .then((_) {
      //   // Disconnect socket after call ends (for receiver)
      //   context.read<VideoCallBloc>().add(const DisconnectVideoCall());
      // });
    } else if (state.status == VideoCallStatus.error) {
      debugPrint('[App] Video call error occurred: ${state.errorMessage}');
    }
  }

  /// Show CallKit UI for incoming call
  // void _showCallKitUI(IncomingCallEntity incomingCall) {
  //   debugPrint('[App] Showing CallKit UI for: ${incomingCall.callId}');

  //   final callData = {
  //     'callId': incomingCall.callId,
  //     'callerName':
  //         incomingCall.callerInfo?.fullName ??
  //         incomingCall.callerInfo?.username ??
  //         'Unknown',
  //     'callerAvatar': incomingCall.callerInfo?.avatarUrl ?? '',
  //     'callType': incomingCall.callType,
  //     'receiverId': userData?['id'] ?? '',
  //     'callerId': incomingCall.callerId,
  //   };

  //   CallKitService().showIncomingCall(callData);
  // }

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
          child: MaterialApp(
            navigatorKey: _navigatorKey, // Add global navigator key
            title: 'Namer App',
            debugShowCheckedModeBanner: false,
            theme: theme(),
            initialRoute: '/splash',
            routes: <String, WidgetBuilder>{
              '/splash': (context) => const SplashPage(),
              '/main': (BuildContext context) => MainPage(userData: userData),
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
          ),
        );
      },
    );
  }
}
