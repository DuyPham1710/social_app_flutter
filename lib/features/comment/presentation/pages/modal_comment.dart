import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
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

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();

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
      // User cleared text
      _commentBloc.add(UserTypingEvent(postId: widget.postId, isTyping: false));
    }
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

                CommentHeaderWidget(postId: widget.postId),

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

                        return ListView.builder(
                          controller: scrollController,
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            return CommentItem(comment: comments[index]);
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
                        AddCommentEvent(postId: widget.postId, content: text),
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
