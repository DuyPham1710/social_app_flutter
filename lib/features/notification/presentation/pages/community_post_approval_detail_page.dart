import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import 'package:social_app_fe/features/community/data/models/community_post_model.dart';
import 'package:social_app_fe/features/community/data/models/community_ref_model.dart';
import 'package:social_app_fe/features/community/domain/entities/community_entity.dart';
import 'package:social_app_fe/features/community/presentation/bloc/community_admin_bloc.dart';
import 'package:social_app_fe/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:social_app_fe/features/notification/presentation/bloc/notification_event.dart';
import 'package:social_app_fe/features/notification/presentation/widgets/post_loading_page.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/community_post_header.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/pages/other_profile_page.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';
import 'package:social_app_fe/shared/helpers/video_thumbnail.dart';
import 'package:social_app_fe/core/utils/video_util.dart';

class CommunityPostApprovalDetailPage extends StatelessWidget {
  final String notificationId;
  final String communityId;
  final String postId;
  final String senderName;
  final String senderAvatar;
  final String communityName;
  final DateTime? createdAt;

  const CommunityPostApprovalDetailPage({
    super.key,
    required this.notificationId,
    required this.communityId,
    required this.postId,
    required this.senderName,
    required this.senderAvatar,
    required this.communityName,
    this.createdAt,
  });

  CommunityPostModel? _findPost(List<CommunityPostModel> posts) {
    for (final post in posts) {
      if (post.id == postId) {
        return post;
      }
    }
    return null;
  }

  CommunityEntity _toCommunityEntity(CommunityPostModel post) {
    final CommunityRefModel community = post.community;
    final avatar = community.avatar ?? senderAvatar;
    return CommunityEntity(
      id: community.id,
      name: community.name,
      description: '',
      avatar: avatar,
      coverImage: avatar,
      privacy: 'public',
      memberCount: 0,
      admin: post.user,
      createdAt: post.createdAt,
      updatedAt: post.updatedAt,
    );
  }

  Future<void> _openUserProfile(BuildContext context, UserModel user) async {
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

  void _handleAction(BuildContext context, String action) {
    context.read<CommunityAdminBloc>().add(
      ApproveCommunityPostRequested(
        communityId: communityId,
        postId: postId,
        action: action,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => s1<CommunityAdminBloc>()
        ..add(
          GetPendingPostsRequested(
            communityId: communityId,
            page: 1,
            limit: 100,
          ),
        ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            'Duyệt bài viết',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          backgroundColor: AppColors.background,
          surfaceTintColor: Colors.transparent,
        ),
        body: BlocConsumer<CommunityAdminBloc, CommunityAdminState>(
          listener: (context, state) {
            if (state is CommunityAdminActionSuccess) {
              try {
                context.read<NotificationBloc>().add(
                  RemoveNotification(notificationId),
                );
              } catch (_) {}

              showSuccessSnackBar(context, state.message);
              Navigator.of(context).pop(true);
            } else if (state is CommunityAdminError) {
              showErrorSnackBar(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is CommunityAdminLoading ||
                state is CommunityAdminInitial) {
              return const PostLoadingPage();
            }

            if (state is CommunityAdminError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 48,
                        color: AppColors.iconPrimary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<CommunityAdminBloc>().add(
                            GetPendingPostsRequested(
                              communityId: communityId,
                              page: 1,
                              limit: 100,
                            ),
                          );
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Thử lại'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is! PendingPostsLoaded) {
              return const SizedBox.shrink();
            }

            final post = _findPost(state.posts);
            if (post == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.article_outlined,
                        size: 48,
                        color: AppColors.iconPrimary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Không tìm thấy bài viết đang chờ duyệt',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<CommunityAdminBloc>().add(
                            GetPendingPostsRequested(
                              communityId: communityId,
                              page: 1,
                              limit: 100,
                            ),
                          );
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Tải lại'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final community = _toCommunityEntity(post);
            final mediaUrls = post.urls;

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommunityPostHeader(
                          community: community,
                          user: post.user,
                          createdAt: post.createdAt,
                          showCommunityInfo: true,
                          onOptionsTap: null,
                          onReportTap: null,
                        ),
                        if (post.caption != null && post.caption!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                            child: Text(
                              post.caption!,
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.4,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),

                        if (mediaUrls.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              children: mediaUrls
                                  .map(
                                    (media) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(14),
                                        child: VideoUtil.isVideo(media.url)
                                            ? buildVideoThumbnail(media.url)
                                            : Image.network(
                                                media.url,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                              ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _handleAction(context, 'reject'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                            ),
                            child: const Text('Từ chối'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: () => _handleAction(context, 'approve'),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Duyệt bài'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
