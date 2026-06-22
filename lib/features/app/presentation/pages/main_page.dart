import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/features/app/presentation/pages/profile_navigation_page.dart';
import 'package:social_app_fe/features/app/presentation/widgets/custom_bottom_navigation.dart';
import 'package:social_app_fe/features/app/presentation/widgets/side_navigation.dart';
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
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/local/app_preferences.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

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

    final isSidebarLayout = ResponsiveHelper.shouldShowSidebar(context);

    if (isSidebarLayout) {
      // On web/desktop: use IndexedStack, just update index
      _markNotificationsReadIfLeaving(index);
      setState(() {
        _currentIndex = index;
      });
    } else {
      // On mobile: use PageView with jumpToPage
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
  }

  void _markNotificationsReadIfLeaving(int newIndex) {
    if (_currentIndex == 3 && newIndex != 3) {
      final unread = context.read<NotificationBloc>().state.unread;
      if (unread > 0) {
        context.read<NotificationBloc>().add(MarkAllNotificationsRead());
      }
    }
  }

  double _scrollDelta = 0;

  bool _handleScrollNotification(ScrollNotification notification) {
    // Xử lý ẩn/hiện bottom nav bar ở trang Home (0), Friend (1), Notification (3)
    if (_currentIndex == 2) return false;

    if (notification is ScrollUpdateNotification) {
      if (notification.metrics.axis == Axis.vertical) {
        _scrollDelta += notification.scrollDelta ?? 0;

        // Nếu cuộn xuống (vuốt lên) hơn 50px -> Ẩn
        if (_scrollDelta > 50) {
          if (_isBottomNavVisible) {
            setState(() => _isBottomNavVisible = false);
          }
          _scrollDelta = 0;
        }
        // Nếu cuộn lên (vuốt xuống) hơn 50px -> Hiện
        else if (_scrollDelta < -200) {
          if (!_isBottomNavVisible) {
            setState(() => _isBottomNavVisible = true);
          }
          _scrollDelta = 0;
        }
      }
    } else if (notification is UserScrollNotification) {
      // Khi người dùng thay đổi hướng cuộn, reset lại delta để tính toán lại từ đầu
      _scrollDelta = 0;
    }
    return false;
  }

  /// Build the list of page children (shared between mobile & desktop)
  List<Widget> _buildPages() {
    return [
      HomePage(key: _homePageKey),
      FriendPage(),
      CreatePostPage(
        onPostCreated: () {
          if (ResponsiveHelper.shouldShowSidebar(context)) {
            setState(() => _currentIndex = 0);
          } else {
            _pageController.jumpToPage(0);
            setState(() => _currentIndex = 0);
          }
        },
      ),
      NotificationPage(),
      ProfileNavigationPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isSidebarLayout = ResponsiveHelper.shouldShowSidebar(context);

    return ListenableBuilder(
      listenable: s1<AppPreferences>(),
      builder: (context, child) {
        return BlocListener<PostBloc, PostState>(
          listener: (context, state) {
            if (state is PostCreated) {
              showSuccessSnackBar(context, state.message);
            } else if (state is PostCreateError) {
              showErrorSnackBar(context, state.message);
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.background,
            body: isSidebarLayout
                ? _buildDesktopLayout()
                : _buildMobileLayout(),
          ),
        );
      },
    );
  }

  /// Desktop/Web layout: Side Navigation + Content
  Widget _buildDesktopLayout() {
    final pages = _buildPages();

    return Row(
      children: [
        // Side Navigation
        BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, notificationState) {
            return SideNavigation(
              currentIndex: _currentIndex,
              onTabSelected: _onTabSelected,
              unreadCount: notificationState.unread,
              avt: _getAvtCurrent(),
            );
          },
        ),

        // Main Content Area
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: ResponsiveHelper.feedMaxWidth,
              ),
              child: NotificationListener<ScrollNotification>(
                onNotification: _handleScrollNotification,
                child: IndexedStack(index: _currentIndex, children: pages),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Mobile layout: PageView + Bottom Navigation (original layout)
  Widget _buildMobileLayout() {
    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: _handleScrollNotification,
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              // Mark all notifications as read when leaving notification page
              _markNotificationsReadIfLeaving(index);
              setState(() {
                _currentIndex = index;
                _isBottomNavVisible = true; // reset visibility
              });
            },
            //   physics: const AlwaysScrollableScrollPhysics(), // chỉ cho đổi bằng nav
            children: _buildPages(),
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
    );
  }
}
