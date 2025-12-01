import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/chat/presentation/bloc/bloc.dart';
import 'package:social_app_fe/features/chat/presentation/pages/chat_info_page.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/message_item.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/chat_typing_indicator.dart';

class ChatDetailPage extends StatefulWidget {
  final String userId;
  final String? conversationId;
  final String? friendId;
  final UserEntity? friendInfo;

  ChatDetailPage({
    super.key,
    required this.userId,
    this.conversationId,
    this.friendId,
    this.friendInfo,
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  Timer? _typingDebounceTimer;

  //late final ConversationBloc _conversationBloc;

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // Lấy bloc 1 lần, khi context còn sống
  //   _conversationBloc = context.read<ConversationBloc>();
  // }

  @override
  void initState() {
    super.initState();

    // Add focus listener to scroll to bottom when TextField is focused
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        // Scroll với delay để đảm bảo bàn phím đã hiện hoàn toàn
        Future.delayed(const Duration(milliseconds: 300), () {
          _scrollToBottom();
        });
      }
    });

    // Nếu có conversationId, thực hiện join phòng chat và load messages
    if (widget.conversationId != null) {
      // context.read<ConversationBloc>().add(
      //   JoinConversationEvent(
      //     userId: widget.userId,
      //     conversationId: widget.conversationId!,
      //   ),
      // );

      // Load messages after joining
      context.read<MessageBloc>().add(
        LoadMessagesEvent(
          userId: widget.userId,
          conversationId: widget.conversationId!,
          page: 1,
          limit: 20,
        ),
      );
    } else {
      // nếu không có conversationId nhưng có friendId, tạo cuộc trò chuyện mới
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    _typingDebounceTimer?.cancel();
    super.dispose();
  }

  void _onTextChanged(String text) {
    if (widget.conversationId == null) return;

    // Cancel previous timer
    _typingDebounceTimer?.cancel();

    if (text.isEmpty) {
      // User cleared the text, stop typing immediately
      final messageBloc = context.read<MessageBloc>();
      messageBloc.emitTypingStop(widget.userId, widget.conversationId!);
    } else {
      // User is typing, emit typing start
      final messageBloc = context.read<MessageBloc>();
      messageBloc.emitTypingStart(widget.userId, widget.conversationId!);

      // // Set timer to auto-stop typing after 3 seconds of inactivity
      // _typingDebounceTimer = Timer(const Duration(seconds: 3), () {
      //   final messageBloc = context.read<MessageBloc>();
      //   messageBloc.emitTypingStop(widget.userId, widget.conversationId!);
      // });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 1),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true, // Đảm bảo UI resize khi bàn phím hiện lên

      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        shape: Border(
          bottom: BorderSide(
            color: AppColors.textSecondary.withOpacity(0.2),
            width: 1,
          ),
        ),
        leadingWidth: 40,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => const ChatInfoPage()),
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  widget.friendInfo?.avatarUrl ?? "https://i.pravatar.cc/200",
                ),
                radius: 18.r,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.friendInfo?.fullName ??
                          widget.friendInfo?.username ??
                          "Unknown User",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    Text(
                      "Đang hoạt động",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              CupertinoIcons.phone_fill,
              color: AppColors.primary,
              size: 24.sp,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              CupertinoIcons.videocam_fill,
              color: AppColors.primary,
              size: 30.sp,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              CupertinoIcons.info_circle_fill,
              color: AppColors.primary,
              size: 24.sp,
            ),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) =>
                      ChatInfoPage(userInfo: widget.friendInfo),
                ),
              );
            },
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<MessageBloc, MessageState>(
              builder: (context, state) {
                if (state is MessagesLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                } else if (state is MessagesLoaded) {
                  final messagesList = state.messages.data;

                  final lastMessageId = messagesList.isNotEmpty
                      ? messagesList.last.id
                      : null;

                  // Mark as read with the last message ID
                  context.read<MessageBloc>().add(
                    MarkAsReadEvent(
                      userId: widget.userId,
                      conversationId: widget.conversationId!,
                      messageId: lastMessageId,
                    ),
                  );

                  // Auto scroll to bottom when messages are loaded
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });

                  if (messagesList.isEmpty) {
                    return Column(
                      children: [
                        _buildProfileInfo(),
                        const Expanded(
                          child: Center(
                            child: Text(
                              'No messages yet. Start the conversation!',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(
                      vertical: 10.h,
                      horizontal: 12.w,
                    ),
                    itemCount:
                        messagesList.length +
                        2, // +1 for profile, +1 for typing indicator
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _buildProfileInfo();
                      }

                      // Typing indicator ở cuối danh sách
                      if (index == messagesList.length + 1) {
                        return ChatTypingIndicator(
                          friendAvatarUrl: widget.friendInfo?.avatarUrl,
                          friendName:
                              widget.friendInfo?.fullName ??
                              widget.friendInfo?.username,
                          currentUserId: widget.userId,
                        );
                      }

                      final int currentMessageIndex = index - 1;
                      final message = messagesList[currentMessageIndex];
                      final fromMe = message.sender.userId == widget.userId;

                      bool showAvatar = false;
                      if (!fromMe) {
                        if (currentMessageIndex == messagesList.length - 1) {
                          showAvatar = true;
                        } else {
                          final nextMessage =
                              messagesList[currentMessageIndex + 1];
                          final nextFromMe =
                              nextMessage.sender.userId == widget.userId;
                          if (nextFromMe) {
                            showAvatar = true;
                          }
                        }
                      }

                      return MessageItem(
                        message: message,
                        fromMe: fromMe,
                        showAvatar: showAvatar,
                      );
                    },
                  );
                } else if (state is MessagesError) {
                  return Column(
                    children: [
                      _buildProfileInfo(),
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Error loading messages: ${state.message}',
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  if (widget.conversationId != null) {
                                    context.read<MessageBloc>().add(
                                      LoadMessagesEvent(
                                        userId: widget.userId,
                                        conversationId: widget.conversationId!,
                                      ),
                                    );
                                  }
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }

                // Default state - show profile info only
                return _buildProfileInfo();
              },
            ),
          ),

          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Container(
      padding: EdgeInsets.only(top: 20.h, bottom: 30.h),
      width: double.infinity,
      child: Column(
        children: [
          CircleAvatar(
            radius: 50.r,
            backgroundImage: NetworkImage(
              widget.friendInfo?.avatarUrl ?? "https://i.pravatar.cc/200",
            ),
          ),
          SizedBox(height: 12.h),

          // Tên hiển thị
          Text(
            widget.friendInfo?.fullName ??
                widget.friendInfo?.username ??
                "Unknown User",
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Username nhỏ
          Text(
            widget.friendInfo?.username != null
                ? "@${widget.friendInfo!.username}"
                : "@unknown",
            style: TextStyle(
              color: AppColors.textSecondary, // Màu xám nhạt
              fontSize: 12.sp,
            ),
          ),

          SizedBox(height: 12.h),

          // Dòng thông tin context (Bạn bè chung, v.v.)
          Text(
            "Các bạn không phải là bạn bè trên Facebook",
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            "1 bạn chung: Hùng Nguyễn",
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 16.h),

          // Nút Xem trang cá nhân
          Container(
            height: 36.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                "Xem trang cá nhân",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Status footer
          Text(
            "Bạn và ${widget.friendInfo?.fullName?.split(' ').last ?? 'bạn này'} hiện đã là bạn bè.",
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.textSecondary.withOpacity(0.2)),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              CupertinoIcons.plus_circle_fill,
              color: AppColors.primary,
              size: 24.sp,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              CupertinoIcons.camera_fill,
              color: AppColors.primary,
              size: 24.sp,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              CupertinoIcons.photo_fill,
              color: AppColors.primary,
              size: 24.sp,
            ),
            onPressed: () {},
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: TextField(
                controller: _messageController,
                focusNode: _focusNode,
                onChanged: _onTextChanged,
                onTap: () {
                  // Scroll to bottom with delay để đợi bàn phím hiện lên hoàn toàn
                  Future.delayed(const Duration(milliseconds: 300), () {
                    _scrollToBottom();
                  });
                },
                decoration: InputDecoration(
                  hintText: "Nhắn tin...",
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                  border: InputBorder.none,
                ),
                style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          IconButton(
            icon: Icon(CupertinoIcons.paperplane_fill, color: Colors.blue),
            onPressed: () {
              final text = _messageController.text.trim();

              // Don't send if empty
              if (text.isEmpty) return;

              // Stop typing when sending message
              if (widget.conversationId != null) {
                _typingDebounceTimer?.cancel();
                final messageBloc = context.read<MessageBloc>();
                messageBloc.emitTypingStop(
                  widget.userId,
                  widget.conversationId!,
                );

                // Send message
                messageBloc.add(
                  SendMessageEvent(
                    userId: widget.userId,
                    conversationId: widget.conversationId!,
                    text: text,
                  ),
                );

                // Scroll to bottom after sending
                _scrollToBottom();
              }

              // Clear text field
              _messageController.clear();
            },
          ),
        ],
      ),
    );
  }
}
