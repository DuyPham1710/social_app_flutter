import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/local/app_preferences.dart';
import 'package:social_app_fe/features/chat/presentation/pages/chat_list_page.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class SideNavigation extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTabSelected;
  final int unreadCount;
  final String avt;

  const SideNavigation({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    this.unreadCount = 0,
    required this.avt,
  });

  @override
  State<SideNavigation> createState() => _SideNavigationState();
}

class _SideNavigationState extends State<SideNavigation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _widthAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _widthAnimation =
        Tween<double>(
          begin: ResponsiveHelper.sidebarCollapsedWidth,
          end: ResponsiveHelper.sidebarExpandedWidth,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onEnter(PointerEvent details) {
    _animationController.forward();
  }

  void _onExit(PointerEvent details) {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      child: AnimatedBuilder(
        animation: _widthAnimation,
        builder: (context, child) {
          return Container(
            width: _widthAnimation.value,
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border(
                right: BorderSide(color: AppColors.divider, width: 0.5),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Logo section
                  _buildLogo(),
                  const SizedBox(height: 8),

                  // Navigation items
                  _buildNavItem(
                    index: 0,
                    icon: CupertinoIcons.house_fill,
                    activeIcon: CupertinoIcons.house_fill,
                    label: context.l10n.navHome,
                  ),
                  _buildNavItem(
                    index: 1,
                    icon: CupertinoIcons.person_2,
                    activeIcon: CupertinoIcons.person_2_fill,
                    label: context.l10n.menuFriends,
                  ),
                  _buildNavItem(
                    index: 2,
                    icon: CupertinoIcons.plus_app,
                    activeIcon: CupertinoIcons.plus_app_fill,
                    label: context.l10n.postCreateTitle,
                  ),
                  _buildNotificationNavItem(
                    index: 3,
                    icon: CupertinoIcons.bell,
                    activeIcon: CupertinoIcons.bell_fill,
                    label: context.l10n.notificationTitle,
                  ),
                  _buildProfileNavItem(
                    index: 4,
                    label: context.l10n.profileTitle,
                  ),

                  const Spacer(),

                  // Search button at bottom
                  _buildNavItem(
                    index: -1,
                    icon: CupertinoIcons.search,
                    activeIcon: CupertinoIcons.search,
                    label: context.l10n.searchHint,
                    onTap: () {
                      Navigator.pushNamed(context, '/search');
                    },
                  ),
                  // Chat button
                  _buildNavItem(
                    index: -2,
                    icon: CupertinoIcons.chat_bubble_2,
                    activeIcon: CupertinoIcons.chat_bubble_2_fill,
                    label: context.l10n.chatTitle,
                    onTap: () {
                      if (!ResponsiveHelper.isMobile(context) &&
                          ResponsiveHelper.shouldShowSidebar(context)) {
                        Navigator.pushNamed(context, '/chat-web');
                      } else {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => const ChatListPage(),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogo() {
    final isExpanded =
        _widthAnimation.value > ResponsiveHelper.sidebarCollapsedWidth + 20;

    return Container(
      height: 64,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 150),
        child: isExpanded
            ? Text(
                'CommonsHub',
                key: const ValueKey('logo-text'),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  s1<AppPreferences>().isDarkMode
                      ? 'assets/icons/dark_logo.png'
                      : 'assets/icons/logo.jpg',
                  key: const ValueKey('logo-image'),
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    VoidCallback? onTap,
  }) {
    final isActive = widget.currentIndex == index;
    final color = isActive ? AppColors.primary : AppColors.unselectedIcon;
    final fontWeight = isActive ? FontWeight.bold : FontWeight.normal;
    final isExpanded =
        _widthAnimation.value > ResponsiveHelper.sidebarCollapsedWidth + 20;

    return _NavItemHover(
      onTap: onTap ?? () => widget.onTabSelected(index),
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: isExpanded
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            Icon(isActive ? activeIcon : icon, size: 26, color: color),
            if (isExpanded) ...[
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    color: color,
                    fontWeight: fontWeight,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isActive = widget.currentIndex == index;
    final color = isActive ? AppColors.primary : AppColors.unselectedIcon;
    final fontWeight = isActive ? FontWeight.bold : FontWeight.normal;
    final isExpanded =
        _widthAnimation.value > ResponsiveHelper.sidebarCollapsedWidth + 20;

    return _NavItemHover(
      onTap: () => widget.onTabSelected(index),
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: isExpanded
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(isActive ? activeIcon : icon, size: 26, color: color),
                if (!isExpanded && widget.unreadCount > 0)
                  Positioned(
                    right: -8,
                    top: -5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 220, 53, 69),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(minWidth: 18),
                      child: Text(
                        widget.unreadCount > 99
                            ? '99+'
                            : widget.unreadCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            if (isExpanded) ...[
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    color: color,
                    fontWeight: fontWeight,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              if (widget.unreadCount > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 220, 53, 69),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.unreadCount > 99
                        ? '99+'
                        : widget.unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfileNavItem({required int index, required String label}) {
    final isActive = widget.currentIndex == index;
    final color = isActive ? AppColors.primary : AppColors.unselectedIcon;
    final fontWeight = isActive ? FontWeight.bold : FontWeight.normal;
    final textColor = isActive ? AppColors.primary : AppColors.unselectedIcon;
    final isExpanded =
        _widthAnimation.value > ResponsiveHelper.sidebarCollapsedWidth + 20;
    final hasAvatar = widget.avt.isNotEmpty;

    return _NavItemHover(
      onTap: () => widget.onTabSelected(index),
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: isExpanded
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(1.5),
                child: ClipOval(
                  child: hasAvatar
                      ? Image.network(
                          widget.avt,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.person, size: 18, color: color);
                          },
                        )
                      : Icon(Icons.person, size: 18, color: color),
                ),
              ),
            ),
            if (isExpanded) ...[
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    color: textColor,
                    fontWeight: fontWeight,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A wrapper that applies hover effect on each nav item.
class _NavItemHover extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;

  const _NavItemHover({required this.onTap, required this.child});

  @override
  State<_NavItemHover> createState() => _NavItemHoverState();
}

class _NavItemHoverState extends State<_NavItemHover> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior
            .opaque, // đảm bảo toàn bộ vùng của nav item đều có thể nhận tap
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: _isHovered
                ? AppColors.unselectedIcon.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
