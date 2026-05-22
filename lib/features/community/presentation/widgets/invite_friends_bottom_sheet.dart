import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/features/community/presentation/utils/community_l10n_helper.dart';
import 'package:social_app_fe/features/community/presentation/bloc/invite_friends_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/pages/other_profile_page.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

// Helper function để lấy giá trị từ dynamic data (Map hoặc Object)
String _getStringValue(dynamic value, [String defaultValue = '']) {
  if (value == null) return defaultValue;
  if (value is String) return value;
  return value.toString();
}

dynamic _getValue(dynamic obj, String key, [dynamic defaultValue]) {
  if (obj == null) return defaultValue;

  // Nếu là Map, truy cập bằng []
  if (obj is Map) {
    return obj[key] ?? defaultValue;
  }

  // Nếu là Object, truy cập bằng reflection hoặc try-catch
  try {
    return obj[key] ?? defaultValue;
  } catch (e) {
    return defaultValue;
  }
}

// Helper function để lấy ID từ friend object (thử nhiều keys)
String _extractFriendId(dynamic friend) {
  if (friend is Map) {
    // Thử các keys khác nhau
    final id = friend['_id'] ?? friend['id'] ?? friend['userId'] ?? '';
    return _getStringValue(id, '');
  }
  return '';
}

class InviteFriendsBottomSheet extends StatefulWidget {
  final String communityId;

  const InviteFriendsBottomSheet({super.key, required this.communityId});

  @override
  State<InviteFriendsBottomSheet> createState() =>
      _InviteFriendsBottomSheetState();
}

class _InviteFriendsBottomSheetState extends State<InviteFriendsBottomSheet> {
  late InviteFriendsBloc _bloc;
  String _searchQuery = '';
  final Set<String> _invitedFriendIds = {};

  @override
  void initState() {
    super.initState();
    _bloc = s1<InviteFriendsBloc>();
    _bloc.add(GetAvailableFriendsEvent(communityId: widget.communityId));
  }

  void _inviteFriend(String userId) {
    if (userId.isEmpty) {
      showErrorSnackBar(context, context.l10n.communityCannotIdentifyFriend);
      return;
    }

    setState(() {
      _invitedFriendIds.add(userId);
    });

    _bloc.add(
      InviteFriendEvent(communityId: widget.communityId, userId: userId),
    );
  }

  void _viewProfile(BuildContext context, userId) {
    if (userId != null) {
      Navigator.push(
        context,
        CupertinoPageRoute(
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InviteFriendsBloc>.value(
      value: _bloc,
      child: BlocListener<InviteFriendsBloc, InviteFriendsState>(
        listener: (context, state) {
          if (state is InviteFriendsSuccess) {
            showSuccessSnackBar(
              context,
              localizedCommunityMessage(context.l10n, state.message),
            );
          } else if (state is InviteFriendsError) {
            showErrorSnackBar(
              context,
              localizedCommunityMessage(context.l10n, state.message),
            );
          }
        },
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.65,
          maxChildSize: 0.95,
          minChildSize: 0.4,
          builder: (context, scrollController) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                // Handle indicator
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.person_add,
                              color: AppColors.primary,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.l10n.communityInviteFriendsTitle,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                      ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  context.l10n.communityInviteFriendsSubtitle,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF6B7280),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.toLowerCase();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: context.l10n.communityInviteSearchHint,
                          hintStyle: const TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 13,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFF9CA3AF),
                            size: 20,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFE5EAF0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFE5EAF0),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFFAFAFA),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<InviteFriendsBloc, InviteFriendsState>(
                    builder: (context, state) {
                      if (state is InviteFriendsLoading) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                context.l10n.communityLoadingFriends,
                                style: const TextStyle(
                                  color: Color(0xFF6B7280),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      if (state is InviteFriendsError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.error_outline,
                                  size: 32,
                                  color: Colors.red[400],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                localizedCommunityMessage(
                                  context.l10n,
                                  state.message,
                                ),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFF374151),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  _bloc.add(
                                    GetAvailableFriendsEvent(
                                      communityId: widget.communityId,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  context.l10n.commonRetry,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      if (state is InviteFriendsInviting) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                context.l10n.communitySendingInvite,
                                style: const TextStyle(
                                  color: Color(0xFF6B7280),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      List<dynamic> friends = [];
                      if (state is InviteFriendsLoaded) {
                        friends = state.friends;
                      } else if (state is InviteFriendsSuccess) {
                        friends = state.friends;
                      }

                      if (friends.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.people_outline,
                                  size: 32,
                                  color: Colors.grey[500],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                context.l10n.communityNoAvailableFriends,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      // Lọc bạn bè theo từ khóa tìm kiếm
                      final filteredFriends = friends.where((friend) {
                        final name = _getStringValue(
                          _getValue(friend, 'fullName', ''),
                        ).toLowerCase();
                        final username = _getStringValue(
                          _getValue(friend, 'username', ''),
                        ).toLowerCase();
                        return name.contains(_searchQuery) ||
                            username.contains(_searchQuery);
                      }).toList();

                      if (filteredFriends.isEmpty && _searchQuery.isNotEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                context.l10n.communityNoInviteSearchResults(
                                  _searchQuery,
                                ),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: filteredFriends.length,
                        itemBuilder: (context, index) {
                          final friend = filteredFriends[index];
                          final friendId = _extractFriendId(friend);
                          final friendName = _getStringValue(
                            _getValue(
                              friend,
                              'fullName',
                              context.l10n.commonUser,
                            ),
                            context.l10n.commonUser,
                          );
                          final friendUsername = _getStringValue(
                            _getValue(friend, 'username', ''),
                          );
                          final friendAvatar = _getStringValue(
                            _getValue(friend, 'avatarUrl') ??
                                _getValue(friend, 'avatar', ''),
                            '',
                          );
                          final isInvited = _invitedFriendIds.contains(
                            friendId,
                          );

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => _viewProfile(context, friendId),
                                borderRadius: BorderRadius.circular(14),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: const Color(0xFFE5EAF0),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.04),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () =>
                                            _viewProfile(context, friendId),
                                        child: CircleAvatar(
                                          radius: 26,
                                          backgroundColor: const Color(
                                            0xFFF3F4F6,
                                          ),
                                          backgroundImage:
                                              friendAvatar.isNotEmpty
                                              ? NetworkImage(friendAvatar)
                                              : null,
                                          child: friendAvatar.isEmpty
                                              ? Text(
                                                  friendName.isNotEmpty
                                                      ? friendName[0]
                                                      : '?',
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                )
                                              : null,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () =>
                                              _viewProfile(context, friendId),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                friendName,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF101828),
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '@$friendUsername',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF9CA3AF),
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      ElevatedButton(
                                        onPressed: isInvited
                                            ? null
                                            : () => _inviteFriend(friendId),
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 8,
                                          ),
                                          backgroundColor: isInvited
                                              ? const Color(0xFFE5E7EB)
                                              : AppColors.primary,
                                          disabledBackgroundColor: const Color(
                                            0xFFE5E7EB,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          elevation: 0,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              isInvited
                                                  ? Icons.check
                                                  : Icons.person_add,
                                              size: 14,
                                              color: isInvited
                                                  ? const Color(0xFF9CA3AF)
                                                  : Colors.white,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              isInvited
                                                  ? context
                                                        .l10n
                                                        .communityInvited
                                                  : context
                                                        .l10n
                                                        .communityInviteAction,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: isInvited
                                                    ? const Color(0xFF9CA3AF)
                                                    : AppColors.background,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
