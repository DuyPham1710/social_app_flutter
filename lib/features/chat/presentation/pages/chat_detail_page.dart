import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/core/utils/date_time_extensions.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/chat/domain/entities/chat_entities.dart';
import 'package:social_app_fe/features/chat/domain/entities/message-edit-log_entity.dart';
import 'package:social_app_fe/features/chat/presentation/bloc/bloc.dart';
import 'package:social_app_fe/features/chat/presentation/pages/chat_info_page.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/message_item.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/chat_typing_indicator.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/message_action_sheet.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/message_more_options_dialog.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/message_edit_history_dialog.dart';
import 'package:social_app_fe/features/chat/domain/usecases/get_message_edit_logs_usecase.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:swipe_to/swipe_to.dart';

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
  final int _chatLoadLimit = int.parse(
    const String.fromEnvironment('CHAT_LOAD_LIMIT', defaultValue: '25'),
  );
  String? _highlightedMessageId;
  Timer? _highlightTimer;

  bool _isLoadingMore = false;

  late AnimationController _highlightController;
  late Animation<double> _scaleAnimation;

  MessageEntity? _replyingMessage;
  MessageEntity? _editMessage;

  // Map để lưu GlobalKey cho mỗi message
  final Map<String, GlobalKey> _messageKeys = {};

  // Cache cho edit logs - key: messageId, value: list of edit logs
  final Map<String, List<MessageEditLogEntity>> _editLogsCache = {};
  final Set<String> _loadingEditLogs = {}; // Track messages đang load edit logs
  // Track previous messages để detect khi message được update
  List<MessageEntity>? _previousMessages;
  //late final ConversationBloc _conversationBloc;

  String? _pendingJumpMessageId;

  // Track các page đã load để tránh load trùng
  final Set<int> _loadedPages = {};
  // Track min và max page đã load để biết cần load page nào tiếp theo
  int? _minLoadedPage;
  int? _maxLoadedPage;

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

    // Listen to scroll positions để detect khi cần load more
    _itemPositionsListener.itemPositions.addListener(_onScrollPositionChanged);

    // Nếu có conversationId, thực hiện load messages
    if (widget.conversationId != null) {
      // Load messages after joining
      context.read<MessageBloc>().add(
        LoadMessagesEvent(
          userId: widget.userId,
          conversationId: widget.conversationId!,
          page: 1,
          limit: _chatLoadLimit,
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
      // Clear edit when replying
      _editMessage = null;
      _replyingMessage = message;
    });
    // Tự động focus vào ô nhập để bàn phím hiện lên
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  // Hàm hủy trả lời
  void _clearReplyMessage() {
    setState(() {
      _replyingMessage = null;
    });
  }

  void _setEditMessage(MessageEntity message) {
    setState(() {
      // Clear reply when editing
      _replyingMessage = null;
      _editMessage = message;
      _messageController.text = message.text ?? '';
    });
    // Focus on text field
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  void _clearEditMessage() {
    setState(() {
      _editMessage = null;
      _messageController.clear();
    });
  }

  // Preload edit logs for messages that are edited
  void _preloadEditLogs(List<MessageEntity> messages) {
    for (final message in messages) {
      if (message.isEdited &&
          !_editLogsCache.containsKey(message.id) &&
          !_loadingEditLogs.contains(message.id)) {
        _reloadEditLogsForMessage(message);
      }
    }
    print('preload edit logs done with data $_editLogsCache');
  }

  // Reload edit logs for a specific message
  void _reloadEditLogsForMessage(MessageEntity message) {
    if (!message.isEdited || _loadingEditLogs.contains(message.id)) {
      return;
    }

    final getEditLogsUseCase = s1<GetMessageEditLogsUseCase>();
    _loadingEditLogs.add(message.id);

    // Load edit logs silently in background
    getEditLogsUseCase(
          params: GetMessageEditLogsParams(
            userId: widget.userId,
            messageId: message.id,
          ),
        )
        .then((result) {
          if (result is DataStateSuccess && mounted) {
            setState(() {
              _editLogsCache[message.id] = result.data!;
              _loadingEditLogs.remove(message.id);
            });
          } else {
            if (mounted) {
              _loadingEditLogs.remove(message.id);
            }
          }
        })
        .catchError((error) {
          if (mounted) {
            _loadingEditLogs.remove(message.id);
          }
        });
  }

  // Show edit history dialog
  void _showEditHistory(MessageEntity message) {
    // If already cached, show immediately
    if (_editLogsCache.containsKey(message.id)) {
      MessageEditHistoryDialog.show(
        context: context,
        message: message,
        editLogs: _editLogsCache[message.id]!,
      );
      return;
    }

    // Otherwise load first
    if (_loadingEditLogs.contains(message.id)) {
      // Already loading, show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đang tải lịch sử chỉnh sửa...'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }
  }

  void _onScrollPositionChanged() {
    // Disable load more khi đang jump (load around ID)
    if (_isLoadingMore ||
        widget.conversationId == null ||
        _pendingJumpMessageId != null) {
      return;
    }

    final positions = _itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return;

    final state = context.read<MessageBloc>().state;
    if (state is! MessagesLoaded) return;

    // Tổng số item (bao gồm tin nhắn + header profile + loading/typing indicator)
    final totalItems = state.messages.data.length + 2;

    // Tìm index nhỏ nhất (Item dưới cùng màn hình - hướng về tin nhắn mới)
    final minVisibleIndex = positions
        .where((item) => item.itemLeadingEdge < 1)
        .reduce((min, item) => item.index < min.index ? item : min)
        .index;

    // Tìm index lớn nhất (Item trên cùng màn hình - hướng về tin nhắn cũ)
    final maxVisibleIndex = positions
        .where((item) => item.itemTrailingEdge > 0)
        .reduce((max, item) => item.index > max.index ? item : max)
        .index;

    // LOGIC LOAD MORE (Tin cũ hơn - Lướt lên trên)
    // Nếu index lớn nhất đang hiển thị gần bằng tổng số item
    if (maxVisibleIndex >= totalItems - 2 &&
        state.messages.pagination.hasNextPage) {
      _loadMoreOldMessages();
    }

    if (minVisibleIndex <= 2 && state.messages.pagination.hasPrevPage) {
      _loadMoreNewMessages();
    }
  }

  void _loadMoreOldMessages() {
    if (_isLoadingMore || widget.conversationId == null) return;

    final state = context.read<MessageBloc>().state;
    if (state is MessagesLoaded) {
      final pagination = state.messages.pagination;

      // Tính nextPage: nếu có maxLoadedPage thì dùng maxLoadedPage + 1, không thì dùng currentPage + 1
      final nextPage = _maxLoadedPage != null
          ? _maxLoadedPage! + 1
          : pagination.currentPage + 1;

      // Kiểm tra xem còn trang tiếp theo không và chưa load page đó
      if (pagination.hasNextPage && !_loadedPages.contains(nextPage)) {
        _isLoadingMore = true;
        _loadedPages.add(nextPage); // Đánh dấu đã load page này
        _maxLoadedPage = nextPage; // Cập nhật maxLoadedPage

        context.read<MessageBloc>().add(
          LoadMoreOldMessagesEvent(
            userId: widget.userId,
            conversationId: widget.conversationId!,
            page: nextPage,
            limit: _chatLoadLimit,
          ),
        );

        // Reset loading flag sau khi bloc xử lý xong
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _isLoadingMore = false;
          }
        });
      }
    }
  }

  void _loadMoreNewMessages() {
    if (_isLoadingMore || widget.conversationId == null) return;

    final state = context.read<MessageBloc>().state;
    if (state is MessagesLoaded) {
      final pagination = state.messages.pagination;

      // Tính prevPage: nếu có minLoadedPage thì dùng minLoadedPage - 1, không thì dùng currentPage - 1
      final prevPage = _minLoadedPage != null
          ? _minLoadedPage! - 1
          : pagination.currentPage - 1;

      // Kiểm tra xem còn trang trước đó không và chưa load page đó
      if (pagination.hasPrevPage &&
          prevPage >= 1 &&
          !_loadedPages.contains(prevPage)) {
        _isLoadingMore = true;
        _loadedPages.add(prevPage); // Đánh dấu đã load page này
        _minLoadedPage = prevPage; // Cập nhật minLoadedPage

        context.read<MessageBloc>().add(
          LoadMoreNewMessagesEvent(
            userId: widget.userId,
            conversationId: widget.conversationId!,
            page: prevPage,
            limit: _chatLoadLimit,
          ),
        );

        // Reset loading flag sau khi bloc xử lý xong
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _isLoadingMore = false;
          }
        });
      }
    }
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
    }
  }

  void _scrollToBottom() {
    // Lấy state hiện tại để biết độ dài list
    final state = context.read<MessageBloc>().state;
    if (state is MessagesLoaded && state.messages.data.isNotEmpty) {
      // Với reverse: true, index 0 là item cuối cùng (header - hiển thị ở dưới cùng)
      // Messages mới nhất ở gần index 0 (index 1)
      // Sử dụng jumpTo thay vì scrollTo để nhanh hơn, không lag
      _itemScrollController.jumpTo(
        index: 0, // Scroll đến bottom (header ở dưới cùng khi reverse)
      );
    }
  }

  // Tự động load more nếu message chưa được tải
  void _jumpToMessage(String messageId) {
    final state = context.read<MessageBloc>().state;
    if (state is MessagesLoaded) {
      final messages = state.messages.data;
      final messageIndex = messages.indexWhere((msg) => msg.id == messageId);

      if (messageIndex != -1) {
        print('jumping to message index: $messageIndex');
        // Message đã có trong list -> jump
        _performJump(messageId, messages, messageIndex);
      } else {
        setState(() {
          _pendingJumpMessageId = messageId;
        });

        // Load messages xung quanh messageId
        context.read<MessageBloc>().add(
          LoadMessagesAroundIdEvent(
            userId: widget.userId,
            conversationId: widget.conversationId!,
            messageId: messageId,
            limit: _chatLoadLimit,
          ),
        );
      }
    }
  }

  // Thực hiện jump đến message
  void _performJump(
    String messageId,
    List<MessageEntity> messages,
    int messageIndex,
  ) {
    // Với reverse: true và cách tính actualIndex trong itemBuilder:
    // actualIndex = itemCount - 1 - index (trong builder)
    // Messages: actualIndex từ 1 đến messagesList.length
    // actualIndex = messagesList.length - messageIndex
    // (messageIndex 0 = mới nhất -> actualIndex = messagesList.length)
    // (messageIndex length-1 = cũ nhất -> actualIndex = 1)
    final itemCount = messages.length + 2;
    final actualIndex = messages.length - messageIndex;
    final listViewIndex = itemCount - 1 - actualIndex;

    _itemScrollController.jumpTo(index: listViewIndex);
    Future.delayed(const Duration(milliseconds: 200), () async {
      if (mounted) {
        //  Lúc này mới bắt đầu highlight và chạy animation
        setState(() {
          _highlightedMessageId = messageId;
          _pendingJumpMessageId = null;
        });

        // Bắt đầu nhún
        await _highlightController.forward(from: 0.0);

        //  Hẹn giờ tắt highlight
        _highlightTimer?.cancel();
        _highlightTimer = Timer(const Duration(milliseconds: 1000), () {
          if (mounted) {
            setState(() => _highlightedMessageId = null);
          }
        });
      }
    });
  }

  void _handleMessageLongPress(MessageEntity message, bool fromMe) {
    final messageKey = _messageKeys[message.id];
    if (messageKey == null) return;

    MessageActionSheet.show(
      context: context,
      message: message,
      fromMe: fromMe,
      messageKey: messageKey,
      onReactionSelected: (emoji) {
        _handleReactionSelected(message, emoji);
      },
      onReply: () {
        _setReplyMessage(message);
      },
      onCopy: message.text != null && message.text!.isNotEmpty
          ? () {
              _handleCopyMessage(message);
            }
          : null,
      onDelete: fromMe
          ? () {
              _handleDeleteMessage(message);
            }
          : null,
      onMore: () {
        _showMoreOptionsDialog(message, fromMe);
      },
    );
  }

  void _showMoreOptionsDialog(MessageEntity message, bool fromMe) {
    final bool isFifteenMinutes =
        DateTime.now().difference(message.createdAt).inMinutes <= 15;

    MessageMoreOptionsDialog.show(
      context: context,
      fromMe: fromMe,
      isFifteenMinutes: isFifteenMinutes,
      onDelete: fromMe
          ? () {
              _handleDeleteMessage(message);
            }
          : null,
      onEdit:
          fromMe &&
              isFifteenMinutes &&
              message.text != null &&
              message.text!.isNotEmpty
          ? () {
              _setEditMessage(message);
            }
          : null,
      onPin: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tính năng ghim tin nhắn đang phát triển'),
            duration: Duration(seconds: 1),
          ),
        );
      },
      onForward: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tính năng chuyển tiếp đang phát triển'),
            duration: Duration(seconds: 1),
          ),
        );
      },
      onReport: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tính năng báo cáo tin nhắn đang phát triển'),
            duration: Duration(seconds: 1),
          ),
        );
      },
      onCreateAIImage: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tính năng tạo hình ảnh AI đang phát triển'),
            duration: Duration(seconds: 1),
          ),
        );
      },
    );
  }

  void _handleReactionSelected(MessageEntity message, EmojiType emoji) {
    // TODO: Implement add reaction to message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reaction ${emoji.icon} added to message'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _handleCopyMessage(MessageEntity message) {
    Clipboard.setData(ClipboardData(text: message.text!));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã sao chép tin nhắn'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _handleDeleteMessage(MessageEntity message) {
    // TODO: Implement delete message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Tính năng xóa tin nhắn đang phát triển'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();

    if (text.isEmpty) return;

    // Check if editing message
    if (_editMessage != null) {
      if (text == _editMessage!.text) {
        return;
      }
      // Edit message
      context.read<MessageBloc>().add(
        EditMessageEvent(
          userId: widget.userId,
          messageId: _editMessage!.id,
          newText: text,
        ),
      );

      _clearEditMessage();
      return;
    }

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

      appBar: _buildAppBar(context),

      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            // Ấn ngoài để ẩn bàn phím
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Expanded(
                child: BlocListener<MessageBloc, MessageState>(
                  listener: (context, state) {
                    // Listen để detect khi message được update và reload edit logs
                    if (state is MessagesLoaded) {
                      final currentMessages = state.messages.data;

                      // Nếu có previous messages, so sánh để tìm message được update
                      if (_previousMessages != null) {
                        for (final currentMsg in currentMessages) {
                          final previousMsg = _previousMessages!.firstWhere(
                            (msg) => msg.id == currentMsg.id,
                            orElse: () => currentMsg,
                          );

                          // Nếu message được update và isEdited = true, invalidate cache và reload
                          if (previousMsg.id == currentMsg.id &&
                              currentMsg.isEdited &&
                              (previousMsg.text != currentMsg.text ||
                                  previousMsg.updatedAt !=
                                      currentMsg.updatedAt)) {
                            // Invalidate cache cho message này
                            _editLogsCache.remove(currentMsg.id);
                            _loadingEditLogs.remove(currentMsg.id);

                            // Reload edit logs trong background
                            _reloadEditLogsForMessage(currentMsg);
                          }
                        }
                      }

                      // Update previous messages
                      if (_previousMessages != null) {
                        _previousMessages = List.from(currentMessages);
                      }
                    }
                  },
                  child: BlocBuilder<MessageBloc, MessageState>(
                    builder: (context, state) {
                      if (state is MessagesLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        );
                      } else if (state is MessagesLoaded) {
                        // Không reverse list vì backend đã sort từ mới nhất đến cũ nhất
                        final messagesList = state.messages.data;
                        // Message mới nhất là phần tử đầu tiên trong list
                        // final lastMessageId = messagesList.isNotEmpty
                        //     ? messagesList.first.id
                        //     : null;

                        // Xử lý jump khi load around ID xong
                        if (_pendingJumpMessageId != null) {
                          _messageKeys
                              .clear(); // Clear keys cũ để tránh duplicate GlobalKey
                          _loadedPages
                              .clear(); // Clear để có thể load các page khác
                          final currentPage =
                              state.messages.pagination.currentPage;
                          _loadedPages.add(
                            currentPage,
                          ); // Đánh dấu page hiện tại đã load
                          // Set min và max loaded page = currentPage khi load around ID
                          _minLoadedPage = currentPage;
                          _maxLoadedPage = currentPage;

                          final index = messagesList.indexWhere(
                            (msg) => msg.id == _pendingJumpMessageId,
                          );

                          if (index != -1) {
                            // Đã tìm thấy tin nhắn sau khi load xong -> Thực hiện Jump
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted) {
                                _performJump(
                                  _pendingJumpMessageId!,
                                  messagesList,
                                  index,
                                );
                              }
                            });
                          } else {
                            // Load xong vẫn không thấy (có thể do tin nhắn bị xóa hoặc ID sai)
                            setState(() {
                              _pendingJumpMessageId = null;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Không tìm thấy tin nhắn gốc'),
                              ),
                            );
                          }
                        } else {
                          // Clean up keys cho messages không còn trong list (chỉ khi không jump)
                          final currentMessageIds = messagesList
                              .map((m) => m.id)
                              .toSet();
                          _messageKeys.removeWhere(
                            (key, value) => !currentMessageIds.contains(key),
                          );

                          // Reset loaded pages khi messages được load mới (không phải load more)
                          // Chỉ reset khi pagination.currentPage = 1 (load lần đầu)
                          if (state.messages.pagination.currentPage == 1) {
                            _loadedPages.clear();
                            _loadedPages.add(1); // Đánh dấu page 1 đã load
                            _minLoadedPage = 1;
                            _maxLoadedPage = 1;
                          } else {
                            // Nếu không phải page 1, thêm page hiện tại vào loadedPages
                            final currentPage =
                                state.messages.pagination.currentPage;
                            _loadedPages.add(currentPage);
                            // Cập nhật min/max nếu cần
                            if (_minLoadedPage == null ||
                                currentPage < _minLoadedPage!) {
                              _minLoadedPage = currentPage;
                            }
                            if (_maxLoadedPage == null ||
                                currentPage > _maxLoadedPage!) {
                              _maxLoadedPage = currentPage;
                            }
                          }
                        }

                        // Mark as read with the last message ID
                        // context.read<MessageBloc>().add(
                        //   MarkAsReadEvent(
                        //     userId: widget.userId,
                        //     conversationId: widget.conversationId!,
                        //     messageId: lastMessageId,
                        //   ),
                        // );

                        // Preload edit logs for edited messages (chỉ khi load lần đầu)
                        if (_previousMessages == null) {
                          _preloadEditLogs(messagesList);
                          _previousMessages = List.from(messagesList);
                        }

                        _isLoadingMore = false;

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
                          reverse:
                              true, // Reverse để hiển thị messages mới nhất ở dưới
                          padding: EdgeInsets.symmetric(
                            vertical: 10.h,
                            horizontal: 12.w,
                          ),
                          itemCount:
                              messagesList.length +
                              2, // +1 for profile, +1 for typing indicator
                          itemBuilder: (context, index) {
                            // Với reverse: true, index 0 là item cuối cùng trong list (hiển thị ở dưới cùng)
                            // index cuối là item đầu tiên trong list (hiển thị ở trên cùng)
                            // itemCount - 1 - index sẽ là index thực tế trong list
                            final itemCount = messagesList.length + 2;
                            final actualIndex = itemCount - 1 - index;
                            final pagination = state.messages.pagination;

                            // Profile header ở actualIndex = 0 (index cuối - hiển thị ở trên cùng khi reverse)
                            // Chỉ hiện khi không còn tin nhắn để load
                            if (actualIndex == 0 && !pagination.hasNextPage) {
                              return _buildProfileInfo();
                            }

                            // Typing indicator ở actualIndex = itemCount - 1 (index 0 - hiển thị ở dưới cùng khi reverse)
                            if (actualIndex == itemCount - 1) {
                              return ChatTypingIndicator(
                                friendAvatarUrl: widget.friendInfo?.avatarUrl,
                                friendName:
                                    widget.friendInfo?.fullName ??
                                    widget.friendInfo?.username,
                                currentUserId: widget.userId,
                              );
                            }

                            // Messages: actualIndex từ 1 đến messagesList.length
                            // actualIndex = 1 -> message cũ nhất (messagesList[messagesList.length - 1])
                            // actualIndex = messagesList.length -> message mới nhất (messagesList[0])
                            if (actualIndex >= 1 &&
                                actualIndex <= messagesList.length) {
                              // Convert actualIndex thành message index
                              // actualIndex = 1 -> messageIndex = messagesList.length - 1 (cũ nhất)
                              // actualIndex = messagesList.length -> messageIndex = 0 (mới nhất)
                              final int currentMessageIndex =
                                  messagesList.length - actualIndex;
                              final message = messagesList[currentMessageIndex];
                              final fromMe =
                                  message.sender.userId == widget.userId;

                              // Kiểm tra xem có phải tin nhắn mới nhất không (index 0 trong list)
                              final isLastMessage = currentMessageIndex == 0;

                              // Tạo danh sách participants (chỉ bạn bè, không bao gồm mình)
                              final otherParticipants =
                                  widget.friendInfo != null
                                  ? [widget.friendInfo!]
                                  : <UserEntity>[];

                              final isHighlighted =
                                  _highlightedMessageId == message.id;

                              // Lấy hoặc tạo GlobalKey cho message - đảm bảo chỉ tạo 1 lần
                              final messageKey = _messageKeys.putIfAbsent(
                                message.id,
                                () => GlobalKey(
                                  debugLabel: 'message_${message.id}',
                                ),
                              );

                              bool showAvatar = false;
                              if (!fromMe) {
                                // Nếu là message mới nhất (index 0) -> luôn show avatar
                                if (currentMessageIndex == 0) {
                                  showAvatar = true;
                                } else {
                                  // Kiểm tra message tiếp theo (mới hơn, index nhỏ hơn)
                                  final preMessage =
                                      messagesList[currentMessageIndex - 1];
                                  final preFromMe =
                                      preMessage.sender.userId == widget.userId;
                                  if (preFromMe) {
                                    showAvatar = true;
                                  }
                                }
                              }

                              bool showTimeHeader = false;

                              // Nếu là tin nhắn mới nhất (index 0) -> Luôn hiện
                              if (currentMessageIndex ==
                                  messagesList.length - 1) {
                                showTimeHeader = true;
                              } else {
                                // Lấy tin nhắn mới hơn (index nhỏ hơn)
                                final nextMessage =
                                    messagesList[currentMessageIndex + 1];

                                // Kiểm tra null an toàn và so sánh
                                final difference = message.createdAt.difference(
                                  nextMessage.createdAt,
                                );
                                // Nếu cách nhau hơn 15 phút -> Hiện
                                if (difference.inMinutes > 15) {
                                  showTimeHeader = true;
                                }
                              }

                              // Highlight animation container
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // widget hiển thị thời gian ngắt quãng
                                  if (showTimeHeader) _showTimeHeader(message),

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
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                          ),

                                          child: SwipeTo(
                                            key: messageKey,

                                            onRightSwipe: !fromMe
                                                ? (details) {
                                                    _setReplyMessage(message);
                                                  }
                                                : null, // null nghĩa là disable hướng này

                                            onLeftSwipe: fromMe
                                                ? (details) {
                                                    _setReplyMessage(message);
                                                  }
                                                : null,

                                            iconOnRightSwipe: Icons.reply,
                                            iconOnLeftSwipe: Icons.reply,

                                            // Màu sắc icon
                                            iconColor: AppColors.textSecondary,

                                            child: MessageItem(
                                              message: message,
                                              fromMe: fromMe,
                                              showAvatar: showAvatar,
                                              onReplyTap: (replyId) =>
                                                  _jumpToMessage(replyId),
                                              isLastMessage: isLastMessage,
                                              currentUserId: widget.userId,
                                              otherParticipants:
                                                  otherParticipants,
                                              onLongPress: () =>
                                                  _handleMessageLongPress(
                                                    message,
                                                    fromMe,
                                                  ),
                                              onEditHistoryTap: message.isEdited
                                                  ? () => _showEditHistory(
                                                      message,
                                                    )
                                                  : null,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            }

                            // Fallback (không nên xảy ra)
                            return const SizedBox.shrink();
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
              ),
              _buildInputArea(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
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
            CupertinoPageRoute(
              builder: (context) => ChatInfoPage(userInfo: widget.friendInfo),
            ),
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
                builder: (context) => ChatInfoPage(userInfo: widget.friendInfo),
              ),
            );
          },
        ),
      ],
    );
  }

  Padding _showTimeHeader(MessageEntity message) {
    return Padding(
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
        if (_editMessage != null) _buildEditPreview(),

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
                      // Scroll sau khi keyboard animation hoàn thành
                      Future.delayed(const Duration(milliseconds: 350), () {
                        if (mounted) {
                          _scrollToBottom();
                        }
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

  Widget _buildEditPreview() {
    final editText = _editMessage!.text ?? '';

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
          // Dải màu vàng cho edit
          Container(
            width: 3.w,
            height: 40.h,
            color: Colors.orange,
            margin: EdgeInsets.only(right: 8.w),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chỉnh sửa tin nhắn',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                    color: Colors.orange,
                  ),
                ),

                SizedBox(height: 2.h),

                Text(
                  editText,
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
            onTap: _clearEditMessage,
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
