import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import '../widgets/menu_header.dart';
import '../widgets/menu_section.dart';
import '../widgets/menu_footer.dart';
import '../../../../../shared/component/layout/icon_text_tile.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mainItems = [
      {
        'icon': SvgPicture.asset(
          'assets/icons/friends.svg',
          width: 26,
          height: 26,
        ),
        'label': 'Bạn bè',
      },
      {
        'icon': SvgPicture.asset(
          'assets/icons/groups.svg',
          width: 26,
          height: 26,
        ),
        'label': 'Nhóm',
      },
      {
        'icon': SvgPicture.asset(
          'assets/icons/groups.svg',
          width: 26,
          height: 26,
        ),
        'label': 'Nhóm',
      },
      {
        'icon': SvgPicture.asset(
          'assets/icons/groups.svg',
          width: 26,
          height: 26,
        ),
        'label': 'Nhóm',
      },
      {
        'icon': SvgPicture.asset(
          'assets/icons/groups.svg',
          width: 26,
          height: 26,
        ),
        'label': 'Nhóm',
      },
      {
        'icon': SvgPicture.asset(
          'assets/icons/groups.svg',
          width: 26,
          height: 26,
        ),
        'label': 'Nhóm',
      },
      {
        'icon': SvgPicture.asset(
          'assets/icons/groups.svg',
          width: 26,
          height: 26,
        ),
        'label': 'Nhóm',
      },
      {
        'icon': SvgPicture.asset(
          'assets/icons/groups.svg',
          width: 26,
          height: 26,
        ),
        'label': 'Nhóm',
      },
      {
        'icon': SvgPicture.asset(
          'assets/icons/groups.svg',
          width: 26,
          height: 26,
        ),
        'label': 'Nhóm',
      },
      {
        'icon': SvgPicture.asset(
          'assets/icons/groups.svg',
          width: 26,
          height: 26,
        ),
        'label': 'Nhóm',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // ẩn nút back
        title: const Text(
          'Menu',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: AppColors.background,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black87),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MenuHeader(
              name: 'Nguyễn.H.N. Lam',
              avatarUrl: 'https://i.pravatar.cc/150?img=10',
              userId: '68e9d3fa7ae32fe700d1d3cc',
            ),
            const SizedBox(height: 16),
            MenuSection(title: 'Tiện ích', items: mainItems),
            const SizedBox(height: 16),
            const MenuFooter(),
          ],
        ),
      ),
    );
  }
}
