import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class ProfileTabs extends StatefulWidget {
  const ProfileTabs({super.key});

  @override
  State<ProfileTabs> createState() => _ProfileTabsState();
}

class _ProfileTabsState extends State<ProfileTabs>
    with TickerProviderStateMixin {
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
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,

          tabs: [
            Tab(text: context.l10n.profilePostsTab),
            Tab(text: context.l10n.profilePhotosTab),
            Tab(text: context.l10n.profileReelsTab),
          ],
        ),
        SizedBox(
          height: 400, // placeholder chiều cao vùng nội dung
          child: TabBarView(
            controller: _tabController,
            children: [
              Center(child: Text(context.l10n.profilePostsList)),
              Center(child: Text(context.l10n.profileYourPhotos)),
              Center(child: Text(context.l10n.profileYourReels)),
            ],
          ),
        ),
      ],
    );
  }
}
