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
import 'package:social_app_fe/features/post/domain/entities/post_entity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/features/post/domain/entities/react_post_entity.dart';
import 'package:social_app_fe/features/post/presentation/bloc/post_detail_bloc.dart';
import 'package:social_app_fe/features/post/presentation/bloc/post_detail_event.dart';
import 'package:social_app_fe/features/post/presentation/bloc/post_detail_state.dart';
import 'package:social_app_fe/features/post/presentation/helpers/tag_action_helper.dart';
import 'package:social_app_fe/features/post/presentation/pages/video_player_screen.dart';
import 'package:social_app_fe/features/post/presentation/pages/tag_friends_page.dart';
import 'package:social_app_fe/features/post/domain/usecases/update_post_tags_usecase.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/post_action.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/post_options_bottom_sheet.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/report_post_bottom_sheet.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/save_post_bottom_sheet.dart';
import 'package:social_app_fe/features/save/domain/repository/save_repository.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/post_header.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/community_post_header.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/post_react_info.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/post_translatable_caption.dart';
import 'package:social_app_fe/shared/helpers/full_screen_image_viewer.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';
import 'package:social_app_fe/shared/helpers/video_thumbnail.dart';

class PostDetailPage extends StatefulWidget {
  final PostEntity post;
  final int initialImageIndex;
  final String? initialCommentId;
  final List<String>? initialAutoTagUserIds;

  const PostDetailPage({
    super.key,
    required this.post,
    this.initialImageIndex = 0,
    this.initialCommentId,
    this.initialAutoTagUserIds,
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
  String? _currentUserId;
  List<String> _visibleOnProfileUserIds = [];
  bool _isRemoved = false;
  bool _isSaved = false;
  String? _savedId;
  final SaveRepository _saveRepository = s1<SaveRepository>();

  @override
  void initState() {
    super.initState();
    _localReacts = List.from(widget.post.reacts ?? []);
    _currentUserReaction = null;
    _visibleOnProfileUserIds = List.from(
      widget.post.visibleOnProfileUserIds ?? [],
    );
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

    if (widget.initialAutoTagUserIds != null &&
        widget.initialAutoTagUserIds!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openAutoTagSuggest();
      });
    }

    _checkSavedStatus();
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
        _currentUserId = currentUserId;
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

  Future<void> _openAutoTagSuggest() async {
    final selectedFriends = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TagFriendsPage(
          initialSelectedFriends: widget.initialAutoTagUserIds!,
        ),
      ),
    );

    if (selectedFriends != null &&
        selectedFriends is List<Map<String, String>>) {
      final selectedIds = selectedFriends.map((f) => f['id']!).toList();
      final updatePostTags = s1<UpdatePostTagsUsecase>();
      final result = await updatePostTags(
        params: UpdatePostTagsParams(
          postId: widget.post.id,
          taggedUserIds: selectedIds,
        ),
      );

      if (mounted) {
        if (result is DataStateSuccess) {
          showSuccessSnackBar(context, 'Đã cập nhật thẻ thành công');

          setState(() {});
        } else {
          showErrorSnackBar(
            context,
            'Cập nhật thẻ thất bại: ${result.error?.message}',
          );
        }
      }
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

  Future<void> _handleTagVisibility(bool isVisible) async {
    await TagActionHelper.handleTagVisibility(
      context: context,
      postId: widget.post.id,
      isVisible: isVisible,
      onSuccess: () async {
        final userData = await TokenStorage.getUserData();
        final currentUserId = userData?['id'];
        if (currentUserId != null) {
          setState(() {
            if (isVisible) {
              if (!_visibleOnProfileUserIds.contains(currentUserId)) {
                _visibleOnProfileUserIds.add(currentUserId);
              }
            } else {
              _visibleOnProfileUserIds.remove(currentUserId);
            }
          });
        }
      },
    );
  }

  Future<void> _handleRemoveTag() async {
    await TagActionHelper.handleRemoveTag(
      context: context,
      postId: widget.post.id,
      onSuccess: () {
        setState(() {
          _isRemoved = true;
        });
      },
    );
  }

  Future<void> _checkSavedStatus() async {
    final result = await _saveRepository.checkSaved(
      targetId: widget.post.id,
      type: 'post',
    );
    if (result is DataStateSuccess && result.data == true) {
      if (mounted) {
        setState(() {
          _isSaved = true;
        });
        _fetchSavedId();
      }
    }
  }

  Future<void> _fetchSavedId() async {
    final listResult = await _saveRepository.getSavedByUser(
      type: 'post',
      limit: 50,
    );
    if (listResult is DataStateSuccess && listResult.data != null) {
      for (var item in listResult.data!.data) {
        if (item.targetId == widget.post.id) {
          if (mounted) {
            setState(() {
              _savedId = item.id;
            });
          }
          break;
        }
      }
    }
  }

  Future<void> _handleUnsave() async {
    if (_savedId == null) {
      await _fetchSavedId();
      if (_savedId == null) return;
    }

    final result = await _saveRepository.unsavePost(savedId: _savedId!);
    if (result is DataStateSuccess) {
      if (mounted) {
        setState(() {
          _isSaved = false;
          _savedId = null;
        });
        showSuccessSnackBar(context, 'Đã bỏ lưu bài viết');
      }
    }
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
                    if (post.communityStatus != null)
                      // Post trong community: dùng CommunityPostHeader
                      CommunityPostHeader(
                        community: post.community,
                        user: post.user,
                        createdAt: post.createdAt,
                        showCommunityInfo: true,
                        onOptionsTap: () {
                          // TODO: Có thể tái sử dụng bottom sheet tùy chọn giống PostItem nếu muốn
                        },
                        onReportTap: () {
                          // TODO: Có thể tái sử dụng bottom sheet báo cáo giống PostItem nếu muốn
                        },
                      )
                    else
                      PostHeader(
                        user: post.user,
                        createdAt: post.createdAt,
                        taggedUsers: _isRemoved
                            ? post.taggedUsers
                                  ?.where((u) => u.userId != _currentUserId)
                                  .toList()
                            : post.taggedUsers,
                        visibleOnProfileUserIds: _visibleOnProfileUserIds,
                        onTagVisibilityTap: _handleTagVisibility,
                        onRemoveTagTap: _handleRemoveTag,
                        onOptionsTap: () {
                          PostOptionsBottomSheet.show(
                            context,
                            post: widget.post,
                          );
                        },
                        isSaved: _isSaved,
                        onReportTap: () {
                          ReportPostBottomSheet.show(
                            context,
                            postId: widget.post.id,
                            ownerUserId: post.user.userId,
                          );
                        },
                        onSaveTap: () {
                          if (_isSaved) {
                            _handleUnsave();
                          } else {
                            SavePostBottomSheet.show(
                              context,
                              post: widget.post,
                              onSaved: (savedId) {
                                setState(() {
                                  _isSaved = true;
                                  _savedId = savedId;
                                });
                              },
                            );
                          }
                        },
                      ),
                    SizedBox(height: 10.h),

                    // Caption + dịch
                    if (post.caption != null && post.caption!.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: PostTranslatableCaption(
                            postId: post.id,
                            caption: post.caption!,
                            textStyle: TextStyle(fontSize: 14.sp, height: 1.4),
                          ),
                        ),
                      ),

                    SizedBox(height: 20.h),

                    // Likes info - ẩn nếu bài viết đang chờ duyệt
                    if (post.communityStatus != 'pending')
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

                    // Reaction Buttons - ẩn nếu bài viết đang chờ duyệt
                    if (post.communityStatus != 'pending') ...[
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
