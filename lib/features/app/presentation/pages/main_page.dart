import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/features/app/presentation/widgets/custom_bottom_navigation.dart';
import 'package:social_app_fe/features/friend/presentation/pages/friend_page.dart';
import 'package:social_app_fe/features/home/presentation/pages/home_page.dart';
import 'package:social_app_fe/features/menu/presentation/pages/menu_page.dart';
import 'package:social_app_fe/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:social_app_fe/features/notification/presentation/bloc/notification_event.dart';
import 'package:social_app_fe/features/notification/presentation/bloc/notification_state.dart';
import 'package:social_app_fe/features/notification/presentation/pages/notification_page.dart';
import 'package:social_app_fe/features/post/presentation/pages/create_post_page.dart';

class MainPage extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const MainPage({super.key, this.userData});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _connectSocket();
  }

  Future<void> _connectSocket() async {
    if (widget.userData == null) return;
    final userId = widget.userData!['id'];

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
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          // Mark all notifications as read when leaving notification page
          if (_currentIndex == 3 && index != 3) {
            final unread = context.read<NotificationBloc>().state.unread;
            if (unread > 0) {
              context.read<NotificationBloc>().add(MarkAllNotificationsRead());
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
    );
  }
}
