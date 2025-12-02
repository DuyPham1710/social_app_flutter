import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/date_time_extensions.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/chat/domain/entities/chat_entities.dart';
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

class _ChatDetailPageState extends State<ChatDetailPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  final FocusNode _focusNode = FocusNode();
  Timer? _typingDebounceTimer;

  String? _highlightedMessageId;
  Timer? _highlightTimer;

  late AnimationController _highlightController;
  late Animation<double> _scaleAnimation;

  MessageEntity? _replyingMessage;
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

    // Khởi tạo AnimationController
    _highlightController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400), // Thời gian nhún 1 nhịp
    );

    // Tạo hiệu ứng nhún: 1.0 -> 1.05 -> 1.0
    _scaleAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.05), weight: 50),
          TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 50),
        ]).animate(
          CurvedAnimation(
            parent: _highlightController,
            curve: Curves.easeInOut,
          ),
        );

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
    _highlightController.dispose();
    _focusNode.dispose();
    _typingDebounceTimer?.cancel();
    _highlightTimer?.cancel();
    super.dispose();
  }

  void _setReplyMessage(MessageEntity message) {
    setState(() {
      _replyingMessage = message;
    });
    // Tự động focus vào ô nhập để bàn phím hiện lên
    _focusNode.requestFocus();
  }

  // Hàm hủy trả lời
  void _clearReplyMessage() {
    setState(() {
      _replyingMessage = null;
    });
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
    // Lấy state hiện tại để biết độ dài list
    final state = context.read<MessageBloc>().state;
    if (state is MessagesLoaded && state.messages.data.isNotEmpty) {
      // Cuộn tới phần tử cuối cùng
      _itemScrollController.scrollTo(
        index: state.messages.data.length + 1, // +1 vì có Header Profile
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // Jump to specific message với animation highlight
  void _jumpToMessage(String messageId) {
    final state = context.read<MessageBloc>().state;
    if (state is MessagesLoaded) {
      final messages = state.messages.data;
      final index = messages.indexWhere((msg) => msg.id == messageId);

      if (index != -1) {
        // +1 vì có header profile ở đầu danh sách
        final listViewIndex = index + 1;

        _itemScrollController
            .scrollTo(
              index: listViewIndex,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              alignment: 0.3,
            )
            .then((_) async {
              setState(() {
                _highlightedMessageId = messageId;
              });

              // Chạy animation nhún (Scale Up -> Down)
              await _highlightController.forward(from: 0.0);
              //  await _highlightController.forward(from: 0.0);

              _highlightTimer?.cancel();
              _highlightTimer = Timer(const Duration(milliseconds: 1000), () {
                if (mounted) {
                  setState(() => _highlightedMessageId = null);
                }
              });
            });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tin nhắn cũ chưa được tải')),
        );
      }
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();

    // Don't send if empty
    if (text.isEmpty) return;

    // Stop typing when sending message
    if (widget.conversationId != null) {
      _typingDebounceTimer?.cancel();
      final messageBloc = context.read<MessageBloc>();
      messageBloc.emitTypingStop(widget.userId, widget.conversationId!);

      // Send message
      messageBloc.add(
        SendMessageEvent(
          userId: widget.userId,
          conversationId: widget.conversationId!,
          text: text,
          replyTo: _replyingMessage?.id,
        ),
      );

      // Scroll to bottom after sending
      _scrollToBottom();
    }

    // Clear text field
    _messageController.clear();

    _clearReplyMessage();
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

      body: GestureDetector(
        onTap: () {
          // Ấn ngoài để ẩn bàn phím
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<MessageBloc, MessageState>(
                builder: (context, state) {
                  if (state is MessagesLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
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
                    // WidgetsBinding.instance.addPostFrameCallback((_) {
                    //   _scrollToBottom();
                    // });

                    if (messagesList.isEmpty) {
                      return Column(
                        children: [
                          _buildProfileInfo(),
                          const Expanded(
                            child: Center(
                              child: Text(
                                'No messages yet. Start the conversation!',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    return ScrollablePositionedList.builder(
                      itemScrollController: _itemScrollController,
                      itemPositionsListener: _itemPositionsListener,
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

                        // Kiểm tra xem có phải tin nhắn cuối cùng không
                        final isLastMessage =
                            currentMessageIndex == messagesList.length - 1;

                        // Tạo danh sách participants (chỉ bạn bè, không bao gồm mình)
                        final otherParticipants = widget.friendInfo != null
                            ? [widget.friendInfo!]
                            : <UserEntity>[];

                        final isHighlighted =
                            _highlightedMessageId == message.id;

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

                        bool showTimeHeader = false;

                        // Nếu là tin nhắn đầu tiên của list -> Luôn hiện
                        if (currentMessageIndex == 0) {
                          showTimeHeader = true;
                        } else {
                          // Lấy tin nhắn liền trước đó
                          final previousMessage =
                              messagesList[currentMessageIndex - 1];

                          // Kiểm tra null an toàn và so sánh
                          final difference = message.createdAt.difference(
                            previousMessage.createdAt,
                          );
                          // Nếu cách nhau hơn 15 phút -> Hiện
                          if (difference.inMinutes > 15) {
                            showTimeHeader = true;
                          }
                        }

                        // Highlight animation container
                        return Column(
                          children: [
                            // widget hiển thị thời gian ngắt quãng
                            if (showTimeHeader)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                child: Center(
                                  child: Text(
                                    message.createdAt.formatTimeHeader(),
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),

                            AnimatedBuilder(
                              animation: _highlightController,
                              builder: (context, child) {
                                // Chỉ scale nếu item này đang được highlight
                                final scale = isHighlighted
                                    ? _scaleAnimation.value
                                    : 1.0;

                                return Transform.scale(
                                  scale: scale,
                                  child: Container(
                                    // AnimatedContainer đổi màu nền
                                    decoration: BoxDecoration(
                                      color: isHighlighted
                                          ? AppColors.primary.withOpacity(
                                              0.15,
                                            ) // Màu nền highlight
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),

                                    child: Dismissible(
                                      key: ValueKey(message.id),

                                      movementDuration: const Duration(
                                        milliseconds: 400,
                                      ),

                                      dragStartBehavior: DragStartBehavior.down,

                                      direction: fromMe
                                          ? DismissDirection.endToStart
                                          : DismissDirection.startToEnd,

                                      // Độ nhạy: Kéo 15% chiều rộng là kích hoạt
                                      dismissThresholds: const {
                                        DismissDirection.endToStart: 0.15,
                                        DismissDirection.startToEnd: 0.15,
                                      },

                                      // Xử lý hành động khi kéo
                                      confirmDismiss: (direction) async {
                                        _setReplyMessage(message);

                                        // Trả về FALSE để item KHÔNG bị xóa và tự động búng về chỗ cũ
                                        return false;
                                      },

                                      // Giao diện icon nằm bên dưới khi kéo (cho tin nhắn người khác - kéo sang phải)
                                      background: Container(
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.only(left: 20.w),
                                        color: Colors
                                            .transparent, // Nền trong suốt
                                        child: Icon(
                                          Icons.reply_rounded,
                                          color: AppColors.textSecondary,
                                          size: 24.sp,
                                        ),
                                      ),

                                      // Giao diện icon nằm bên dưới khi kéo (cho tin nhắn của mình - kéo sang trái)
                                      secondaryBackground: Container(
                                        alignment: Alignment.centerRight,
                                        padding: EdgeInsets.only(right: 20.w),
                                        color: Colors.transparent,
                                        child: Icon(
                                          Icons.reply_rounded,
                                          color: AppColors.textSecondary,
                                          size: 24.sp,
                                        ),
                                      ),
                                      child: MessageItem(
                                        message: message,
                                        fromMe: fromMe,
                                        showAvatar: showAvatar,
                                        onReplyTap: (replyId) =>
                                            _jumpToMessage(replyId),
                                        isLastMessage: isLastMessage,
                                        currentUserId: widget.userId,
                                        otherParticipants: otherParticipants,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
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
                                          conversationId:
                                              widget.conversationId!,
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_replyingMessage != null) _buildReplyPreview(),

        Container(
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
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              IconButton(
                icon: Icon(CupertinoIcons.paperplane_fill, color: Colors.blue),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReplyPreview() {
    final replyText = _replyingMessage!.text ?? 'Đã gửi file đính kèm';
    final isReplyingToMe = _replyingMessage!.sender.userId == widget.userId;

    String name;
    if (isReplyingToMe) {
      // Trường hợp trả lời chính mình
      name = 'chính mình';
    } else {
      // Trả lời người khác, lấy chữ cái cuối của tên
      final fullName = _replyingMessage!.sender.fullName ?? 'Unknown';
      final parts = fullName.split(' ');
      name = parts.isNotEmpty ? parts.last : 'Unknown';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.textSecondary.withOpacity(0.2)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dải màu
          Container(
            width: 3.w,
            height: 40.h,
            color: AppColors.primary,
            margin: EdgeInsets.only(right: 8.w),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trả lời $name',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                    color: AppColors.primary,
                  ),
                ),

                SizedBox(height: 2.h),

                Text(
                  replyText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: _clearReplyMessage,
            child: Padding(
              padding: EdgeInsets.only(left: 8.w, top: 4.h),
              child: Icon(
                CupertinoIcons.clear_circled_solid,
                size: 24,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
