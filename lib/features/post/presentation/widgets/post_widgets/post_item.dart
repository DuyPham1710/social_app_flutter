import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/core/utils/react_post_util.dart';
import 'package:social_app_fe/features/comment/presentation/pages/modal_comment.dart';
import 'package:social_app_fe/features/post/domain/entities/post_entity.dart';
import 'package:social_app_fe/features/post/domain/entities/react_post_entity.dart';
import 'package:social_app_fe/features/post/presentation/helpers/tag_action_helper.dart';
import 'dart:async';
import 'package:social_app_fe/features/post/presentation/pages/post_detail_page.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/post_action.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/post_header.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/community_post_header.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/community_post_header_base.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/post_react_info.dart';
import 'package:social_app_fe/shared/component/layout/layout_post_classic.dart';
import 'package:social_app_fe/shared/component/layout/layout_post_column.dart';
import 'package:social_app_fe/shared/component/layout/layout_post_frame.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/post_options_bottom_sheet.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/post_translatable_caption.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/report_post_bottom_sheet.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/save_post_bottom_sheet.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/features/save/domain/repository/save_repository.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/post/domain/usecases/view_post_usecase.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class PostItem extends StatefulWidget {
  final PostEntity post;
  final int commentCount;
  final bool isSaved;

  /// Nếu true, dùng CommunityPostHeaderBase cho posts có community.
  final bool isInCommunityDetail;
  final String? communityUserRole;

  const PostItem({
    super.key,
    required this.post,
    this.commentCount = 0,
    this.isSaved = false,
    this.isInCommunityDetail = false,
    this.communityUserRole,
  });

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  late List<ReactPostEntity> _localReacts;
  EmojiType? _currentUserReaction;
  bool _isSaved = false;
  String? _savedId;
  int _lastMediaIndex = 0;
  final SaveRepository _saveRepository = s1<SaveRepository>();
  List<String> _visibleOnProfileUserIds = [];
  bool _isRemoved = false; // To hide item if tag removed

  void _openPostDetail({int initialImageIndex = 0}) {
    unawaited(
      s1<ViewPostUsecase>()(params: ViewPostParams(postId: widget.post.id)),
    );
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => PostDetailPage(
          post: widget.post,
          initialImageIndex: initialImageIndex,
        ),
      ),
    );
  }

  Future<void> _showPostOptions() async {
    PostOptionsBottomSheet.show(
      context,
      post: widget.post,
      onDeleted: () {
        if (mounted) {
          setState(() {
            _isRemoved = true;
          });
        }
      },
    );
  }

  void _showCommunityPostOptions() {
    PostOptionsBottomSheet.show(
      context,
      post: widget.post,
      showOwnerActions: false,
      onDeleted: () {
        if (mounted) {
          setState(() {
            _isRemoved = true;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _localReacts = List.from(widget.post.reacts ?? []);
    _currentUserReaction = null;
    _isSaved = widget.isSaved;
    _visibleOnProfileUserIds = List.from(
      widget.post.visibleOnProfileUserIds ?? [],
    );
    _initCurrentUserReaction();
    _checkSavedStatus();
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
              _isRemoved = true;
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
        showSuccessSnackBar(context, context.l10n.postUnsaveSuccess);
      }
    }
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
      _lastMediaIndex = initialIndex;
      _openPostDetail(initialImageIndex: initialIndex);
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

    return layout;
  }

  @override
  Widget build(BuildContext context) {
    if (_isRemoved) return const SizedBox.shrink();

    final user = widget.post.user;
    final urls = widget.post.urls;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 12.rs(context),
        vertical: 8.rsh(context),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.rsh(context)),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(
          color: AppColors.divider.withValues(alpha: 0.85),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12.rsr(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: Offset(0, 3.rsh(context)),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: Offset(0, 1.rsh(context)),
            spreadRadius: 0,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header - chọn header dựa trên loại post (kiểm tra communityStatus)
          if (widget.post.communityStatus != null) ...[
            // Post trong community
            if (widget.isInCommunityDetail)
              // Trong community detail: dùng CommunityPostHeaderBase (header đơn giản)
              CommunityPostHeaderBase(
                user: user,
                createdAt: widget.post.createdAt,
                communityUserRole: widget.communityUserRole,
                isSaved: _isSaved,
                onOptionsTap: () {
                  _showCommunityPostOptions();
                },
                onReportTap: () {
                  ReportPostBottomSheet.show(
                    context,
                    postId: widget.post.id,
                    ownerUserId: user.userId,
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
                          _savedId = savedId;
                          _isSaved = true;
                        });
                      },
                    );
                  }
                },
              )
            else
              // Ngoài community: dùng CommunityPostHeader (header full với community info)
              CommunityPostHeader(
                community: widget.post.community,
                user: user,
                createdAt: widget.post.createdAt,
                showCommunityInfo: true,
                communityUserRole: widget.communityUserRole,
                isSaved: _isSaved,
                onOptionsTap: () {
                  _showCommunityPostOptions();
                },
                onReportTap: () {
                  ReportPostBottomSheet.show(
                    context,
                    postId: widget.post.id,
                    ownerUserId: user.userId,
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
                          _savedId = savedId;
                          _isSaved = true;
                        });
                      },
                    );
                  }
                },
              ),
          ] else ...[
            // Header
            PostHeader(
              user: user,
              createdAt: widget.post.createdAt,
              taggedUsers: widget.post.taggedUsers,
              visibleOnProfileUserIds: _visibleOnProfileUserIds,
              onTagVisibilityTap: _handleTagVisibility,
              onRemoveTagTap: _handleRemoveTag,
              onOptionsTap: () {
                _showPostOptions();
              },
              isSaved: _isSaved,
              onReportTap: () {
                ReportPostBottomSheet.show(
                  context,
                  postId: widget.post.id,
                  ownerUserId: user.userId,
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
                        _savedId = savedId;
                        _isSaved = true;
                      });
                    },
                  );
                }
              },
            ),
          ],

          // Caption + dịch
          if (widget.post.caption != null && widget.post.caption!.isNotEmpty)
            GestureDetector(
              onTap: widget.post.urls.isEmpty ? _openPostDetail : null,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.rs(context)),
                child: PostTranslatableCaption(
                  postId: widget.post.id,
                  caption: widget.post.caption!,
                  textStyle: TextStyle(
                    fontSize: 13.rsp(context),
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),

          SizedBox(height: 8.rsh(context)),

          // Media (images)
          if (urls.isNotEmpty)
            _buildMediaLayout(context, urls)
          else
            GestureDetector(
              onTap: _openPostDetail,
              behavior: HitTestBehavior.opaque,
              child: SizedBox(height: 8.rsh(context)),
            ),

          SizedBox(height: 8.rsh(context)),

          // Likes info - ẩn nếu bài viết đang chờ duyệt
          if (widget.post.communityStatus != 'pending')
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

          SizedBox(height: 20.rsh(context)),

          // Post actions - ẩn nếu bài viết đang chờ duyệt
          if (widget.post.communityStatus != 'pending')
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
