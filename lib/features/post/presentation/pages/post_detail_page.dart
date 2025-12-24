import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/core/utils/react_post_util.dart';
import 'package:social_app_fe/core/utils/video_util.dart';
import 'package:social_app_fe/features/comment/presentation/bloc/comment_bloc.dart';
import 'package:social_app_fe/features/comment/presentation/bloc/comment_event.dart';
import 'package:social_app_fe/features/comment/presentation/pages/modal_comment.dart';
import 'package:social_app_fe/features/home/presentation/bloc/home_bloc.dart';
import 'package:social_app_fe/features/post/domain/entities/post_entity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/features/post/domain/entities/react_post_entity.dart';
import 'package:social_app_fe/features/post/presentation/bloc/post_detail_bloc.dart';
import 'package:social_app_fe/features/post/presentation/bloc/post_detail_event.dart';
import 'package:social_app_fe/features/post/presentation/bloc/post_detail_state.dart';
import 'package:social_app_fe/features/post/presentation/pages/video_player_screen.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/post_action.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/post_header.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/post_react_info.dart';
import 'package:social_app_fe/shared/helpers/full_screen_image_viewer.dart';
import 'package:social_app_fe/shared/helpers/video_thumbnail.dart';

class PostDetailPage extends StatefulWidget {
  final PostEntity post;
  final int initialImageIndex;
  final String? initialCommentId;
  const PostDetailPage({
    super.key,
    required this.post,
    this.initialImageIndex = 0,
    this.initialCommentId,
  });

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late ItemScrollController _scrollController = ItemScrollController();
  late CommentBloc _commentBloc;
  late PostDetailBloc _postDetailBloc;
  late List<ReactPostEntity> _localReacts;
  EmojiType? _currentUserReaction;

  @override
  void initState() {
    super.initState();
    _localReacts = List.from(widget.post.reacts ?? []);
    _currentUserReaction = null;
    _initCurrentUserReaction();

    // Khởi tạo các Blocs
    _commentBloc = s1<CommentBloc>();
    _postDetailBloc = s1<PostDetailBloc>();

    // Initialize post detail để join post và lắng nghe comment count
    _postDetailBloc.add(InitializePostDetailEvent(widget.post.id));

    // If initialCommentId is provided, scroll to comments and open modal
    if (widget.initialCommentId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToCommentAndOpen(widget.initialCommentId!);
      });
    }
  }

  @override
  void didUpdateWidget(PostDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.post != widget.post) {
      _localReacts = List.from(widget.post.reacts ?? []);
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

  void _scrollToCommentAndOpen(String commentId) {
    print(
      '[PostDetail] _scrollToCommentAndOpen called with commentId: $commentId',
    );
    // Delay to ensure UI is fully built
    Future.delayed(const Duration(milliseconds: 800), () {
      print('[PostDetail] Opening modal after 800ms delay');
      if (mounted) {
        // Auto-open comment modal
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            print(
              '[PostDetail] ModalComment builder called with initialCommentId: $commentId',
            );
            return ModalComment(
              postId: widget.post.id,
              reacts: _localReacts,
              initialCommentId: commentId,
            );
          },
        );
      }
    });
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

  @override
  void dispose() {
    // Cleanup các Blocs
    _commentBloc.add(LeavePostEvent(widget.post.id));
    _commentBloc.close();
    _postDetailBloc.close();
    super.dispose();
  }

  void _showVideoPlayer(String videoUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(videoData: videoUrl),
      ),
    );
  }

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

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _commentBloc),
        BlocProvider.value(value: _postDetailBloc),
      ],
      child: AnnotatedRegion<SystemUiOverlayStyle>(
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
                    PostHeader(
                      user: post.user,
                      createdAt: post.createdAt,
                      onReportTap: () {
                        // TODO: Có thể tái sử dụng bottom sheet báo cáo giống PostItem nếu muốn
                      },
                    ),

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

                    SizedBox(height: 20.h),

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

                    // Reaction Buttons
                    SizedBox(height: 20.h),
                    BlocBuilder<PostDetailBloc, PostDetailState>(
                      builder: (context, state) {
                        final commentCount = state is PostDetailLoaded
                            ? state.commentCount
                            : 0;
                        return PostAction(
                          postId: post.id,
                          reactCount: _localReacts
                              .length, // ← Sử dụng _localReacts thay vì post.reacts
                          isReact: _currentUserReaction,
                          reacts: _localReacts,
                          commentCount: commentCount,
                          onReactionChanged: _onReactionChanged,
                        );
                      },
                    ),
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
                        if (VideoUtil.isVideo(mediaUrls[imageIndex].url)) {
                          _showVideoPlayer(mediaUrls[imageIndex].url);
                        } else {
                          _showFullScreenImage(context, imageIndex);
                        }
                      },
                      child: VideoUtil.isVideo(mediaUrls[imageIndex].url)
                          ? buildVideoThumbnail()
                          : Image.network(
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
      ),
    );
  }
}
