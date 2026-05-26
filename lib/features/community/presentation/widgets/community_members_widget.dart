import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/community/data/models/member_model.dart';
import 'package:social_app_fe/features/community/domain/repository/community_repository.dart';
import 'package:social_app_fe/features/community/presentation/bloc/community_admin_bloc.dart';
import 'package:social_app_fe/features/community/presentation/utils/community_l10n_helper.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/pages/other_profile_page.dart';
import 'package:social_app_fe/features/profile/presentation/pages/profile_page.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';

class CommunityMembersWidget extends StatefulWidget {
  final String communityId;
  final int refreshSeed;
  final bool isInBottomSheet;
  final String? userRole;

  const CommunityMembersWidget({
    super.key,
    required this.communityId,
    this.refreshSeed = 0,
    this.isInBottomSheet = false,
    this.userRole,
  });

  @override
  State<CommunityMembersWidget> createState() => _CommunityMembersWidgetState();
}

class _CommunityMembersWidgetState extends State<CommunityMembersWidget> {
  late Future<List<MemberModel>> _membersFuture;
  final CommunityRepository _communityRepository = s1<CommunityRepository>();
  final TextEditingController _searchController = TextEditingController();

  static Color get _surface => AppColors.background;
  static Color get _pageTint => AppColors.secondBackground;
  static Color get _border => AppColors.divider;
  static Color get _text => AppColors.textPrimary;
  static Color get _mutedText => AppColors.textSecondary;

  @override
  void initState() {
    super.initState();
    _membersFuture = _loadMembers();
  }

  @override
  void didUpdateWidget(covariant CommunityMembersWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refreshSeed != widget.refreshSeed ||
        oldWidget.communityId != widget.communityId) {
      _refreshMembers();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<MemberModel>> _loadMembers() async {
    final dataState = await _communityRepository.getMembers(
      communityId: widget.communityId,
      page: 1,
      limit: 50,
    );

    if (dataState is DataStateSuccess<List<MemberModel>>) {
      return dataState.data ?? const [];
    }

    if (dataState is DataStateError) {
      throw dataState.error ?? Exception('Failed to load members');
    }

    return const [];
  }

  void _refreshMembers() {
    setState(() {
      _membersFuture = _loadMembers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final content = widget.isInBottomSheet
        ? Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: _buildMembersContent(),
          )
        : Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: _border),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.textSecondary.withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                child: _buildMembersContent(),
              ),
            ),
          );

    return BlocListener<CommunityAdminBloc, CommunityAdminState>(
      listener: (context, state) {
        if (state is CommunityAdminActionSuccess) {
          showSuccessSnackBar(
            context,
            localizedCommunityMessage(context.l10n, state.message),
          );
          _refreshMembers();
        } else if (state is CommunityAdminError) {
          showErrorSnackBar(
            context,
            localizedCommunityMessage(context.l10n, state.message),
          );
        }
      },
      child: content,
    );
  }

  Widget _buildMembersContent() {
    return FutureBuilder<List<MemberModel>>(
      future: _membersFuture,
      builder: (context, snapshot) {
        final members = snapshot.data ?? const <MemberModel>[];
        final filteredMembers = _filterMembers(members);
        final isLoading = snapshot.connectionState == ConnectionState.waiting;

        Widget body;
        if (isLoading) {
          body = _buildSkeletonLoading();
        } else if (snapshot.hasError) {
          body = _buildErrorState(snapshot.error);
        } else if (members.isEmpty) {
          body = _buildEmptyState(
            icon: Icons.groups_2_outlined,
            title: context.l10n.communityNoMembers,
            message: context.l10n.communityNoMembersMessage,
          );
        } else if (filteredMembers.isEmpty) {
          body = _buildEmptyState(
            icon: Icons.search_off_rounded,
            title: context.l10n.communityNoMembersFound,
            message: context.l10n.communityNoMembersFoundMessage,
          );
        } else {
          body = _buildMemberList(filteredMembers);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(
              totalMembers: members.length,
              visibleMembers: filteredMembers.length,
              isLoading: isLoading,
            ),
            if (!isLoading && members.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildSearchField(),
            ],
            const SizedBox(height: 14),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 240),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: body,
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader({
    required int totalMembers,
    required int visibleMembers,
    required bool isLoading,
  }) {
    final countLabel = isLoading
        ? context.l10n.commonLoading
        : _searchController.text.trim().isEmpty
        ? context.l10n.communityMembersCount(totalMembers)
        : context.l10n.communityVisibleMembersCount(
            visibleMembers,
            totalMembers,
          );

    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(Icons.groups_rounded, color: AppColors.primary),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.isInBottomSheet
                    ? context.l10n.communityMembersListTitle
                    : context.l10n.communityMembers,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: _text,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                countLabel,
                style: TextStyle(
                  color: _mutedText,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Tooltip(
          message: context.l10n.commonRefresh,
          child: IconButton.filledTonal(
            onPressed: isLoading ? null : _refreshMembers,
            icon: const Icon(Icons.refresh_rounded),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.secondBackground,
              foregroundColor: _text,
              disabledBackgroundColor: AppColors.secondBackground,
              disabledForegroundColor: AppColors.textSecondary.withValues(
                alpha: 0.55,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onChanged: (_) => setState(() {}),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: context.l10n.communitySearchMembersHint,
        hintStyle: TextStyle(color: AppColors.textSecondary),
        prefixIcon: Icon(
          Icons.search_rounded,
          size: 21,
          color: AppColors.textSecondary,
        ),
        suffixIcon: _searchController.text.isEmpty
            ? null
            : IconButton(
                tooltip: context.l10n.communityClearSearch,
                onPressed: () {
                  _searchController.clear();
                  setState(() {});
                },
                icon: Icon(
                  Icons.close_rounded,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
              ),
        isDense: true,
        filled: true,
        fillColor: _pageTint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: _border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: _border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.primary, width: 1.3),
        ),
      ),
      style: TextStyle(color: AppColors.textPrimary),
    );
  }

  Widget _buildMemberList(List<MemberModel> members) {
    return Column(
      key: ValueKey('data-${members.length}-${_searchController.text}'),
      children: [
        for (var index = 0; index < members.length; index++) ...[
          _MemberTile(
            member: members[index],
            canManage:
                widget.userRole == 'admin' &&
                members[index].role.toLowerCase() != 'admin',
            onTap: () => _handleMemberTap(context, members[index].user.userId),
            onRemove: () => _showKickConfirmation(
              context,
              members[index].user.fullName ?? context.l10n.communityMember,
              members[index].user.userId,
            ),
          ),
          if (index != members.length - 1)
            Divider(height: 1, indent: 64, color: AppColors.divider),
        ],
      ],
    );
  }

  Widget _buildErrorState(Object? error) {
    return Container(
      key: const ValueKey('error'),
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE11D48).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE11D48).withValues(alpha: 0.28),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline_rounded, color: Color(0xFFE11D48)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.communityLoadMembersFailed,
                  style: const TextStyle(
                    color: Color(0xFF9F1239),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$error',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFBE123C),
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _refreshMembers,
            child: Text(context.l10n.commonRetry),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Container(
      key: ValueKey(title),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 18),
      decoration: BoxDecoration(
        color: _pageTint,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 28, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _text,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: _mutedText, fontSize: 13, height: 1.35),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonLoading() {
    return Column(
      key: const ValueKey('loading'),
      children: List.generate(
        4,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: index == 3 ? 0 : 14),
          child: Row(
            children: const [
              _SkeletonBox(width: 48, height: 48, radius: 24),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SkeletonBox(width: 160, height: 14, radius: 7),
                    SizedBox(height: 9),
                    _SkeletonBox(width: 108, height: 12, radius: 6),
                  ],
                ),
              ),
              _SkeletonBox(width: 34, height: 34, radius: 17),
            ],
          ),
        ),
      ),
    );
  }

  List<MemberModel> _filterMembers(List<MemberModel> members) {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return members;

    return members.where((member) {
      final user = member.user;
      final fullName = user.fullName?.toLowerCase() ?? '';
      final username = user.username?.toLowerCase() ?? '';
      return fullName.contains(query) || username.contains(query);
    }).toList();
  }

  Future<void> _handleMemberTap(BuildContext context, String userId) async {
    final userData = await TokenStorage.getUserData();
    final currentUserId = userData?['id'];

    if (!context.mounted) return;

    if (currentUserId == userId) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => s1<ProfileBloc>()..add(const LoadUserProfileEvent()),
            child: const ProfilePage(),
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                s1<OtherProfileBloc>()
                  ..add(LoadOtherUserProfileEvent(userId: userId)),
            child: OtherProfilePage(userId: userId),
          ),
        ),
      );
    }
  }

  void _showKickConfirmation(
    BuildContext context,
    String userName,
    String memberId,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            Expanded(child: Text(context.l10n.communityRemoveMemberTitle)),
          ],
        ),
        content: Text(
          context.l10n.communityRemoveMemberConfirm(userName),
          style: const TextStyle(height: 1.35),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<CommunityAdminBloc>().add(
                KickMemberRequested(
                  communityId: widget.communityId,
                  memberId: memberId,
                ),
              );
            },
            label: Text(context.l10n.commonDelete),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _MemberTile extends StatelessWidget {
  final MemberModel member;
  final bool canManage;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _MemberTile({
    required this.member,
    required this.canManage,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final user = member.user;
    final isAdmin = member.role.toLowerCase() == 'admin';
    final username = user.username?.trim();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              _MemberAvatar(
                avatarUrl: user.avatarUrl,
                fallbackName: user.fullName ?? username ?? '',
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            user.fullName ?? context.l10n.commonUser,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (isAdmin) const SizedBox(width: 8),
                        if (isAdmin) const _RolePill(isAdmin: true),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (!isAdmin) const _RolePill(isAdmin: false),
                        if (member.createdAt != null)
                          _JoinedDate(date: member.createdAt!),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (canManage)
                PopupMenuButton<String>(
                  color: AppColors.background,
                  tooltip: context.l10n.communityMemberOptions,
                  onSelected: (value) {
                    if (value == 'remove') onRemove();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'remove',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.person_remove_rounded,
                            color: Color(0xFFDC2626),
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            context.l10n.communityRemoveFromGroup,
                            style: const TextStyle(color: Color(0xFFDC2626)),
                          ),
                        ],
                      ),
                    ),
                  ],
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.more_horiz_rounded,
                      color: AppColors.textSecondary,
                    ),
                  ),
                )
              else
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textSecondary.withValues(alpha: 0.55),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MemberAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String fallbackName;

  const _MemberAvatar({required this.avatarUrl, required this.fallbackName});

  @override
  Widget build(BuildContext context) {
    final initial = fallbackName.trim().isEmpty
        ? '?'
        : fallbackName.trim().characters.first.toUpperCase();
    final hasAvatar = avatarUrl != null && avatarUrl!.isNotEmpty;

    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.divider, width: 2),
      ),
      child: ClipOval(
        child: hasAvatar
            ? Image.network(
                avatarUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _AvatarFallback(initial: initial),
              )
            : _AvatarFallback(initial: initial),
      ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  final String initial;

  const _AvatarFallback({required this.initial});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.12),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
          fontSize: 18,
        ),
      ),
    );
  }
}

class _RolePill extends StatelessWidget {
  final bool isAdmin;

  const _RolePill({required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isAdmin
            ? AppColors.primary.withValues(alpha: 0.12)
            : AppColors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isAdmin
              ? AppColors.primary.withValues(alpha: 0.24)
              : AppColors.primary.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isAdmin ? Icons.verified_user_rounded : Icons.person_rounded,
            size: 12,
            color: AppColors.primary,
          ),
          const SizedBox(width: 4),
          Text(
            isAdmin
                ? context.l10n.communityAdmin
                : context.l10n.communityMember,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _JoinedDate extends StatelessWidget {
  final DateTime date;

  const _JoinedDate({required this.date});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.calendar_today_rounded,
          size: 12,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 4),
        Text(
          DateFormat('dd/MM/yyyy').format(date.toLocal()),
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double? width;
  final double height;
  final double radius;

  const _SkeletonBox({this.width, required this.height, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.textSecondary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
