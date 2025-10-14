import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/post/domain/entities/post_entity.dart';
import 'package:social_app_fe/features/post/domain/entities/post_url_entity.dart';
import 'package:social_app_fe/features/profile/domain/entities/UserModel.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_item.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_actions.dart';
import '../widgets/profile_info.dart';
import '../widgets/profile_highlights.dart';
import '../widgets/profile_tabs.dart';
import '../widgets/friend_list_widget.dart';
import '../widgets/create_post_widget.dart';
import 'package:social_app_fe/core/enums/privacy_type.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 🧩 Danh sách bài viết mẫu
    final dummyPosts = [
      PostEntity(
        id: "1",
        caption: "Một ngày đẹp trời để yêu đời 🌤️",
        user: const UserModel(
          userId: "u1",
          fullName: "Nguyễn.H.N. Lam",
          avatarUrl: "https://i.pravatar.cc/150?img=10",
        ),
        urls: const [
          PostUrlEntity(
            id: "img1",
            url: "https://picsum.photos/400/300",
            order: 1,
          ),
          PostUrlEntity(
            id: "img2",
            url: "https://picsum.photos/401/300",
            order: 2,
          ),
        ],
        layout: "classic",
        privacyType: PrivacyType.public,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      PostEntity(
        id: "2",
        caption: "Đi cà phê chill ☕",
        user: const UserModel(
          userId: "u1",
          fullName: "Nguyễn.H.N. Lam",
          avatarUrl: "https://i.pravatar.cc/150?img=10",
        ),
        urls: const [
          PostUrlEntity(
            id: "img3",
            url: "https://picsum.photos/402/300",
            order: 1,
          ),
        ],
        layout: "column",
        privacyType: PrivacyType.friends,
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 🔹 Header
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.background,
            elevation: 0,
            title: const Text(
              'Nguyễn.H.N. Lam',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            actions: const [
              Icon(Icons.settings_outlined, color: AppColors.textPrimary),
              SizedBox(width: 12),
              Icon(Icons.search, color: AppColors.iconPrimary),
              SizedBox(width: 8),
            ],
          ),

          // 🔹 Nội dung trang
          SliverList(
            delegate: SliverChildListDelegate([
              const ProfileHeader(),
              const ProfileActions(),
              const ProfileInfo(),
              const Divider(),
              FriendListWidget(
                friends: [
                  {
                    "name": "Nguyễn Minh",
                    "avatarUrl": "https://i.pravatar.cc/150?img=11",
                  },
                  {
                    "name": "Trần Linh",
                    "avatarUrl": "https://i.pravatar.cc/150?img=12",
                  },
                  {
                    "name": "Nguyễn Minh",
                    "avatarUrl": "https://i.pravatar.cc/150?img=13",
                  },
                  {
                    "name": "Trần Linh",
                    "avatarUrl": "https://i.pravatar.cc/150?img=14",
                  },
                  {
                    "name": "Nguyễn Minh",
                    "avatarUrl": "https://i.pravatar.cc/150?img=15",
                  },
                  {
                    "name": "Trần Linh",
                    "avatarUrl": "https://i.pravatar.cc/150?img=16",
                  },
                  // ...
                ],
                onViewAll: () => Navigator.pushNamed(context, '/friends'),
              ),
              const Divider(),
              const SizedBox(height: 12),
              CreatePostWidget(
                avatarUrl: 'https://i.pravatar.cc/150?img=10',
                onCreatePost: () =>
                    Navigator.pushNamed(context, '/create_post'),
              ),
              const Divider(),
              //Danh sách bài viết
              ...dummyPosts.map((post) => PostItem(post: post)).toList(),
            ]),
          ),
        ],
      ),
    );
  }
}
