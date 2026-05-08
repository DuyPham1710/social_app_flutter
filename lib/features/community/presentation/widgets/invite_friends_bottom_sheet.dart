import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/features/community/presentation/bloc/invite_friends_bloc.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';

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
      showErrorSnackBar(context, 'Lỗi: Không thể xác định bạn bè');
      return;
    }

    setState(() {
      _invitedFriendIds.add(userId);
    });

    _bloc.add(
      InviteFriendEvent(communityId: widget.communityId, userId: userId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InviteFriendsBloc>.value(
      value: _bloc,
      child: BlocListener<InviteFriendsBloc, InviteFriendsState>(
        listener: (context, state) {
          if (state is InviteFriendsSuccess) {
            showSuccessSnackBar(context, state.message);
          } else if (state is InviteFriendsError) {
            showErrorSnackBar(context, state.message);
          }
        },
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.95,
          minChildSize: 0.4,
          builder: (context, scrollController) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mời bạn bè tham gia',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value.toLowerCase();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Tìm bạn bè...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<InviteFriendsBloc, InviteFriendsState>(
                  builder: (context, state) {
                    if (state is InviteFriendsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is InviteFriendsError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red[300],
                            ),
                            const SizedBox(height: 12),
                            Text(state.message),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                _bloc.add(
                                  GetAvailableFriendsEvent(
                                    communityId: widget.communityId,
                                  ),
                                );
                              },
                              child: const Text('Thử lại'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is InviteFriendsInviting) {
                      return const Center(child: CircularProgressIndicator());
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
                            Icon(
                              Icons.people_outline,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Không có bạn bè khả dụng',
                              style: TextStyle(color: Colors.grey[600]),
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
                        child: Text(
                          'Không tìm thấy bạn bè "$_searchQuery"',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: scrollController,
                      itemCount: filteredFriends.length,
                      itemBuilder: (context, index) {
                        final friend = filteredFriends[index];
                        final friendId = _extractFriendId(friend);
                        final friendName = _getStringValue(
                          _getValue(friend, 'fullName', 'Unknown'),
                          'Unknown',
                        );
                        final friendUsername = _getStringValue(
                          _getValue(friend, 'username', ''),
                        );
                        final friendAvatar = _getStringValue(
                          _getValue(friend, 'avatarUrl') ??
                              _getValue(friend, 'avatar', ''),
                          '',
                        );
                        final isInvited = _invitedFriendIds.contains(friendId);

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundImage: friendAvatar.isNotEmpty
                                          ? NetworkImage(friendAvatar)
                                          : null,
                                      child: friendAvatar.isEmpty
                                          ? Text(
                                              friendName.isNotEmpty
                                                  ? friendName[0]
                                                  : '?',
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            friendName,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '@$friendUsername',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF65676B),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: isInvited
                                          ? null
                                          : () => _inviteFriend(friendId),
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        backgroundColor: isInvited
                                            ? Colors.grey[300]
                                            : null,
                                        foregroundColor: isInvited
                                            ? Colors.grey[600]
                                            : null,
                                      ),
                                      child: Text(isInvited ? 'Đã mời' : 'Mời'),
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
    );
  }
}
