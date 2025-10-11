import 'package:flutter/material.dart';

class ProfileTabs extends StatefulWidget {
  const ProfileTabs({super.key});

  @override
  State<ProfileTabs> createState() => _ProfileTabsState();
}

class _ProfileTabsState extends State<ProfileTabs> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          indicatorColor: Colors.blue,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.black54,
          tabs: const [
            Tab(text: 'Bài viết'),
            Tab(text: 'Ảnh'),
            Tab(text: 'Reels'),
          ],
        ),
        SizedBox(
          height: 400, // placeholder chiều cao vùng nội dung
          child: TabBarView(
            controller: _tabController,
            children: const [
              Center(child: Text('Danh sách bài viết')),
              Center(child: Text('Ảnh của bạn')),
              Center(child: Text('Reels của bạn')),
            ],
          ),
        ),
      ],
    );
  }
}
