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
import 'package:social_app_fe/features/community/presentation/pages/community_page.dart';
import 'package:social_app_fe/l10n/l10n.dart';

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
  const _MenuView();

  void _handleMenuItemTap(BuildContext context, String itemKey) {
    switch (itemKey) {
      case 'friends':
        // Navigate to friends page
        break;
      case 'groups':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CommunityPage()),
        );
      case 'reels':
        // Navigate to stories/reels page
        break;
      case 'explore':
        // Navigate to explore/discover page
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final mainItems = [
      {
        'icon': SvgPicture.asset(
          'assets/icons/friends.svg',
          width: 26,
          height: 26,
        ),
        'label': l10n.menuFriends,
        'onTap': () => _handleMenuItemTap(context, 'friends'),
      },
      {
        'icon': SvgPicture.asset(
          'assets/icons/groups.svg',
          width: 26,
          height: 26,
        ),
        'label': l10n.menuGroups,
        'onTap': () => _handleMenuItemTap(context, 'groups'),
      },
      {
        'icon': SvgPicture.asset(
          'assets/icons/film.svg',
          width: 26,
          height: 26,
        ),
        'label': l10n.menuReels,
        'onTap': () => _handleMenuItemTap(context, 'reels'),
      },
      {
        'icon': SvgPicture.asset(
          'assets/icons/global.svg',
          width: 26,
          height: 26,
        ),
        'label': l10n.menuExplore,
        'onTap': () => _handleMenuItemTap(context, 'explore'),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          l10n.menuTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
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
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
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
                    name: state.user.fullName ?? l10n.commonUser,
                    avatarUrl:
                        state.user.avatarUrl ??
                        "https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg",
                    userId: state.user.userId,
                  );
                }
                if (state is MenuLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is MenuErrorState) {
                  return Text(l10n.menuError(state.message));
                }
                return const SizedBox();
              },
            ),
            const SizedBox(height: 16),
            MenuSection(title: l10n.menuUtilities, items: mainItems),
            const SizedBox(height: 16),
            const MenuFooter(),
          ],
        ),
      ),
    );
  }
}
