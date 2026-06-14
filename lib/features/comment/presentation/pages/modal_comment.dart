import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/comment/domain/entities/comment_entity.dart';
import 'package:social_app_fe/features/comment/presentation/bloc/comment_bloc.dart';
import 'package:social_app_fe/features/comment/presentation/bloc/comment_details_bloc.dart';
import 'package:social_app_fe/features/comment/presentation/bloc/comment_details_event.dart';
import 'package:social_app_fe/features/comment/presentation/bloc/comment_details_state.dart';
import 'package:social_app_fe/features/comment/presentation/bloc/comment_event.dart';
import 'package:social_app_fe/features/comment/presentation/pages/comment_history_page.dart';
import 'package:social_app_fe/features/comment/presentation/widgets/comment_header_widget.dart';
import 'package:social_app_fe/features/comment/presentation/widgets/comment_input_field.dart';
import 'package:social_app_fe/features/comment/presentation/widgets/comment_item.dart';
import 'package:social_app_fe/features/comment/presentation/widgets/empty_comments_widget.dart';
import 'package:social_app_fe/features/comment/presentation/widgets/typing_indicator.dart';
import 'package:social_app_fe/features/friend/domain/usecases/get_friends_usecase.dart';
import 'package:social_app_fe/features/post/domain/entities/react_post_entity.dart';

class ModalComment extends StatefulWidget {
  final String postId;
  final List<ReactPostEntity>? reacts;
  final bool? isPressComment;
  final String? initialCommentId;
  final bool isBottomSheet;

  const ModalComment({
    super.key,
    required this.postId,
    this.reacts,
    this.isPressComment = false,
    this.initialCommentId,
    this.isBottomSheet = false,
  });

  @override
  State<ModalComment> createState() => _ModalCommentState();

  /// Hiển thị modal comment tương thích responsive:
  /// - Mobile: showModalBottomSheet (kéo từ dưới lên)
  /// - Web/Desktop: showDialog (dialog đè lên màn hình chính)
  static void show(
    BuildContext context, {
    required String postId,
    List<ReactPostEntity>? reacts,
    bool isPressComment = false,
    String? initialCommentId,
  }) {
    if (ResponsiveHelper.isMobile(context)) {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return ModalComment(
            postId: postId,
            reacts: reacts,
            isPressComment: isPressComment,
            initialCommentId: initialCommentId,
            isBottomSheet: true,
          );
        },
      );
    } else {
      showDialog(
        context: context,
        barrierColor: Colors.black54,
        builder: (BuildContext context) {
          return ModalComment(
            postId: postId,
            reacts: reacts,
            isPressComment: isPressComment,
            initialCommentId: initialCommentId,
            isBottomSheet: false,
          );
        },
      );
    }
  }
}

class _ModalCommentState extends State<ModalComment> {
  //late TextEditingController _controller;
  late FocusNode _focusNode;
  late CommentBloc _commentBloc;
  late CommentDetailsBloc _commentDetailsBloc;
  late String? _parentId;
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  String? _replyingToUserName;
  String? _highlightedCommentId;
  bool _hasScrolledToComment = false;

  // Track for scrolling to newly sent comment
  int _previousCommentCount = 0;
  bool _shouldScrollToNewComment = false;
  bool _isSendingReply = false; // Track if sending reply
  String? _currentUserId;

  String? _currentUserAvatar;
  final GlobalKey<FlutterMentionsState> _mentionKey =
      GlobalKey<FlutterMentionsState>();
  TextEditingController get _mentionsController =>
      _mentionKey.currentState!.controller!;

  List<Map<String, dynamic>> _suggestionList = [];
  Map<String, dynamic>? _tempReplyUser;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _parentId = null;
    _loadCurrentUser();
    _loadFriendSuggestions();

    // Tạo CommentBloc và CommentDetailsBloc từ DI
    _commentBloc = s1<CommentBloc>();
    _commentDetailsBloc = s1<CommentDetailsBloc>();

    // Join post khi mở modal
    _commentBloc.add(JoinPostEvent(widget.postId));

    _commentDetailsBloc.add(LoadCommentDetailsEvent(widget.postId));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mentionsController.addListener(_onTextChanged);
    });

    if (widget.isPressComment!) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  Future<void> _loadCurrentUser() async {
    final userData = await TokenStorage.getUserData();
    if (mounted) {
      setState(() {
        _currentUserAvatar = userData?['avatarUrl'];
        _currentUserId = userData?['id'];
      });
    }
  }

  String markupToVisible(String markup) {
    return markup.replaceAllMapped(
      RegExp(r'@\[([^\]]+)\]\(([^)]+)\)'),
      (m) => '@${m.group(1)}',
    );
  }

  Future<void> _loadFriendSuggestions() async {
    try {
      // 1. Lấy UseCase từ DI
      final getFriendsUseCase = s1<GetFriendsUseCase>();

      // 2. Gọi API lấy danh sách
      final dataState = await getFriendsUseCase();

      // 3. Kiểm tra kết quả
      if (dataState is DataStateSuccess && dataState.data != null) {
        final friends = dataState.data!;

        // 4. Map dữ liệu sang format yêu cầu: {id, display, full_name, photo}
        final mappedFriends = friends.map((friend) {
          return {
            'id': friend.userId, // ID để gửi lên server
            'display': friend.fullName ?? 'Unknown', // Tên hiển thị khi tag
            'full_name': friend.fullName ?? 'Unknown', // Tên hiển thị dòng dưới
            'photo':
                friend.avatarUrl ??
                'https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg',
          };
        }).toList();

        print("Đã load gợi ý bạn bè: $mappedFriends");

        if (mounted) {
          setState(() {
            _suggestionList = mappedFriends;
          });
        }
      } else {
        // Xử lý lỗi nếu cần (DataFailed)
        print("Lỗi lấy danh sách bạn bè: ${dataState.error}");
      }
    } catch (e) {
      print("Exception khi load friend suggestions: $e");
    }
  }

  void _onTextChanged() {
    final text = _mentionsController.text;

    if (text.isNotEmpty) {
      _commentBloc.add(UserTypingEvent(postId: widget.postId, isTyping: true));
    } else {
      _parentId = null;
      _commentBloc.add(UserTypingEvent(postId: widget.postId, isTyping: false));
    }
  }

  void _handleUpdateComment(String commentId, String newContent) {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();
    // Gửi event cập nhật comment
    _commentBloc.add(
      UpdateCommentEvent(
        commentId: commentId,
        content: newContent,
        postId: widget.postId,
      ),
    );
  }

  void _handleDeleteComment(String commentId, String postId) {
    // Gửi event xóa comment
    _commentBloc.add(DeleteCommentEvent(commentId: commentId, postId: postId));
  }

  void _handleViewHistory(String commentId, String currentContent) {
    if (ResponsiveHelper.isWebOrDesktop) {
      showDialog(
        context: context,
        barrierColor: Colors.black54,
        builder: (dialogContext) => Center(
          child: Container(
            width: 500,
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BlocProvider.value(
                value: _commentBloc,
                child: CommentHistoryPage(
                  commentId: commentId,
                  currentContent: currentContent,
                  isDialog: true,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      // Navigate to comment history page với CommentBloc
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: _commentBloc,
            child: CommentHistoryPage(
              commentId: commentId,
              currentContent: currentContent,
            ),
          ),
        ),
      );
    }
  }

  Future<void> _handleReply(
    String userId,
    String userAvatar,
    String? parentId,
    String userDisplayName,
  ) async {
    final userData = await TokenStorage.getUserData();
    final currentUserId = userData?['id'];

    // 1. Nếu trả lời chính mình: Chỉ set UI, KHÔNG mention
    if (userId == currentUserId) {
      setState(() {
        _parentId = parentId;
        _replyingToUserName = "ME";
      });
      _focusNode.requestFocus();
      return;
    }

    // 2. Nếu trả lời người khác
    setState(() {
      _parentId = parentId;
      _replyingToUserName = userDisplayName;

      _tempReplyUser = {
        'id': userId,
        'display': userDisplayName,
        'full_name': userDisplayName,
        'photo': userAvatar.isNotEmpty
            ? userAvatar
            : 'https://via.placeholder.com/150',
      };
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentState = _mentionKey.currentState;
      final controller = currentState?.controller;

      if (currentState != null &&
          controller != null &&
          _tempReplyUser != null) {
        final mentionConfig = Mention(
          trigger: '@',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
          data: [],
          markupBuilder: (trigger, value, display) {
            return '@[$display]($value)';
          },
        );

        String currentText = controller.text;

        if (currentText.isNotEmpty && !currentText.endsWith(' ')) {
          currentText += ' ';
        }
        controller.text = '$currentText@';
        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length),
        );
        currentState.addMention(_tempReplyUser!, mentionConfig);
      }
      _focusNode.requestFocus();
    });
  }

  //hủy reply
  void _handleCancelReply() {
    setState(() {
      _parentId = null;
      _replyingToUserName = null;
      _tempReplyUser = null;
    });
    _mentionsController.clear();
    FocusScope.of(context).unfocus();
  }

  void _scrollToAndHighlightComment(List<CommentEntity> comments) {
    if (widget.initialCommentId == null || _hasScrolledToComment) {
      return; // Đã scroll rồi hoặc không có comment cần highlight
    }

    // Đánh dấu đã scroll ngay từ đầu để không bao giờ scroll lại
    _hasScrolledToComment = true;

    final parentComments = comments.where((c) => c.parentId == null).toList();

    // Tìm index của parent comment chứa target
    int? targetIndex;

    for (int i = 0; i < parentComments.length; i++) {
      if (parentComments[i].id == widget.initialCommentId) {
        // Target là parent comment
        targetIndex = i;
        break;
      }

      // Kiểm tra trong replies
      final replies = comments
          .where((c) => c.parentId?.id == parentComments[i].id)
          .toList();

      if (replies.any((r) => r.id == widget.initialCommentId)) {
        targetIndex = i;
        break;
      }
    }

    if (targetIndex != null) {
      // Set highlight ngay
      setState(() {
        _highlightedCommentId = widget.initialCommentId;
      });

      // Đợi frame hiện tại render xong rồi scroll (bất đồng bộ thay vì delay cố định)
      SchedulerBinding.instance.addPostFrameCallback((_) {
        // Double check để chắc chắn ScrollablePositionedList đã attached
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (mounted && _itemScrollController.isAttached) {
            _itemScrollController.scrollTo(
              index: targetIndex!,
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeInOut,
              alignment: 0.1, // Hiển thị gần đầu màn hình
            );
          }
        });
      });

      // Tự động clear highlight sau 3s
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _highlightedCommentId = null;
          });
        }
      });
    }
  }

  Map<String, List<CommentEntity>> _groupCommentsByParent(
    List<CommentEntity> comments,
  ) {
    final Map<String, List<CommentEntity>> grouped = {};
    final List<CommentEntity> parentComments = [];
    final List<CommentEntity> replies = [];

    // Chia comments thành parent và replies
    for (final comment in comments) {
      if (comment.parentId == null) {
        parentComments.add(comment);
      } else {
        replies.add(comment);
      }
    }

    // Group replies by parent ID
    for (final reply in replies) {
      final parentId = reply.parentId?.id ?? '';
      if (grouped[parentId] == null) {
        grouped[parentId] = [];
      }
      grouped[parentId]!.add(reply);
    }

    // Add parent comments with empty reply lists if no replies
    for (final parent in parentComments) {
      if (grouped[parent.id] == null) {
        grouped[parent.id] = [];
      }
    }

    return grouped;
  }

  @override
  void dispose() {
    // Leave post khi đóng modal
    _commentBloc.add(LeavePostEvent(widget.postId));
    _commentBloc.close();
    _commentDetailsBloc.add(StopListeningCommentsEvent());
    _commentDetailsBloc.close();

    // Safely remove listener
    final currentState = _mentionKey.currentState;
    final controller = currentState?.controller;
    if (controller != null) {
      controller.removeListener(_onTextChanged);
    }

    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = widget.isBottomSheet;
    final effectiveSuggestionList = [
      if (_tempReplyUser != null) _tempReplyUser!,
      ..._suggestionList.where(
        (u) => u['id'] != _tempReplyUser?['id'],
      ), // Tránh trùng lặp
    ];

    final commentBody = _buildCommentBody(context, effectiveSuggestionList);

    if (!isMobile) {
      // Web/Desktop: hiển thị dưới dạng Dialog căn giữa
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Center(
          child: Container(
            width: 500,
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: commentBody,
            ),
          ),
        ),
      );
    }

    // Mobile: DraggableScrollableSheet truyền thống
    return Portal(
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _commentBloc),
          BlocProvider.value(value: _commentDetailsBloc),
        ],
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.95,
          maxChildSize: 0.95,
          minChildSize: 0.3,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              ),
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  CommentHeaderWidget(
                    postId: widget.postId,
                    reacts: widget.reacts,
                    onMention: _handleReply,
                  ),
                  SizedBox(height: 10.h),
                  Divider(height: 1.h, color: AppColors.divider),
                  Expanded(child: _buildCommentList(context)),
                  Divider(height: 1.h, color: AppColors.divider),
                  const TypingIndicator(),
                  CommentInputField(
                    mentionKey: _mentionKey,
                    currentUserAvatar: _currentUserAvatar,
                    suggestionList: effectiveSuggestionList,
                    replyingToUserName: _replyingToUserName,
                    onCancelReply: _handleCancelReply,
                    onSendComment: (markupContent, taggedUserIds) {
                      final isReply = _parentId != null;
                      setState(() {
                        _shouldScrollToNewComment = true;
                        _isSendingReply = isReply;
                      });
                      _commentBloc.add(
                        AddCommentEvent(
                          postId: widget.postId,
                          content: markupContent,
                          parentId: _parentId,
                          taggedUserIds: taggedUserIds,
                        ),
                      );
                      setState(() {
                        _parentId = null;
                        _replyingToUserName = null;
                      });
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Xây dựng nội dung chính cho Web/Desktop dialog
  Widget _buildCommentBody(
    BuildContext context,
    List<Map<String, dynamic>> effectiveSuggestionList,
  ) {
    return Portal(
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _commentBloc),
          BlocProvider.value(value: _commentDetailsBloc),
        ],
        child: Column(
          children: [
            // Header bar with close button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40), // spacer for centering
                  Text(
                    Localizations.localeOf(context).languageCode == 'vi'
                        ? 'Bình luận'
                        : 'Comments',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: AppColors.iconPrimary,
                      size: 22,
                    ),
                    onPressed: () => Navigator.pop(context),
                    splashRadius: 20,
                  ),
                ],
              ),
            ),

            Divider(height: 1, thickness: 1, color: AppColors.divider),

            CommentHeaderWidget(
              postId: widget.postId,
              reacts: widget.reacts,
              onMention: _handleReply,
            ),

            const SizedBox(height: 8),
            Divider(height: 1, thickness: 1, color: AppColors.divider),

            Expanded(child: _buildCommentList(context)),

            Divider(height: 1, thickness: 1, color: AppColors.divider),

            const TypingIndicator(),

            CommentInputField(
              mentionKey: _mentionKey,
              currentUserAvatar: _currentUserAvatar,
              suggestionList: effectiveSuggestionList,
              replyingToUserName: _replyingToUserName,
              onCancelReply: _handleCancelReply,
              onSendComment: (markupContent, taggedUserIds) {
                final isReply = _parentId != null;
                setState(() {
                  _shouldScrollToNewComment = true;
                  _isSendingReply = isReply;
                });
                _commentBloc.add(
                  AddCommentEvent(
                    postId: widget.postId,
                    content: markupContent,
                    parentId: _parentId,
                    taggedUserIds: taggedUserIds,
                  ),
                );
                setState(() {
                  _parentId = null;
                  _replyingToUserName = null;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Widget chung cho danh sách comment (dùng chung cho cả Mobile và Web)
  Widget _buildCommentList(BuildContext context) {
    return BlocListener<CommentDetailsBloc, CommentDetailsState>(
      listener: (context, state) {
        // Khi comments đã load xong, scroll và highlight
        if (state is CommentDetailsLoaded && widget.initialCommentId != null) {
          _scrollToAndHighlightComment(state.commentsData!.comments);
        }

        if (state is CommentDetailsLoaded &&
            _shouldScrollToNewComment &&
            !_isSendingReply) {
          final currentCount = state.commentsData!.comments.length;

          if (currentCount > _previousCommentCount) {
            _shouldScrollToNewComment = false;
            _isSendingReply = false;

            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted && _itemScrollController.isAttached) {
                final parentComments = state.commentsData!.comments
                    .where((c) => c.parentId == null)
                    .toList();

                if (parentComments.isNotEmpty) {
                  _itemScrollController.scrollTo(
                    index: parentComments.length - 1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              }
            });
          }

          _previousCommentCount = currentCount;
        } else if (state is CommentDetailsLoaded) {
          _previousCommentCount = state.commentsData!.comments.length;

          if (_shouldScrollToNewComment && _isSendingReply) {
            _shouldScrollToNewComment = false;
            _isSendingReply = false;
          }
        }
      },
      child: BlocBuilder<CommentDetailsBloc, CommentDetailsState>(
        builder: (context, state) {
          if (state is CommentDetailsLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is CommentDetailsEmpty) {
            return EmptyCommentsWidget(
              onTapToComment: () {
                _focusNode.requestFocus();
              },
            );
          }

          if (state is CommentDetailsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage ?? 'Có lỗi xảy ra',
                    style: TextStyle(fontSize: 14, color: Colors.red[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          if (state is CommentDetailsLoaded) {
            final comments = state.commentsData!.comments;
            final groupedComments = _groupCommentsByParent(comments);
            final parentComments = comments
                .where((c) => c.parentId == null)
                .toList();

            return FutureBuilder<Map<String, dynamic>?>(
              future: TokenStorage.getUserData(),
              builder: (context, snapshot) {
                final currentUserId = snapshot.data?['id'];
                return ScrollablePositionedList.builder(
                  itemScrollController: _itemScrollController,
                  itemPositionsListener: _itemPositionsListener,
                  itemCount: parentComments.length,
                  itemBuilder: (context, index) {
                    final parentComment = parentComments[index];
                    final replies = groupedComments[parentComment.id] ?? [];
                    final hasTargetReply = replies.any(
                      (r) => r.id == widget.initialCommentId,
                    );
                    return CommentItem(
                      comment: parentComment,
                      onReply: _handleReply,
                      replies: replies,
                      showReplies: hasTargetReply,
                      currentUserId: currentUserId,
                      onUpdateComment: _handleUpdateComment,
                      onDeleteComment: _handleDeleteComment,
                      onViewHistory: _handleViewHistory,
                      isHighlighted: parentComment.id == _highlightedCommentId,
                      targetCommentId: _highlightedCommentId,
                    );
                  },
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
