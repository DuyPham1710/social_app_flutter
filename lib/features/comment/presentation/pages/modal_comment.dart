import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/features/comment/domain/entities/comment_entity.dart';
import 'package:social_app_fe/features/comment/presentation/bloc/comment_bloc.dart';
import 'package:social_app_fe/features/comment/presentation/bloc/comment_details_bloc.dart';
import 'package:social_app_fe/features/comment/presentation/bloc/comment_details_event.dart';
import 'package:social_app_fe/features/comment/presentation/bloc/comment_details_state.dart';
import 'package:social_app_fe/features/comment/presentation/bloc/comment_event.dart';
import 'package:social_app_fe/features/comment/presentation/widgets/comment_header_widget.dart';
import 'package:social_app_fe/features/comment/presentation/widgets/comment_input_field.dart';
import 'package:social_app_fe/features/comment/presentation/widgets/comment_item.dart';
import 'package:social_app_fe/features/comment/presentation/widgets/empty_comments_widget.dart';
import 'package:social_app_fe/features/comment/presentation/widgets/typing_indicator.dart';
import 'package:social_app_fe/features/post/domain/entities/react_post_entity.dart';

class ModalComment extends StatefulWidget {
  final String postId;
  final List<ReactPostEntity>? reacts;
  final bool? isPressComment;

  const ModalComment({
    super.key,
    required this.postId,
    this.reacts,
    this.isPressComment = false,
  });

  @override
  State<ModalComment> createState() => _ModalCommentState();
}

class _ModalCommentState extends State<ModalComment> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late CommentBloc _commentBloc;
  late CommentDetailsBloc _commentDetailsBloc;
  late String? _parentId;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _parentId = null;

    // Tạo CommentBloc và CommentDetailsBloc từ DI
    _commentBloc = s1<CommentBloc>();
    _commentDetailsBloc = s1<CommentDetailsBloc>();

    // Join post khi mở modal
    _commentBloc.add(JoinPostEvent(widget.postId));

    // Load comment details - không clear cache mỗi lần
    _commentDetailsBloc.add(LoadCommentDetailsEvent(widget.postId));

    // Listen text changes để emit typing
    _controller.addListener(_onTextChanged);

    if (widget.isPressComment!) {
      // Nếu mở modal từ việc nhấn vào biểu tượng bình luận, focus ngay
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  void _onTextChanged() {
    if (_controller.text.isNotEmpty) {
      // User is typing
      _commentBloc.add(UserTypingEvent(postId: widget.postId, isTyping: true));
    } else {
      _parentId = null;
      // User cleared text
      _commentBloc.add(UserTypingEvent(postId: widget.postId, isTyping: false));
    }
  }

  void _handleUpdateComment(String commentId, String newContent) {
    // Gửi event cập nhật comment
    _commentBloc.add(
      UpdateCommentEvent(
        commentId: commentId,
        content: newContent,
        postId: widget.postId,
      ),
    );
  }

  void _handleReply(String? parentId, String userDisplayName) {
    _parentId = parentId;
    // Thêm reply mention vào text field và focus
    final currentText = _controller.text;
    final replyText = '$userDisplayName ';

    // Nếu đã có text, thêm reply sau text hiện tại với space
    final newText = currentText.isEmpty ? replyText : '$currentText $replyText';

    _controller.text = newText;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: newText.length),
    );

    // Focus vào text field
    _focusNode.requestFocus();
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
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
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
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),

                SizedBox(height: 10.h),

                CommentHeaderWidget(
                  postId: widget.postId,
                  onMention: _handleReply,
                ),

                SizedBox(height: 10.h),
                Divider(height: 1.h, color: AppColors.divider),

                Expanded(
                  child: BlocBuilder<CommentDetailsBloc, CommentDetailsState>(
                    builder: (context, state) {
                      if (state is CommentDetailsLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
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
                              Icon(
                                Icons.error_outline,
                                size: 48.w,
                                color: Colors.red[400],
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                state.errorMessage ?? 'Có lỗi xảy ra',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.red[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }

                      if (state is CommentDetailsLoaded) {
                        final comments = state.commentsData!.comments;

                        final groupedComments = _groupCommentsByParent(
                          comments,
                        );

                        final parentComments = comments
                            .where((c) => c.parentId == null)
                            .toList();

                        return FutureBuilder<Map<String, dynamic>?>(
                          future: TokenStorage.getUserData(),
                          builder: (context, snapshot) {
                            final currentUserId = snapshot.data?['id'];

                            return ListView.builder(
                              controller: scrollController,
                              itemCount: parentComments.length,
                              itemBuilder: (context, index) {
                                final parentComment = parentComments[index];
                                final replies =
                                    groupedComments[parentComment.id] ?? [];

                                return CommentItem(
                                  comment: parentComment,
                                  onReply: _handleReply,
                                  replies: replies,
                                  currentUserId: currentUserId,
                                  onUpdateComment: _handleUpdateComment,
                                );
                              },
                            );
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),

                Divider(height: 1.h, color: Colors.grey[300]),

                const TypingIndicator(),

                CommentInputField(
                  controller: _controller,
                  focusNode: _focusNode,
                  onSend: () async {
                    if (_controller.text.isNotEmpty) {
                      final text = _controller.text.trim();

                      // Gửi event vào bloc
                      context.read<CommentBloc>().add(
                        AddCommentEvent(
                          postId: widget.postId,
                          content: text,
                          parentId: _parentId,
                        ),
                      );
                      // Clear the input field
                      _controller.clear();
                      _focusNode.unfocus();
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
