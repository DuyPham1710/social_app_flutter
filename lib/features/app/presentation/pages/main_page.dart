import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/features/app/presentation/widgets/custom_bottom_navigation.dart';
import 'package:social_app_fe/features/friend/presentation/pages/friend_page.dart';
import 'package:social_app_fe/features/home/presentation/pages/home_page.dart';
import 'package:social_app_fe/features/menu/presentation/pages/menu_page.dart';
import 'package:social_app_fe/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:social_app_fe/features/notification/presentation/bloc/notification_event.dart';
import 'package:social_app_fe/features/notification/presentation/bloc/notification_state.dart';
import 'package:social_app_fe/features/notification/presentation/pages/notification_page.dart';
import 'package:social_app_fe/features/post/presentation/pages/create_post_page.dart';
import 'package:social_app_fe/features/post/presentation/bloc/post_bloc.dart';
import 'package:social_app_fe/features/post/presentation/bloc/post_state.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';

class MainPage extends StatefulWidget {
  final Map<String, dynamic>? userData;
  final int? initialTab;
  const MainPage({super.key, this.userData, this.initialTab});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _currentIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab ?? 0;
    _pageController = PageController(initialPage: _currentIndex);
    _connectSocket();

    // Reload notifications if opening notification tab
    if (_currentIndex == 3) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<NotificationBloc>().add(ReloadNotifications());
        }
      });
    }
  }

  Future<void> _connectSocket() async {
    // Load fresh userData from TokenStorage instead of using widget.userData
    // This ensures we always connect with the correct current user
    final userData = await TokenStorage.getUserData();

    // Check mounted after async operation
    if (!mounted) {
      debugPrint('[MainPage] Widget disposed, skipping socket connection');
      return;
    }

    if (userData == null) {
      debugPrint('[MainPage] No user data found, skipping socket connection');
      return;
    }

    final userId = userData['id'] as String?;
    if (userId == null || userId.isEmpty) {
      debugPrint('[MainPage] Invalid userId, skipping socket connection');
      return;
    }

    debugPrint('[MainPage] Connecting notification socket for userId: $userId');

    // connect notification socket
    context.read<NotificationBloc>().add(ConnectNotificationSocket(userId));
  }

  void _onTabSelected(int index) {
    // Update _currentIndex AFTER jumpToPage to ensure onPageChanged works correctly
    _pageController.jumpToPage(index);
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() => _currentIndex = index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        if (state is PostCreated) {
          showSuccessSnackBar(context, state.message);
        } else if (state is PostCreateError) {
          showErrorSnackBar(context, state.message);
        }
      },
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            // Mark all notifications as read when leaving notification page
            if (_currentIndex == 3 && index != 3) {
              final unread = context.read<NotificationBloc>().state.unread;
              if (unread > 0) {
                context.read<NotificationBloc>().add(
                  MarkAllNotificationsRead(),
                );
              }
            }
            setState(() => _currentIndex = index);
          },
          //   physics: const AlwaysScrollableScrollPhysics(), // chỉ cho đổi bằng nav
          children: [
            HomePage(),
            FriendPage(),
            CreatePostPage(
              onPostCreated: () {
                _pageController.jumpToPage(0);
                setState(() => _currentIndex = 0);
              },
            ),
            NotificationPage(),
            MenuPage(),
          ],
        ),
        bottomNavigationBar: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, notificationState) {
            return CustomBottomNavigation(
              currentIndex: _currentIndex,
              onTabSelected: _onTabSelected,
              unreadCount: notificationState.unread,
            );
          },
        ),
      ),
    );
  }
}
