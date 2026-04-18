import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/features/community/presentation/bloc/community_admin_bloc.dart';

class CommunityAdminPanel extends StatefulWidget {
  final String communityId;

  const CommunityAdminPanel({super.key, required this.communityId});

  @override
  State<CommunityAdminPanel> createState() => _CommunityAdminPanelState();
}

class _CommunityAdminPanelState extends State<CommunityAdminPanel> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF8FF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFBFDBFE)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.shield_rounded, color: Color(0xFF1D4ED8)),
                SizedBox(width: 8),
                Text(
                  'Bảng quản trị',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Duyệt thành viên mới và kiểm duyệt bài viết trước khi hiển thị.',
              style: TextStyle(color: Color(0xFF334155)),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      context.read<CommunityAdminBloc>().add(
                        GetPendingRequestsRequested(widget.communityId),
                      );
                      _showPendingRequests(context);
                    },
                    icon: const Icon(Icons.how_to_reg_rounded),
                    label: const Text('Duyệt thành viên'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      context.read<CommunityAdminBloc>().add(
                        GetPendingPostsRequested(
                          communityId: widget.communityId,
                          page: 1,
                          limit: 10,
                        ),
                      );
                      _showPendingPosts(context);
                    },
                    icon: const Icon(Icons.fact_check_rounded),
                    label: const Text('Duyệt bài viết'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showPendingRequests(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => BlocProvider.value(
        value: context.read<CommunityAdminBloc>(),
        child: BlocBuilder<CommunityAdminBloc, CommunityAdminState>(
          builder: (context, state) {
            if (state is PendingRequestsLoaded) {
              if (state.requests.isEmpty) {
                return const SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('Không có yêu cầu tham gia đang chờ duyệt'),
                  ),
                );
              }

              return SafeArea(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                  itemCount: state.requests.length,
                  itemBuilder: (context, index) {
                    final request = state.requests[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: request.user.avatarUrl != null
                              ? NetworkImage(request.user.avatarUrl!)
                              : null,
                          child: request.user.avatarUrl == null
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        title: Text(request.user.fullName ?? 'Unknown'),
                        subtitle: const Text('Yêu cầu tham gia cộng đồng'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                context.read<CommunityAdminBloc>().add(
                                  RespondToJoinRequestRequested(
                                    communityId: widget.communityId,
                                    requestId: request.id,
                                    action: 'approve',
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () {
                                context.read<CommunityAdminBloc>().add(
                                  RespondToJoinRequestRequested(
                                    communityId: widget.communityId,
                                    requestId: request.id,
                                    action: 'reject',
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  void _showPendingPosts(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => BlocProvider.value(
        value: context.read<CommunityAdminBloc>(),
        child: BlocBuilder<CommunityAdminBloc, CommunityAdminState>(
          builder: (context, state) {
            if (state is PendingPostsLoaded) {
              if (state.posts.isEmpty) {
                return const SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('Không có bài viết nào đang chờ duyệt'),
                  ),
                );
              }

              return SafeArea(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                  itemCount: state.posts.length,
                  itemBuilder: (context, index) {
                    final post = state.posts[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        title: Text(post.caption ?? 'Bài viết'),
                        subtitle: Text(post.user.fullName ?? 'Unknown'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                context.read<CommunityAdminBloc>().add(
                                  ApproveCommunityPostRequested(
                                    communityId: widget.communityId,
                                    postId: post.id,
                                    action: 'approve',
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () {
                                context.read<CommunityAdminBloc>().add(
                                  ApproveCommunityPostRequested(
                                    communityId: widget.communityId,
                                    postId: post.id,
                                    action: 'reject',
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
