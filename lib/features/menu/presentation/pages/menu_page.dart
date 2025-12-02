import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/di/injection.dart';
import '../bloc/menu_bloc.dart';
import '../bloc/menu_event.dart';
import '../bloc/menu_state.dart';
import '../widgets/menu_header.dart';
import '../widgets/menu_section.dart';
import '../widgets/menu_footer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MenuBloc>(
      create: (_) => s1<MenuBloc>()..add(LoadCurrentUserEvent()),
      child: const _MenuView(),
    );
  }
}

class _MenuView extends StatelessWidget {
  const _MenuView({super.key});

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
          'assets/icons/film.svg',
          width: 26,
          height: 26,
        ),
        'label': 'Thước phim',
      },
      {
        'icon': SvgPicture.asset(
          'assets/icons/global.svg',
          width: 26,
          height: 26,
        ),
        'label': 'Khám phá',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
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
            BlocBuilder<MenuBloc, MenuState>(
              builder: (context, state) {
                if (state is MenuLoadedState) {
                  return MenuHeader(
                    name: state.user.fullName ?? "User",
                    avatarUrl: state.user.avatarUrl ?? "",
                    userId: state.user.userId,
                  );
                }
                if (state is MenuLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is MenuErrorState) {
                  return Text('Lỗi: ${state.message}');
                }
                return const SizedBox();
              },
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
