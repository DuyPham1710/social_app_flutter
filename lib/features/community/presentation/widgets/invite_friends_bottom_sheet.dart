import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  InviteFriendsBottomSheet({super.key, required this.communityId});

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
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.rsr(context)),
                topRight: Radius.circular(24.rsr(context)),
              ),
            ),
            child: Column(
              children: [
                // Handle indicator
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    20.rs(context),
                    20.rsh(context),
                    20.rs(context),
                    16.rsh(context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40.rs(context),
                            height: 40.rsh(context),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(
                                12.rsr(context),
                              ),
                            ),
                            child: Icon(
                              Icons.person_add,
                              color: AppColors.primary,
                              size: 22.rsp(context),
                            ),
                          ),
                          SizedBox(width: 12.rs(context)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.l10n.communityInviteFriendsTitle,
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18.rsp(context),
                                  ),
                                ),
                                SizedBox(height: 2.rsh(context)),
                                Text(
                                  context.l10n.communityInviteFriendsSubtitle,
                                  style: TextStyle(
                                    fontSize: 13.rsp(context),
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.rsh(context)),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.toLowerCase();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: context.l10n.communityInviteSearchHint,
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13.rsp(context),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppColors.textSecondary,
                            size: 20.rsp(context),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              12.rsr(context),
                            ),
                            borderSide: BorderSide(color: AppColors.divider),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              12.rsr(context),
                            ),
                            borderSide: BorderSide(
                              color: AppColors.divider,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              12.rsr(context),
                            ),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 1.5.rs(context),
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 14.rs(context),
                            vertical: 12.rsh(context),
                          ),
                          filled: true,
                          fillColor: AppColors.secondBackground,
                        ),
                        style: TextStyle(color: AppColors.textPrimary),
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
                              SizedBox(height: 12.rsh(context)),
                              Text(
                                context.l10n.communityLoadingFriends,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13.rsp(context),
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
                                width: 60.rs(context),
                                height: 60.rsh(context),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(
                                    12.rsr(context),
                                  ),
                                ),
                                child: Icon(
                                  Icons.error_outline,
                                  size: 32.rsp(context),
                                  color: Colors.red[400],
                                ),
                              ),
                              SizedBox(height: 12.rsh(context)),
                              Text(
                                localizedCommunityMessage(
                                  context.l10n,
                                  state.message,
                                ),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 13.rsp(context),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 16.rsh(context)),
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
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24.rs(context),
                                    vertical: 10.rsh(context),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      8.rsr(context),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  context.l10n.commonRetry,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.rsp(context),
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
                              SizedBox(height: 12.rsh(context)),
                              Text(
                                context.l10n.communitySendingInvite,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13.rsp(context),
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
                                width: 60.rs(context),
                                height: 60.rsh(context),
                                decoration: BoxDecoration(
                                  color: AppColors.secondBackground,
                                  borderRadius: BorderRadius.circular(
                                    12.rsr(context),
                                  ),
                                ),
                                child: Icon(
                                  Icons.people_outline,
                                  size: 32.rsp(context),
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              SizedBox(height: 12.rsh(context)),
                              Text(
                                context.l10n.communityNoAvailableFriends,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13.rsp(context),
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
                                size: 48.rsp(context),
                                color: AppColors.textSecondary.withValues(
                                  alpha: 0.75,
                                ),
                              ),
                              SizedBox(height: 12.rsh(context)),
                              Text(
                                context.l10n.communityNoInviteSearchResults(
                                  _searchQuery,
                                ),
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13.rsp(context),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        controller: scrollController,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.rs(context),
                        ),
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
                            padding: EdgeInsets.symmetric(
                              vertical: 8.rsh(context),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => _viewProfile(context, friendId),
                                borderRadius: BorderRadius.circular(
                                  14.rsr(context),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(12.rs(context)),
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.circular(
                                      14.rsr(context),
                                    ),
                                    border: Border.all(
                                      color: AppColors.divider,
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.textSecondary
                                            .withValues(alpha: 0.06),
                                        blurRadius: 6,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () =>
                                            _viewProfile(context, friendId),
                                        child: CircleAvatar(
                                          radius: 26.rsr(context),
                                          backgroundColor:
                                              AppColors.secondBackground,
                                          backgroundImage:
                                              friendAvatar.isNotEmpty
                                              ? NetworkImage(friendAvatar)
                                              : null,
                                          child: friendAvatar.isEmpty
                                              ? Text(
                                                  friendName.isNotEmpty
                                                      ? friendName[0]
                                                      : '?',
                                                  style: TextStyle(
                                                    color:
                                                        AppColors.textPrimary,
                                                    fontSize: 18.rsp(context),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                )
                                              : null,
                                        ),
                                      ),
                                      SizedBox(width: 12.rs(context)),
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
                                                style: TextStyle(
                                                  fontSize: 14.rsp(context),
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.textPrimary,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 4.rsh(context)),
                                              Text(
                                                '@$friendUsername',
                                                style: TextStyle(
                                                  fontSize: 12.rsp(context),
                                                  color:
                                                      AppColors.textSecondary,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10.rs(context)),
                                      ElevatedButton(
                                        onPressed: isInvited
                                            ? null
                                            : () => _inviteFriend(friendId),
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 14.rs(context),
                                            vertical: 8.rsh(context),
                                          ),
                                          backgroundColor: isInvited
                                              ? AppColors.secondBackground
                                              : AppColors.primary,
                                          disabledBackgroundColor:
                                              AppColors.secondBackground,
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
                                              size: 14.rsp(context),
                                              color: isInvited
                                                  ? AppColors.textSecondary
                                                  : Colors.white,
                                            ),
                                            SizedBox(width: 4.rs(context)),
                                            Text(
                                              isInvited
                                                  ? context
                                                        .l10n
                                                        .communityInvited
                                                  : context
                                                        .l10n
                                                        .communityInviteAction,
                                              style: TextStyle(
                                                fontSize: 12.rsp(context),
                                                fontWeight: FontWeight.w600,
                                                color: isInvited
                                                    ? AppColors.textSecondary
                                                    : Colors.white,
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
