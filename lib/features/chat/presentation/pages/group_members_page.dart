import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/pages/other_profile_page.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class GroupMembersPage extends StatefulWidget {
  final List<UserEntity> participants;
  final String? currentUserId;
  final String? groupName;
  final bool isWebLayout;
  final VoidCallback? onBack;

  const GroupMembersPage({
    super.key,
    required this.participants,
    this.currentUserId,
    this.groupName,
    this.isWebLayout = false,
    this.onBack,
  });

  @override
  State<GroupMembersPage> createState() => _GroupMembersPageState();
}

class _GroupMembersPageState extends State<GroupMembersPage> {
  late List<UserEntity> _filteredParticipants;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredParticipants = widget.participants;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredParticipants = widget.participants;
      } else {
        _filteredParticipants = widget.participants.where((user) {
          final name = (user.fullName ?? user.username ?? '').toLowerCase();
          final username = (user.username ?? '').toLowerCase();
          return name.contains(query) || username.contains(query);
        }).toList();
      }
    });
  }

  void _navigateToProfile(UserEntity user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) =>
              s1<OtherProfileBloc>()
                ..add(LoadOtherUserProfileEvent(userId: user.userId)),
          child: OtherProfilePage(userId: user.userId),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    // Web layout: render as inline panel (no Scaffold)
    if (widget.isWebLayout) {
      return _buildBody(l10n, isInline: true);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.chatViewGroupMembers,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              l10n.chatMembersCount(widget.participants.length),
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12.sp),
            ),
          ],
        ),
      ),
      body: _buildBody(l10n, isInline: false),
    );
  }

  Widget _buildBody(dynamic l10n, {required bool isInline}) {
    return Column(
      children: [
        // Web inline header with back button
        if (isInline) _buildWebHeader(l10n),

        // Search bar
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Container(
            height: 40.h,
            decoration: BoxDecoration(
              color: AppColors.secondBackground,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: AppColors.textPrimary, fontSize: 14.sp),
              decoration: InputDecoration(
                hintText: l10n.chatSearchHint,
                hintStyle: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14.sp,
                ),
                prefixIcon: Icon(
                  CupertinoIcons.search,
                  color: AppColors.textSecondary,
                  size: 18.sp,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _searchController.clear();
                        },
                        child: Icon(
                          CupertinoIcons.clear_circled_solid,
                          color: AppColors.textSecondary,
                          size: 18.sp,
                        ),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10.h),
              ),
            ),
          ),
        ),

        // Members list
        Expanded(
          child: _filteredParticipants.isEmpty
              ? _buildEmptyState(l10n)
              : ListView.builder(
                  itemCount: _filteredParticipants.length,
                  padding: EdgeInsets.only(bottom: 20.h),
                  itemBuilder: (context, index) {
                    final user = _filteredParticipants[index];
                    final isCurrentUser = user.userId == widget.currentUserId;
                    return _buildMemberTile(
                      user: user,
                      isCurrentUser: isCurrentUser,
                      l10n: l10n,
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildWebHeader(dynamic l10n) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.divider.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(CupertinoIcons.back, color: AppColors.textPrimary),
            onPressed: widget.onBack,
            tooltip: l10n.commonBack,
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.chatViewGroupMembers,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  l10n.chatMembersCount(widget.participants.length),
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(dynamic l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.person_2,
            size: 56.sp,
            color: AppColors.textSecondary.withOpacity(0.4),
          ),
          SizedBox(height: 12.h),
          Text(
            l10n.friendNoSuggestions,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 15.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberTile({
    required UserEntity user,
    required bool isCurrentUser,
    required dynamic l10n,
  }) {
    final displayName = user.fullName ?? user.username ?? l10n.commonUser;
    final avatarUrl = user.avatarUrl;

    return InkWell(
      onTap: isCurrentUser ? null : () => _navigateToProfile(user),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                CircleAvatar(
                  radius: 26.r,
                  backgroundColor: AppColors.secondBackground,
                  backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                      ? NetworkImage(avatarUrl)
                      : null,
                  child: avatarUrl == null || avatarUrl.isEmpty
                      ? Text(
                          displayName.isNotEmpty
                              ? displayName[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                // Online indicator if user is active
                if (user.isActive == true)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 13.w,
                      height: 13.w,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.background,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(width: 14.w),

            // Name & username
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          displayName,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isCurrentUser) ...[
                        SizedBox(width: 6.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            l10n.chatYou,
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (user.username != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      '@${user.username}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Arrow icon (only for non-current user)
            if (!isCurrentUser)
              Icon(
                CupertinoIcons.chevron_right,
                size: 16.sp,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
          ],
        ),
      ),
    );
  }
}
