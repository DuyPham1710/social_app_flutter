import 'dart:async';

import 'package:flutter/material.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/post/domain/entities/post_list_entity.dart';
import 'package:social_app_fe/features/post/domain/entities/post_entity.dart';
import 'package:social_app_fe/features/post/domain/usecases/get_community_posts_usecase.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/post_item.dart';
import 'package:social_app_fe/features/comment/domain/repository/comment_repository.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class CommunityPostsWidget extends StatefulWidget {
  final String communityId;
  final bool canViewPosts;
  final int refreshSeed;
  final String? userRole; // 'admin', 'member', null

  CommunityPostsWidget({
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
      final posts = dataState.data?.data ?? [];
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

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            16.rs(context),
            0,
            16.rs(context),
            8.rsh(context),
          ),
          child: Text(
            context.l10n.communityPostsInGroup,
            style: TextStyle(
              fontSize: 16.rsp(context),
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        if (!widget.canViewPosts)
          _fadeContent(
            key: 'locked',
            child: _buildInfoCard(
              icon: Icons.lock_outline_rounded,
              iconColor: AppColors.textSecondary,
              backgroundColor: AppColors.background,
              borderColor: AppColors.divider,
              title: context.l10n.communityMemberOnlyContent,
              message: context.l10n.communityMemberOnlyPostsMessage,
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
                return _fadeContent(key: 'error', child: _buildErrorState());
              }

              final posts = snapshot.data ?? [];
              if (posts.isEmpty) {
                return _fadeContent(
                  key: 'empty',
                  child: _buildInfoCard(
                    icon: Icons.post_add_rounded,
                    iconColor: AppColors.primary,
                    backgroundColor: AppColors.background,
                    borderColor: AppColors.divider,
                    title: context.l10n.communityNoPostsTitle,
                    message: context.l10n.communityNoPostsMessage,
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
                        padding: EdgeInsets.only(bottom: 10.rsh(context)),
                        child: PostItem(
                          post: post,
                          commentCount: _commentCounts[post.id] ?? 0,
                          isInCommunityDetail: true,
                          communityUserRole: widget.userRole,
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
      duration: Duration(milliseconds: 260),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: KeyedSubtree(key: ValueKey(key), child: child),
    );
  }

  Widget _buildPostsLoadingState() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.rs(context)),
      child: Column(
        children: List.generate(
          3,
          (index) => _AnimatedPostItem(
            index: index,
            child: Container(
              margin: EdgeInsets.only(bottom: 10.rsh(context)),
              padding: EdgeInsets.all(14.rs(context)),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(14.rsr(context)),
                border: Border.all(color: AppColors.divider),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.textSecondary.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _SkeletonBox(
                        width: 42.rs(context),
                        height: 42.rsh(context),
                        radius: 21.rsr(context),
                      ),
                      SizedBox(width: 10.rs(context)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SkeletonBox(
                              width: 150.rs(context),
                              height: 14.rsh(context),
                              radius: 7.rsr(context),
                            ),
                            SizedBox(height: 8.rsh(context)),
                            _SkeletonBox(
                              width: 90.rs(context),
                              height: 12.rsh(context),
                              radius: 6.rsr(context),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.rsh(context)),
                  _SkeletonBox(
                    width: double.infinity,
                    height: 13.rsh(context),
                    radius: 7.rsr(context),
                  ),
                  SizedBox(height: 8.rsh(context)),
                  _SkeletonBox(
                    width: 230.rs(context),
                    height: 13.rsh(context),
                    radius: 7.rsr(context),
                  ),
                  if (index == 0) ...[
                    SizedBox(height: 12.rsh(context)),
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.textSecondary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12.rsr(context)),
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
      padding: EdgeInsets.symmetric(horizontal: 12.rs(context)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.rs(context)),
        decoration: BoxDecoration(
          color: Color(0xFFE11D48).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14.rsr(context)),
          border: Border.all(color: Color(0xFFE11D48).withValues(alpha: 0.28)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  color: Color(0xFFE11D48),
                  size: 22.rsp(context),
                ),
                SizedBox(width: 8.rs(context)),
                Expanded(
                  child: Text(
                    context.l10n.homeLoadPostsFailed,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.rsh(context)),
            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _postsFuture = _loadPosts();
                });
              },
              icon: Icon(Icons.refresh_rounded),
              label: Text(context.l10n.commonRetry),
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
      padding: EdgeInsets.symmetric(horizontal: 12.rs(context)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.rs(context)),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14.rsr(context)),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              width: 42.rs(context),
              height: 42.rsh(context),
              decoration: BoxDecoration(
                color: AppColors.secondBackground.withValues(alpha: 0.74),
                borderRadius: BorderRadius.circular(12.rsr(context)),
              ),
              child: Icon(icon, color: iconColor, size: 22.rsp(context)),
            ),
            SizedBox(width: 12.rs(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 3.rsh(context)),
                  Text(
                    message,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13.rsp(context),
                      height: 1.25.rsh(context),
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

  _AnimatedPostItem({required this.index, required this.child});

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

  _SkeletonBox({
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
        color: AppColors.textSecondary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
