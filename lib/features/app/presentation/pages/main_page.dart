import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/features/app/presentation/pages/profile_navigation_page.dart';
import 'package:social_app_fe/features/app/presentation/widgets/custom_bottom_navigation.dart';
import 'package:social_app_fe/features/friend/presentation/pages/friend_page.dart';
import 'package:social_app_fe/features/home/presentation/pages/home_page.dart';
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
  bool _isBottomNavVisible = true;
  final GlobalKey<HomePageState> _homePageKey = GlobalKey<HomePageState>();
  Map<String, dynamic>? _currentUserData;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab ?? 0;
    _pageController = PageController(initialPage: _currentIndex);
    _connectSocket();
    _refreshUserData();

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

    if (mounted) {
      setState(() {
        _currentUserData = userData;
      });
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

  String _getAvtCurrent() {
    final userData = _currentUserData ?? widget.userData;
    final avatarUrl = userData?['avatarUrl'] as String?;
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      return avatarUrl;
    }

    final avatar = userData?['avatar'] as String?;
    if (avatar != null && avatar.isNotEmpty) {
      return avatar;
    }

    return '';
  }

  Future<void> _refreshUserData() async {
    final userData = await TokenStorage.getUserData();
    if (!mounted) return;
    
    setState(() {
      _currentUserData = userData;
    });
  }

  void _onTabSelected(int index) {
    if (_currentIndex == 0 && index == 0) {
      // Nếu đang ở trang chủ và bấm lại trang chủ -> cuộn lên/reload
      _homePageKey.currentState?.scrollToTopOrRefresh();
      return;
    }

    // Update _currentIndex AFTER jumpToPage to ensure onPageChanged works correctly
    _pageController.jumpToPage(index);
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _currentIndex = index;
          _isBottomNavVisible = true; // reset visibility when changing tabs
        });
      }
    });
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    // Xử lý ẩn/hiện bottom nav bar ở trang Home (0), Friend (1), Notification (3)
    if (_currentIndex != 0 && _currentIndex != 1 && _currentIndex != 3)
      return false;

    if (notification is UserScrollNotification) {
      if (notification.metrics.axis == Axis.vertical) {
        if (notification.direction == ScrollDirection.reverse) {
          // Vuốt lên (cuộn xuống dưới) -> Ẩn bottom nav
          if (_isBottomNavVisible) {
            setState(() => _isBottomNavVisible = false);
          }
        } else if (notification.direction == ScrollDirection.forward) {
          // Vuốt xuống (cuộn lên trên) -> Hiện bottom nav
          if (!_isBottomNavVisible) {
            setState(() => _isBottomNavVisible = true);
          }
        }
      }
    }
    return false;
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
        body: Stack(
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: _handleScrollNotification,
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  // Mark all notifications as read when leaving notification page
                  if (_currentIndex == 3 && index != 3) {
                    final unread = context
                        .read<NotificationBloc>()
                        .state
                        .unread;
                    if (unread > 0) {
                      context.read<NotificationBloc>().add(
                        MarkAllNotificationsRead(),
                      );
                    }
                  }
                  setState(() {
                    _currentIndex = index;
                    _isBottomNavVisible = true; // reset visibility
                  });
                },
                //   physics: const AlwaysScrollableScrollPhysics(), // chỉ cho đổi bằng nav
                children: [
                  HomePage(key: _homePageKey),
                  FriendPage(),
                  CreatePostPage(
                    onPostCreated: () {
                      _pageController.jumpToPage(0);
                      setState(() => _currentIndex = 0);
                    },
                  ),
                  NotificationPage(),
                  ProfileNavigationPage(),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: _isBottomNavVisible
                    ? (86.h + MediaQuery.of(context).padding.bottom)
                    : 0,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: BlocBuilder<NotificationBloc, NotificationState>(
                    builder: (context, notificationState) {
                      return CustomBottomNavigation(
                        currentIndex: _currentIndex,
                        onTabSelected: _onTabSelected,
                        unreadCount: notificationState.unread,
                        avt: _getAvtCurrent(),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
