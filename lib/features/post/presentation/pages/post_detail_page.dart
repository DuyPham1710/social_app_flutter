import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/post/domain/entities/post_entity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_action.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_header.dart';
import 'package:social_app_fe/shared/helpers/full_screen_image_viewer.dart';

class PostDetailPage extends StatefulWidget {
  final PostEntity post;
  final int initialImageIndex;
  const PostDetailPage({
    super.key,
    required this.post,
    this.initialImageIndex = 0,
  });

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late ItemScrollController _scrollController = ItemScrollController();

  void _handlleImageChanged(int newIndex) {
    _scrollController.scrollTo(
      index: newIndex + 1, // vì index 0 là header
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  void _showFullScreenImage(BuildContext context, int initialIndex) async {
    final mediaUrls = widget.post.urls.map((url) => url.url).toList();

    await Navigator.of(context).push<int>(
      PageRouteBuilder(
        opaque: true,
        pageBuilder: (_, animation, __) {
          return Material(
            type: MaterialType.transparency,
            child: FullScreenImageViewer(
              imageUrls: mediaUrls,
              initialIndex: initialIndex,
              onImageChanged: _handlleImageChanged,
            ),
          );
        },
        transitionsBuilder: (_, animation, __, child) {
          return ScaleTransition(
            scale: Tween<double>(begin: 0.98, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut),
            ),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final mediaUrls = post.urls;
    print('Initial Image Index: ${widget.initialImageIndex}');
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: AppColors.background,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: ScrollablePositionedList.builder(
          itemScrollController: _scrollController,
          initialScrollIndex: widget.initialImageIndex > 0
              ? widget.initialImageIndex + 1
              : 0,
          itemCount: mediaUrls.length + 1, // +1 cho header item
          itemBuilder: (context, index) {
            // Index 0 là header
            if (index == 0) {
              return Column(
                children: [
                  // AppBar
                  Container(
                    color: AppColors.background,
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top,
                      left: 8.w,
                      right: 8.w,
                      bottom: 12.h,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            CupertinoIcons.back,
                            color: AppColors.iconPrimary,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Text(
                            post.user.fullName ?? 'Unknown',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(width: 48.w),
                      ],
                    ),
                  ),

                  // Content header
                  PostHeader(user: post.user, createdAt: post.createdAt),

                  SizedBox(height: 10.h),

                  // Caption
                  if (post.caption.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          post.caption,
                          style: TextStyle(fontSize: 14.sp, height: 1.4),
                        ),
                      ),
                    ),

                  // Reaction Buttons
                  SizedBox(height: 20.h),
                  PostAction(),
                ],
              );
            }

            // Index 1+ là các ảnh
            final imageIndex = index - 1;

            return Column(
              children: [
                Divider(),

                Padding(
                  padding: EdgeInsets.only(bottom: 6.h),
                  child: GestureDetector(
                    onTap: () {
                      // mở ảnh toàn màn hình khi nhấn
                      _showFullScreenImage(context, imageIndex);
                    },
                    child: Image.network(
                      mediaUrls[imageIndex].url,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      mediaUrls[imageIndex].title ?? '',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 14.h),
              ],
            );
          },
        ),
      ),
    );
  }
}
