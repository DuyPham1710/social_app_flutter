import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/post_item.dart';
import 'package:social_app_fe/features/profile/presentation/widgets/profile_header.dart';
import 'package:social_app_fe/features/profile/presentation/widgets/profile_info.dart';
import '../bloc/other_profile_bloc.dart';
import '../bloc/other_profile_state.dart';
import '../widgets/other_profile_actions.dart';

class OtherProfilePage extends StatefulWidget {
  const OtherProfilePage({super.key});

  @override
  State<OtherProfilePage> createState() => _OtherProfilePageState();
}

class _OtherProfilePageState extends State<OtherProfilePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<OtherProfileBloc, OtherProfileState>(
        builder: (context, state) {
          if (state is OtherProfileLoading || state.user == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final user = state.user!;
          final posts = state.posts ?? [];

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: AppColors.background,
                title: Text(user.fullName ?? "Trang cá nhân"),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  ProfileHeader(user: user),
                  OtherProfileActions(
                    relationship: state.relationship,
                    onSendRequest: () {
                      // TODO: Gửi lời mời
                    },
                    onCancelRequest: () {
                      // TODO: Hủy yêu cầu
                    },
                    onAcceptRequest: () {
                      // TODO: Chấp nhận
                    },
                    onUnfriend: () {
                      // TODO: Hủy kết bạn
                    },
                    onMessage: () {
                      // TODO: Mở chat
                    },
                  ),
                  const ProfileInfo(),
                  const Divider(),
                  if (posts.isEmpty)
                    const Center(child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text("Chưa có bài viết nào"),
                    )),
                  ...posts.map((post) => PostItem(post: post)),
                ]),
              ),
            ],
          );
        },
      ),
    );
  }
}
