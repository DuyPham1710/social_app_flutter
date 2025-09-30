import 'package:flutter/material.dart';
import 'package:social_app_fe/features/home/presentation/widgets/home_header_widget.dart';
import 'package:social_app_fe/features/home/presentation/widgets/home_stories_widget.dart';
import 'package:social_app_fe/shared/component/custom_refresh_header.dart';
import 'package:social_app_fe/shared/component/post_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  Future<void> _onRefresh() async {
    // TODO: call API reload posts
    await Future.delayed(const Duration(seconds: 2));
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SmartRefresher(
        // add RefreshStyle
        controller: _refreshController,
        enablePullDown: true,
        header: const CustomRefreshHeader(
          icon: Icon(CupertinoIcons.house_fill, color: Colors.grey),
        ),
        onRefresh: _onRefresh,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            HomeHeaderWidget(),
            HomeStoriesWidget(),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(), // tránh scroll lồng nhau
              shrinkWrap: true, // giúp list con chiếm chiều cao vừa đủ
              itemCount: 10,
              itemBuilder: (context, index) {
                return PostItem();
              },
            ),
          ],
        ),
      ),
    );
  }
}
