import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/features/app/presentation/widgets/custom_bottom_navigation.dart';
import 'package:social_app_fe/features/friend/presentation/pages/friend_page.dart';
import 'package:social_app_fe/features/home/presentation/pages/home_page.dart';
import 'package:social_app_fe/features/menu/presentation/pages/menu_page.dart';
import 'package:social_app_fe/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:social_app_fe/features/notification/presentation/bloc/notification_event.dart';
import 'package:social_app_fe/features/notification/presentation/pages/notification_page.dart';
import 'package:social_app_fe/features/post/presentation/pages/create_post_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _connectNotificationSocket();
  }

  Future<void> _connectNotificationSocket() async {
    final userData = await TokenStorage.getUserData();
    if (userData == null) return;

    final userId = userData['id'];

    // 🔥 connect socket notification 1 lần
    context.read<NotificationBloc>().add(ConnectNotificationSocket(userId));
  }

  void _onTabSelected(int index) {
    setState(() => _currentIndex = index);
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
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
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}
