import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/core/utils/react_post_util.dart';
import 'package:social_app_fe/features/comment/presentation/pages/modal_comment.dart';
import 'package:social_app_fe/features/post/domain/entities/post_entity.dart';
import 'package:social_app_fe/features/post/domain/entities/react_post_entity.dart';
import 'package:social_app_fe/features/post/presentation/pages/post_detail_page.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/post_action.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/post_header.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/post_react_info.dart';
import 'package:social_app_fe/shared/component/layout/layout_post_classic.dart';
import 'package:social_app_fe/shared/component/layout/layout_post_column.dart';
import 'package:social_app_fe/shared/component/layout/layout_post_frame.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/post_options_bottom_sheet.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/report_post_bottom_sheet.dart';

class PostItem extends StatefulWidget {
  final PostEntity post;
  final int commentCount;

  const PostItem({super.key, required this.post, this.commentCount = 0});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  late List<ReactPostEntity> _localReacts;
  EmojiType? _currentUserReaction;

  @override
  void initState() {
    super.initState();
    _localReacts = List.from(widget.post.reacts ?? []);
    _currentUserReaction = null;
    _initCurrentUserReaction();
  }

  @override
  void didUpdateWidget(PostItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.post != widget.post) {
      setState(() {
        _localReacts = List.from(widget.post.reacts ?? []);
      });
      _initCurrentUserReaction();
    }
  }

  Future<void> _initCurrentUserReaction() async {
    final userData = await TokenStorage.getUserData();
    final currentUserId = userData?['id'];

    // Tìm reaction của user hiện tại từ reacts array
    ReactPostEntity? userReaction;
    for (final react in _localReacts) {
      if (react.user.userId == currentUserId) {
        userReaction = react;
        break;
      }
    }

    if (mounted) {
      setState(() {
        _currentUserReaction = userReaction?.emoji;
      });
    }
  }

  void _onReactionChanged(EmojiType? newReaction) async {
    final userData = await TokenStorage.getUserData();
    final currentUserId = userData?['id'];
    setState(() {
      _currentUserReaction = newReaction;

      _localReacts = updateLocalReacts(
        currentReacts: _localReacts,
        currentUserId: currentUserId,
        newReaction: newReaction,
        post: widget.post,
        userData: userData,
      );
    });
  }

  Widget _buildMediaLayout(BuildContext context, List<dynamic> urls) {
    late final Widget layout;

    void onImageTap(int initialIndex) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => PostDetailPage(
            post: widget.post,
            initialImageIndex: initialIndex,
          ),
        ),
      );
    }

    switch (widget.post.layout.toLowerCase()) {
      case 'classic':
        layout = LayoutPostClassic(urls: urls, onImageTap: onImageTap);
      case 'column':
        layout = LayoutPostColumn(urls: urls, onImageTap: onImageTap);
      case 'frame':
        layout = LayoutPostFrame(urls: urls, onImageTap: onImageTap);
      default:
        layout = LayoutPostClassic(urls: urls, onImageTap: onImageTap);
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (_) => PostDetailPage(post: widget.post)),
        );
      },
      child: layout,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.post.user;
    final urls = widget.post.urls;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8.r),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          PostHeader(
            user: user,
            createdAt: widget.post.createdAt,
            onOptionsTap: () {
              PostOptionsBottomSheet.show(
                context,
                post: widget.post,
              );
            },
            onReportTap: () {
              ReportPostBottomSheet.show(
                context,
                postId: widget.post.id,
                ownerUserId: user.userId,
              );
            },
          ),

          // Caption
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(widget.post.caption, style: TextStyle(fontSize: 13.sp)),
          ),

          SizedBox(height: 8.h),

          // Media (images)
          if (urls.isNotEmpty)
            _buildMediaLayout(context, urls)
          else
            SizedBox.shrink(),

          SizedBox(height: 8.h),

          // Likes info
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return ModalComment(
                    postId: widget.post.id,
                    reacts: _localReacts,
                  );
                },
              );
            },
            child: PostReactInfo(reacts: _localReacts),
          ),

          SizedBox(height: 20.h),

          PostAction(
            postId: widget.post.id,
            reactCount: _localReacts.length,
            isReact: _currentUserReaction,
            reacts: _localReacts,
            commentCount: widget.commentCount,
            onReactionChanged: _onReactionChanged,
          ),
        ],
      ),
    );
  }
}
