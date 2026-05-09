import 'dart:async';

import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/post/domain/entities/post_list_entity.dart';
import 'package:social_app_fe/features/post/domain/entities/post_entity.dart';
import 'package:social_app_fe/features/post/domain/usecases/get_community_posts_usecase.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/post_item.dart';
import 'package:social_app_fe/features/comment/domain/repository/comment_repository.dart';

class CommunityPostsWidget extends StatefulWidget {
  final String communityId;
  final bool canViewPosts;
  final int refreshSeed;
  final String? userRole; // 'admin', 'member', null

  const CommunityPostsWidget({
    super.key,
    required this.communityId,
    this.canViewPosts = true,
    this.refreshSeed = 0,
    this.userRole,
  });

  @override
  State<CommunityPostsWidget> createState() => _CommunityPostsWidgetState();
}

class _CommunityPostsWidgetState extends State<CommunityPostsWidget> {
  late Future<List<PostEntity>> _postsFuture;
  final GetCommunityPostsUseCase _getCommunityPostsUseCase =
      s1<GetCommunityPostsUseCase>();
  final CommentRepository _commentRepository = s1<CommentRepository>();
  final Map<String, int> _commentCounts = {};
  StreamSubscription<Map<String, int>>? _commentCountSubscription;

  Future<List<PostEntity>> _emptyPosts() async => const <PostEntity>[];

  @override
  void initState() {
    super.initState();
    _postsFuture = widget.canViewPosts ? _loadPosts() : _emptyPosts();
    _setupCommentCountListener();
  }

  @override
  void dispose() {
    _commentCountSubscription?.cancel();
    super.dispose();
  }

  void _setupCommentCountListener() {
    _commentCountSubscription = _commentRepository.commentCountStream.listen((
      counts,
    ) {
      if (mounted) {
        setState(() {
          _commentCounts.addAll(counts);
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant CommunityPostsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final cannotViewNow = !widget.canViewPosts;
    if (cannotViewNow) {
      _postsFuture = _emptyPosts();
      return;
    }

    if (oldWidget.refreshSeed != widget.refreshSeed ||
        oldWidget.communityId != widget.communityId ||
        oldWidget.canViewPosts != widget.canViewPosts) {
      _postsFuture = _loadPosts();
    }
  }

  Future<List<PostEntity>> _loadPosts() async {
    final dataState = await _getCommunityPostsUseCase(
      params: GetCommunityPostsParams(
        communityId: widget.communityId,
        page: 1,
        limit: 20,
      ),
    );

    if (dataState is DataStateSuccess<PostListEntity>) {
      final posts = dataState.data?.data ?? const [];
      // Join post rooms để lắng nghe comment count updates
      for (final post in posts) {
        _commentRepository.joinPost(post.id);
        _commentRepository.loadComments(post.id);
      }
      return posts;
    }

    if (dataState is DataStateError) {
      throw dataState.error ?? Exception('Failed to load community posts');
    }

    return const [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            'Bài viết trong nhóm',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1C1E21),
            ),
          ),
        ),
        if (!widget.canViewPosts)
          _fadeContent(
            key: 'locked',
            child: _buildInfoCard(
              icon: Icons.lock_outline_rounded,
              iconColor: const Color(0xFF64748B),
              backgroundColor: const Color(0xFFF8FAFC),
              borderColor: const Color(0xFFE2E8F0),
              title: 'Nội dung dành cho thành viên',
              message: 'Bạn cần là thành viên để xem bài viết trong nhóm.',
            ),
          )
        else
          FutureBuilder<List<PostEntity>>(
            future: _postsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _fadeContent(
                  key: 'loading',
                  child: _buildPostsLoadingState(),
                );
              }

              if (snapshot.hasError) {
                return _fadeContent(
                  key: 'error',
                  child: _buildErrorState(),
                );
              }

              final posts = snapshot.data ?? const [];
              if (posts.isEmpty) {
                return _fadeContent(
                  key: 'empty',
                  child: _buildInfoCard(
                    icon: Icons.post_add_rounded,
                    iconColor: AppColors.primary,
                    backgroundColor: const Color(0xFFF8FAFC),
                    borderColor: const Color(0xFFE2E8F0),
                    title: 'Chưa có bài viết',
                    message: 'Các bài viết trong nhóm sẽ hiển thị tại đây.',
                  ),
                );
              }

              return _fadeContent(
                key: 'loaded-${posts.length}-${widget.refreshSeed}',
                child: Column(
                  children: posts.asMap().entries.map((entry) {
                    final index = entry.key;
                    final post = entry.value;
                    return _AnimatedPostItem(
                      index: index,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: PostItem(
                          post: post,
                          commentCount: _commentCounts[post.id] ?? 0,
                          isInCommunityDetail: true,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _fadeContent({required String key, required Widget child}) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 260),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: KeyedSubtree(
        key: ValueKey(key),
        child: child,
      ),
    );
  }

  Widget _buildPostsLoadingState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: List.generate(
          3,
          (index) => _AnimatedPostItem(
            index: index,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE4E7EC)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0F0F172A),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      _SkeletonBox(width: 42, height: 42, radius: 21),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SkeletonBox(width: 150, height: 14, radius: 7),
                            SizedBox(height: 8),
                            _SkeletonBox(width: 90, height: 12, radius: 6),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const _SkeletonBox(
                    width: double.infinity,
                    height: 13,
                    radius: 7,
                  ),
                  const SizedBox(height: 8),
                  const _SkeletonBox(width: 230, height: 13, radius: 7),
                  if (index == 0) ...[
                    const SizedBox(height: 12),
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9EEF5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF1F2),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFFECACA)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  color: Color(0xFFE11D48),
                  size: 22,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Không tải được bài viết',
                    style: TextStyle(
                      color: Color(0xFF101828),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _postsFuture = _loadPosts();
                });
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required Color borderColor,
    required String title,
    required String message,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.74),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF101828),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    message,
                    style: const TextStyle(
                      color: Color(0xFF667085),
                      fontSize: 13,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedPostItem extends StatelessWidget {
  final int index;
  final Widget child;

  const _AnimatedPostItem({required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    final delayMs = (index * 35).clamp(0, 240);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 220 + delayMs),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 14),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE9EEF5),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
