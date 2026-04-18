import 'package:flutter/material.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import 'package:social_app_fe/features/community/data/models/community_post_model.dart';
import 'package:social_app_fe/features/community/domain/repository/community_repository.dart';
import 'package:social_app_fe/features/post/domain/entities/post_entity.dart';
import 'package:social_app_fe/features/post/domain/entities/post_url_entity.dart';
import 'package:social_app_fe/features/post/domain/entities/react_post_entity.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/post_item.dart';

class CommunityPostsWidget extends StatefulWidget {
  final String communityId;
  final bool canCreatePost;
  final VoidCallback? onCreatePost;
  final bool canViewPosts;
  final int refreshSeed;

  const CommunityPostsWidget({
    super.key,
    required this.communityId,
    this.canCreatePost = false,
    this.onCreatePost,
    this.canViewPosts = true,
    this.refreshSeed = 0,
  });

  @override
  State<CommunityPostsWidget> createState() => _CommunityPostsWidgetState();
}

class _CommunityPostsWidgetState extends State<CommunityPostsWidget> {
  late Future<List<CommunityPostModel>> _postsFuture;
  final CommunityRepository _communityRepository = s1<CommunityRepository>();

  @override
  void initState() {
    super.initState();
    _postsFuture = _loadPosts();
  }

  @override
  void didUpdateWidget(covariant CommunityPostsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refreshSeed != widget.refreshSeed ||
        oldWidget.communityId != widget.communityId) {
      _postsFuture = _loadPosts();
    }
  }

  Future<List<CommunityPostModel>> _loadPosts() async {
    final dataState = await _communityRepository.getCommunityPosts(
      communityId: widget.communityId,
      page: 1,
      limit: 20,
    );

    if (dataState is DataStateSuccess<List<CommunityPostModel>>) {
      return dataState.data ?? const [];
    }

    if (dataState is DataStateError) {
      throw dataState.error ?? Exception('Failed to load community posts');
    }

    return const [];
  }

  PostEntity _mapToPostEntity(CommunityPostModel post) {
    return PostEntity(
      id: post.id,
      caption: post.caption,
      user: post.user.toEntity(),
      urls: post.urls
          .map(
            (url) => PostUrlEntity(
              id: url.id,
              url: url.url,
              title: url.title,
              order: url.order,
              createdAt: url.createdAt,
              updatedAt: url.updatedAt,
            ),
          )
          .toList(),
      layout: post.layout,
      reacts: post.reacts
          .map(
            (react) => ReactPostEntity(
              id: react.id,
              user: react.user.toEntity(),
              postId: react.postId,
              emoji: react.emoji,
              createdAt: react.createdAt,
              updatedAt: react.updatedAt,
              mutualFriendsCount: react.mutualFriendsCount,
              isFriend: react.isFriend,
            ),
          )
          .toList(),
      isReact: post.isReact,
      privacyType: post.privacyType,
      friendsExcept: const [],
      friendsDetail: const [],
      createdAt: post.createdAt,
      updatedAt: post.updatedAt,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE4E7EC)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x120F172A),
              blurRadius: 14,
              offset: Offset(0, 7),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Bài viết trong nhóm',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
                if (widget.canCreatePost && widget.onCreatePost != null)
                  FilledButton.tonalIcon(
                    onPressed: widget.onCreatePost,
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Đăng bài'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (!widget.canViewPosts)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Text(
                  'Bạn cần là thành viên để xem bài viết trong nhóm.',
                ),
              )
            else
              FutureBuilder<List<CommunityPostModel>>(
                future: _postsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 22),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (snapshot.hasError) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1F2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFECACA)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Không tải được bài viết: ${snapshot.error}'),
                          const SizedBox(height: 10),
                          OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                _postsFuture = _loadPosts();
                              });
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Thử lại'),
                          ),
                        ],
                      ),
                    );
                  }

                  final posts = snapshot.data ?? const [];
                  if (posts.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: const Text('Chưa có bài viết nào trong nhóm'),
                    );
                  }

                  return Column(
                    children: posts
                        .map((post) => PostItem(post: _mapToPostEntity(post)))
                        .toList(),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
