import 'package:flutter/material.dart';
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

  Future<List<PostEntity>> _emptyPosts() async => const <PostEntity>[];

  @override
  void initState() {
    super.initState();
    _postsFuture = widget.canViewPosts ? _loadPosts() : _emptyPosts();
    _setupCommentCountListener();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _setupCommentCountListener() {
    _commentRepository.commentCountStream.listen((counts) {
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
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
            ),
          )
        else
          FutureBuilder<List<PostEntity>>(
            future: _postsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 22),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
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
                  ),
                );
              }

              final posts = snapshot.data ?? const [];
              if (posts.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Text('Chưa có bài viết nào trong nhóm'),
                  ),
                );
              }

              return Column(
                children: posts
                    .map(
                      (post) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: PostItem(
                          post: post,
                          commentCount: _commentCounts[post.id] ?? 0,
                          isInCommunityDetail: true, // Dùng header đơn giản
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
      ],
    );
  }
}
