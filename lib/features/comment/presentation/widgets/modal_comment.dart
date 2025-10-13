import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/features/comment/presentation/bloc/comment_bloc.dart';
import 'package:social_app_fe/features/comment/presentation/bloc/comment_event.dart';
import 'package:social_app_fe/features/comment/presentation/bloc/comment_state.dart';

class ModalComment extends StatefulWidget {
  final String postId;
  final bool? isPressComment;

  const ModalComment({
    super.key,
    required this.postId,
    this.isPressComment = false,
  });

  @override
  State<ModalComment> createState() => _ModalCommentState();
}

class _ModalCommentState extends State<ModalComment> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late CommentBloc _commentBloc;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();

    // Tạo CommentBloc từ DI
    _commentBloc = s1<CommentBloc>();

    // Join post khi mở modal
    _commentBloc.add(JoinPostEvent(widget.postId));

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

    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _commentBloc,
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

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: const [
                              CircleAvatar(
                                radius: 12,
                                backgroundImage: NetworkImage(
                                  "https://i.pinimg.com/1200x/39/44/6c/39446caa52f53369b92bc97253d2b2f1.jpg",
                                ),
                              ),
                              Positioned(
                                left: 18,
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundImage: NetworkImage(
                                    "https://www.citypng.com/public/uploads/preview/haha-facebook-messenger-react-face-like-emoji-701751695136164me5ogbbpnk.png",
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(width: 20.w),

                          Text(
                            '1000',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      TextButton(
                        onPressed: () {},
                        child: Text(
                          '28 lượt chia sẻ',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10.h),
                Divider(height: 1.h, color: AppColors.divider),

                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.fromLTRB(12.w, 12.h, 4.w, 16.h),

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 18.r,
                              backgroundImage: NetworkImage(
                                'https://i.pinimg.com/736x/8b/28/8d/8b288dbd8cb07d0f85adc8bdd7006ecc.jpg',
                              ),
                            ),

                            SizedBox(width: 10.w),

                            // Comment content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Comment container
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 8.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.backgroundCommentItem,
                                      borderRadius: BorderRadius.circular(14.r),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'User ${index + 1}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13.sp,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        SizedBox(height: 3.h),
                                        Text(
                                          'This is a comment from user ${index + 1}.',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Bottom actions: date, like, reply
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 4.h,
                                          left: 6.w,
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              '6 ngày',
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                            SizedBox(width: 10.w),
                                            Text(
                                              'Thích',
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                            SizedBox(width: 10.w),
                                            Text(
                                              'Trả lời',
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Reaction badge (bottom right corner)
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 4.h,
                                          left: 8.w,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 4.w,
                                                vertical: 2.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black12,
                                                    blurRadius: 2,
                                                    offset: Offset(0, 1),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Image.network(
                                                    'https://i.pinimg.com/1200x/39/44/6c/39446caa52f53369b92bc97253d2b2f1.jpg',
                                                    width: 12.w,
                                                    height: 12.h,
                                                  ),
                                                  SizedBox(width: 2.w),
                                                  Image.network(
                                                    'https://www.citypng.com/public/uploads/preview/haha-facebook-messenger-react-face-like-emoji-701751695136164me5ogbbpnk.png',
                                                    width: 12.w,
                                                    height: 12.h,
                                                  ),
                                                  SizedBox(width: 4.w),
                                                  Text(
                                                    '5',
                                                    style: TextStyle(
                                                      fontSize: 11.sp,
                                                      color: Colors.grey[700],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                Divider(height: 1.h, color: Colors.grey[300]),
                _buildTypingIndicator(),
                _buildCommentInput(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return BlocBuilder<CommentBloc, CommentState>(
      builder: (context, state) {
        if (state is CommentJoined && state.typingUsers.isNotEmpty) {
          final typingUsers = state.typingUsers.toList();
          String typingText;

          if (typingUsers.length == 1) {
            typingText = '${typingUsers[0].username ?? 'Someone'} is typing...';
          } else if (typingUsers.length == 2) {
            typingText =
                '${typingUsers[0].username ?? 'Someone'} and ${typingUsers[1].username ?? 'someone'} are typing...';
          } else {
            typingText =
                '${typingUsers[0].username ?? 'Someone'} and ${typingUsers.length - 1} others are typing...';
          }

          return Container(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //_buildTypingDots(),
                SizedBox(
                  width: 36.w,
                  height: 26.h,
                  child: ClipRect(
                    child: OverflowBox(
                      maxWidth: 100.w,
                      maxHeight: 80.h,
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          AppColors.textSecondary, // Màu giống với text
                          BlendMode.srcATop,
                        ),
                        child: Lottie.asset(
                          'animations/dots_loader.json',
                          repeat: true,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),

                Expanded(
                  child: Text(
                    typingText,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCommentInput(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(
          context,
        ).viewInsets.bottom, // đẩy lên khi bàn phím mở
        left: 16.w,
        right: 10.w,
        top: 8.h,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundImage: NetworkImage(
              'https://i.pinimg.com/736x/8b/28/8d/8b288dbd8cb07d0f85adc8bdd7006ecc.jpg',
            ),
          ),
          SizedBox(width: 10.w),

          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(color: Colors.transparent),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: 'What do you think of this?',
                  border: InputBorder.none,
                ),
                minLines: 1,
                maxLines: 5,
              ),
            ),
          ),

          SizedBox(width: 6.w),

          IconButton(
            icon: Icon(
              CupertinoIcons.paperplane_fill,
              color: Colors.blueAccent,
              size: 24.sp,
            ),
            onPressed: () async {
              if (_controller.text.isNotEmpty) {
                print('Posting comment: ${_controller.text}');
                // Clear the input field
                _controller.clear();
                _focusNode.unfocus();
              }
            },
          ),
        ],
      ),
    );
  }
}
