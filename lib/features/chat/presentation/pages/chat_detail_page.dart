import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/permission_helper.dart';
import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/core/utils/date_time_extensions.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/chat/domain/entities/chat_entities.dart';
import 'package:social_app_fe/features/chat/domain/entities/message-edit-log_entity.dart';
import 'package:social_app_fe/features/chat/presentation/bloc/bloc.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/message_item.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/chat_typing_indicator.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/message_action_sheet.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/message_more_options_dialog.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/message_edit_history_dialog.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/delete_message_bottom_sheet.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/chat_appbar.dart';
import 'package:social_app_fe/features/chat/domain/usecases/get_message_edit_logs_usecase.dart';
import 'package:social_app_fe/features/chat/domain/usecases/get_summary_unread_usecase.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/local/app_preferences.dart';
import 'package:social_app_fe/core/helpers/device_translation_locale.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/profile_header.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/scroll_to_bottom_button.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_info_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/attachment_menu_widget.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/voice_recording_widget.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/grid_image_item.dart';
import 'package:social_app_fe/features/post/presentation/pages/camera_screen.dart';
import 'package:social_app_fe/shared/helpers/camera_helper.dart';
import 'package:social_app_fe/features/video_call/presentation/bloc/bloc.dart';
import 'package:social_app_fe/features/video_call/presentation/pages/video_call_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:social_app_fe/core/enums/attachment_type.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import 'package:social_app_fe/shared/helpers/video_thumbnail.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatDetailPage extends StatefulWidget {
  final String userId;
  final String username;
  final String? conversationId;
  final String? friendId;
  final UserEntity? friendInfo;
  final int? unreadCount;
  final int? firstUnreadMessageIndex;
  final bool isGroup;
  final bool isWebLayout;
  final String? groupName;
  final String? groupAvatar;
  final List<UserEntity>? participants;
  final VoidCallback? onInfoTap;

  const ChatDetailPage({
    super.key,
    required this.userId,
    required this.username,
    this.conversationId,
    this.friendId,
    this.friendInfo,
    this.unreadCount,
    this.firstUnreadMessageIndex,
    this.isGroup = false,
    this.isWebLayout = false,
    this.groupName,
    this.groupAvatar,
    this.participants,
    this.onInfoTap,
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

  // Track conversationId khi tạo mới (nếu chỉ có friendId)
  String? _currentConversationId;
  bool _isCreatingConversation = false;

  // Track unread count
  int? _unreadCount;
  int? _firstUnreadMessageIndex;
  bool _showSummaryBanner = true;
  List<String> _unreadMessageTexts = [];

  // Track input expansion state
  bool _isInputExpanded = false;

  bool _isRecording = false;

  // Track attachment menu state
  bool _showAttachmentMenu = false;

  // Track photo picker state
  bool _showPhotoPicker = false;
  List<AssetEntity> _photoList = [];
  bool _isLoadingPhotos = false;
  bool _isLoadingMorePhotos = false;
  int _currentPhotoPage = 0;
  static const int _photosPerPage = 50;
  bool _hasMorePhotos = true;
  bool _showScrollButton = false;

  // Selected photos
  List<AssetEntity> _selectedPhotos = [];

  // Cache cho thumbnails
  final Map<String, Uint8List> _thumbnailCache = {};

  // Photo picker height và drag
  double _photoPickerHeight = 0.0;
  final ScrollController _photoPickerScrollController = ScrollController();

  // Captured photo from camera
  String? _capturedPhotoPath;

  // Video call bloc
  // late VideoCallBloc _videoCallBloc;

  // Helper methods để tính min/max height
  double _getPhotoPickerMinHeight() {
    // 50% màn hình
    return MediaQuery.of(context).size.height * 0.5;
  }

  double _getPhotoPickerMaxHeight() {
    // 100% màn hình (trừ safe area top và bottom, app bar, và input area)
    final screenHeight = MediaQuery.of(context).size.height;
    final safeAreaTop = MediaQuery.of(context).padding.top;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;
    final appBarHeight = AppBar().preferredSize.height;
    final inputAreaHeight = 100.0; // Chiều cao input area
    // Trừ đi app bar, safe area top, input area, và safe area bottom
    return screenHeight -
        safeAreaTop -
        appBarHeight -
        inputAreaHeight -
        safeAreaBottom;
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // Lấy bloc 1 lần, khi context còn sống
  //   _conversationBloc = context.read<ConversationBloc>();
  // }

  @override
  void initState() {
    super.initState();

    // Khởi tạo unread count từ parameter
    _unreadCount = widget.unreadCount;
    _firstUnreadMessageIndex = widget.firstUnreadMessageIndex;

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

    // Listen to focus changes để mở rộng input
    _focusNode.addListener(_onFocusChanged);

    // Save VideoCallBloc reference for dispose
    // _videoCallBloc = context.read<VideoCallBloc>();

    // Connect to video call socket once when page opens
    context.read<VideoCallBloc>().add(
      ConnectVideoCall(userId: widget.userId, username: widget.username),
    );

    // Nếu có conversationId, thực hiện load messages
    if (widget.conversationId != null) {
      _currentConversationId = widget.conversationId;
      // Load messages after joining
      context.read<MessageBloc>().add(
        LoadMessagesEvent(
          userId: widget.userId,
          conversationId: _currentConversationId!,
          page: 1,
          limit: _chatLoadLimit,
        ),
      );
    } else if (widget.friendId != null && !_isCreatingConversation) {
      // Nếu không có conversationId nhưng có friendId, tạo cuộc trò chuyện mới
      _isCreatingConversation = true;
      context.read<ConversationBloc>().add(
        CreateConversationEvent(
          userId: widget.userId,
          participantIds: [widget.friendId!],
          isGroup: false,
        ),
      );
    }
  }

  void _onFocusChanged() {
    // Không tự động set expanded khi focus, để có thể toggle
    // Chỉ set expanded = false khi unfocus
    if (!_focusNode.hasFocus) {
      setState(() {
        _isInputExpanded = false;
      });
    } else {
      setState(() {
        _showPhotoPicker = false;
        _showAttachmentMenu = false;
      });
    }
  }

  void _toggleInputExpansion() {
    setState(() {
      _isInputExpanded = !_isInputExpanded;
    });
    // Đảm bảo input vẫn được focus
    if (!_focusNode.hasFocus) {
      _focusNode.requestFocus();
    }
  }

  void _collapseInput() {
    setState(() {
      _isInputExpanded = false;
    });
  }

  void _onPhotoPickerScroll(ScrollController scrollController) {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent * 0.8) {
      // Load more khi scroll đến 80% cuối
      if (!_isLoadingMorePhotos && _hasMorePhotos) {
        _loadMorePhotos();
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _highlightController.dispose();
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    _photoPickerScrollController.dispose();
    _typingDebounceTimer?.cancel();
    _highlightTimer?.cancel();

    // _videoCallBloc.add(const DisconnectVideoCall());

    super.dispose();
  }

  // void _handleIncomingCall(IncomingCallEntity incomingCallModel) {
  //   if (!mounted) return;

  //   // Navigate to incoming call screen
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => IncomingCallScreen(
  //         callData: incomingCallModel,
  //         userId: widget.userId,
  //       ),
  //     ),
  //   ).then((_) {
  //     // Clear call state after returning
  //     // _videoCallBloc.add(const ClearCallState());
  //   });
  // }

  void _handleCallCreated(callResponse) {
    if (!mounted) return;

    //Đợi 1 frame để đảm bảo không conflict với loading dialog
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoCallScreen(
            channelId: callResponse.channelId,
            token: callResponse.token,
            appId: callResponse.appId,
            callId: callResponse.callId,
            userId: widget.userId,
            isVideo: callResponse.callType == 'video',
            isCaller: true,
            callerName:
                widget.friendInfo?.fullName ?? widget.friendInfo?.username,
            callerAvatar: widget.friendInfo?.avatarUrl,
            receiverName:
                widget.friendInfo?.fullName ?? widget.friendInfo?.username,
            receiverAvatar: widget.friendInfo?.avatarUrl,
          ),
        ),
      );
      // Socket remains connected for future calls
    });
  }

  Future<void> _initiateCall(String callType) async {
    try {
      // Check permissions
      final hasPermissions = await PermissionHelper.checkCallPermissions(
        callType,
      );
      if (!hasPermissions) {
        if (mounted) {
          PermissionHelper.showPermissionDeniedError(context, callType);
        }
        return;
      }

      context.read<VideoCallBloc>().add(
        CreateCall(
          userId: widget.userId,
          receiverId: widget.friendInfo!.userId,
          callType: callType,
          conversationId: _currentConversationId,
        ),
      );

      // BlocListener sẽ tự động navigate khi state thay đổi
    } catch (e) {
      _showError(context.l10n.chatStartCallFailed('$e'));
    }
  }

  void _showError(String message) {
    if (mounted) {
      showErrorSnackBar(context, message);
    }
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
      showInfoSnackBar(context, context.l10n.chatLoadingEditHistory);
      return;
    }
  }

  void _onScrollPositionChanged() {
    // Disable load more khi đang jump (load around ID)
    final conversationId = _currentConversationId ?? widget.conversationId;
    if (_isLoadingMore ||
        conversationId == null ||
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

    if (minVisibleIndex > 8) {
      if (!_showScrollButton) {
        setState(() {
          _showScrollButton = true;
        });
      }
    } else {
      if (_showScrollButton) {
        setState(() {
          _showScrollButton = false;
        });
      }
    }

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
    final conversationId = _currentConversationId ?? widget.conversationId;
    if (_isLoadingMore || conversationId == null) return;

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
            conversationId: conversationId,
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
    final conversationId = _currentConversationId ?? widget.conversationId;
    if (_isLoadingMore || conversationId == null) return;

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
            conversationId: conversationId,
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
    final conversationId = _currentConversationId ?? widget.conversationId;
    if (conversationId == null) return;

    // Cancel previous timer
    _typingDebounceTimer?.cancel();

    if (text.isEmpty) {
      // User cleared the text, stop typing immediately
      final messageBloc = context.read<MessageBloc>();
      messageBloc.emitTypingStop(widget.userId, conversationId);
    } else {
      // User is typing, emit typing start
      final messageBloc = context.read<MessageBloc>();
      messageBloc.emitTypingStart(widget.userId, conversationId);
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
        final conversationId = _currentConversationId ?? widget.conversationId;
        if (conversationId == null) return;
        context.read<MessageBloc>().add(
          LoadMessagesAroundIdEvent(
            userId: widget.userId,
            conversationId: conversationId,
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
      onDelete: () {
        _showDeleteMessageOptions(message, fromMe);
      },
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
      onDelete: () {
        _showDeleteMessageOptions(message, fromMe);
      },
      onEdit:
          fromMe &&
              isFifteenMinutes &&
              message.text != null &&
              message.text!.isNotEmpty
          ? () {
              _setEditMessage(message);
            }
          : null,
      onCopy: message.text != null && message.text!.isNotEmpty
          ? () {
              _handleCopyMessage(message);
            }
          : null,
      onPin: () {
        showInfoSnackBar(context, context.l10n.chatPinInDevelopment);
      },
      onForward: () {
        showInfoSnackBar(context, context.l10n.chatForwardInDevelopment);
      },
      onReport: () {
        showInfoSnackBar(context, context.l10n.chatReportInDevelopment);
      },
      onCreateAIImage: () {
        showInfoSnackBar(context, context.l10n.chatAiImageInDevelopment);
      },
      onTranslate:
          message.text != null &&
              message.text!.trim().isNotEmpty &&
              message.translationNotNeeded != true
          ? () {
              if (message.translatedText != null) {
                context.read<MessageBloc>().add(
                  ToggleMessageTranslationEvent(
                    messageId: message.id,
                    showTranslation: !(message.showTranslation ?? false),
                  ),
                );
              } else {
                final targetLang = appTranslationTargetLang(context);
                context.read<MessageBloc>().add(
                  TranslateMessageEvent(
                    messageId: message.id,
                    targetLang: targetLang,
                  ),
                );
              }
            }
          : null,
      translateLabel: message.translatedText != null
          ? (message.showTranslation == true
                ? context.l10n.postSeeOriginal
                : context.l10n.postSeeTranslation)
          : context.l10n.postSeeTranslation,
    );
  }

  void _handleReactionSelected(MessageEntity message, EmojiType emoji) {
    final conversationId = _currentConversationId ?? widget.conversationId;
    if (conversationId == null) {
      showErrorSnackBar(
        context,
        context.l10n.chatMissingConversationForReaction,
      );
      return;
    }

    // Dispatch ReactMessageEvent
    context.read<MessageBloc>().add(
      ReactMessageEvent(
        userId: widget.userId,
        conversationId: conversationId,
        messageId: message.id,
        emojiId: emoji.id,
      ),
    );
  }

  void _handleCopyMessage(MessageEntity message) {
    Clipboard.setData(ClipboardData(text: message.text!));
    showSuccessSnackBar(context, context.l10n.chatMessageCopied);
  }

  void _showDeleteMessageOptions(MessageEntity message, bool fromMe) {
    DeleteMessageBottomSheet.show(
      context: context,
      isMyMessage: fromMe,
      onDeleteForEveryone: () {
        _handleDeleteMessage(message, deleteForEveryone: true);
      },
      onDeleteForMe: () {
        _handleDeleteMessage(message, deleteForEveryone: false);
      },
    );
  }

  void _handleDeleteMessage(
    MessageEntity message, {
    required bool deleteForEveryone,
  }) {
    // Dispatch DeleteMessageEvent
    context.read<MessageBloc>().add(
      DeleteMessageEvent(
        userId: widget.userId,
        messageId: message.id,
        deleteForEveryone: deleteForEveryone,
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
    final conversationId = _currentConversationId ?? widget.conversationId;
    if (conversationId != null) {
      _typingDebounceTimer?.cancel();
      final messageBloc = context.read<MessageBloc>();
      messageBloc.emitTypingStop(widget.userId, conversationId);

      // Send message
      messageBloc.add(
        SendMessageEvent(
          userId: widget.userId,
          conversationId: conversationId,
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

  Future<void> _shareCurrentLocation() async {
    try {
      final messenger = ScaffoldMessenger.of(context);

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(context.l10n.chatGpsDisabledOpeningSettings),
            duration: const Duration(seconds: 2),
          ),
        );
        await Geolocator.openLocationSettings();
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        messenger.showSnackBar(
          SnackBar(content: Text(context.l10n.chatLocationPermissionDenied)),
        );
        return;
      }
      if (permission == LocationPermission.deniedForever) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(context.l10n.chatLocationPermissionDeniedForever),
            duration: const Duration(seconds: 2),
          ),
        );
        await Geolocator.openAppSettings();
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final conversationId = _currentConversationId ?? widget.conversationId;
      if (conversationId == null) return;

      // NOTE: Phần gửi metadata sẽ được nối vào pipeline ở TODO tiếp theo.
      final lat = position.latitude;
      final lng = position.longitude;
      final mapUrl =
          'https://www.google.com/maps/search/?api=1&query=$lat,$lng';

      context.read<MessageBloc>().add(
        SendMessageEvent(
          userId: widget.userId,
          conversationId: conversationId,
          text: context.l10n.chatSendLocationMessage,
          metadata: {
            'type': 'location',
            'latitude': lat,
            'longitude': lng,
            'mapUrl': mapUrl,
            'label': context.l10n.chatCurrentLocation,
          },
          replyTo: _replyingMessage?.id,
        ),
      );

      _clearReplyMessage();
      _scrollToBottom();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.chatGetLocationFailed('$e'))),
      );
    }
  }

  Future<void> _pickGiphySticker() async {
    try {
      final apiKey = dotenv.env['GIPHY_API_KEY'] ?? 'dc6zaTOxFJmzC';

      final gif = await GiphyGet.getGif(
        context: context,
        apiKey: apiKey,
        lang: GiphyLanguage.english,
        showGIFs: true,
        showStickers: true,
        showEmojis: false,
        tabColor: AppColors.primary,
      );

      if (gif != null && gif.images?.original?.url != null) {
        final gifUrl = gif.images!.original!.url;
        await _sendGiphySticker(gifUrl);
      }
    } catch (e) {
      print('Error picking Giphy sticker: $e');
      if (mounted) {
        showErrorSnackBar(context, context.l10n.chatGiphyError('$e'));
      }
    }
  }

  Future<void> _sendGiphySticker(String gifUrl) async {
    final conversationId = _currentConversationId ?? widget.conversationId;
    if (conversationId == null) {
      showErrorSnackBar(context, context.l10n.chatMissingConversationForPhoto);
      return;
    }

    _typingDebounceTimer?.cancel();
    final messageBloc = context.read<MessageBloc>();
    messageBloc.emitTypingStop(widget.userId, conversationId);

    messageBloc.add(
      SendMessageEvent(
        userId: widget.userId,
        conversationId: conversationId,
        text: '',
        attachments: [
          {
            'url': gifUrl,
            'type': AttachmentType.image.name,
            'size': 0,
            'name': 'giphy_sticker.gif',
          },
        ],
        replyTo: _replyingMessage?.id,
      ),
    );

    _scrollToBottom();

    setState(() {
      _replyingMessage = null;
    });
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _showAttachmentMenu = false;
      _showPhotoPicker = false;
      _focusNode.unfocus();
    });
  }

  void _stopAndSendRecording(
    String filePath, {
    required int duration,
    required List<double> waveform,
  }) {
    setState(() => _isRecording = false);

    final conversationId = _currentConversationId ?? widget.conversationId;

    if (conversationId != null) {
      context.read<MessageBloc>().add(
        SendMessageWithFilesEvent(
          userId: widget.userId,
          conversationId: conversationId,
          filePaths: [filePath],
          replyTo: _replyingMessage?.id,
          audioDuration: duration,
          audioWaveform: waveform,
        ),
      );
      _clearReplyMessage();
      _scrollToBottom();
    }
  }

  void _cancelRecording() {
    setState(() => _isRecording = false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VideoCallBloc, VideoCallState>(
      listener: (context, state) {
        // if (state.status == VideoCallStatus.incomingCall &&
        //     state.incomingCall != null) {
        //   _handleIncomingCall(state.incomingCall!);
        // } else
        if (state.status == VideoCallStatus.callCreated &&
            state.activeCall != null) {
          _handleCallCreated(state.activeCall!);
        } else if (state.status == VideoCallStatus.error) {
          _showError(state.errorMessage ?? context.l10n.commonUnknown);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        resizeToAvoidBottomInset:
            true, // Đảm bảo UI resize khi bàn phím hiện lên

        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: ChatAppbar(
            isGroup: widget.isGroup,
            groupName: widget.groupName,
            groupAvatar: widget.groupAvatar,
            participants: widget.participants,
            friendInfo: widget.friendInfo,
            conversationId: _currentConversationId ?? widget.conversationId,
            userId: widget.userId,
            username: widget.username,
            isWebLayout: widget.isWebLayout,
            onInitiateCall: _initiateCall,
            onInfoTap: widget.onInfoTap,
          ),
        ),

        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              // Ấn ngoài để ẩn bàn phím
              FocusScope.of(context).unfocus();
            },
            child: Column(
              children: [
                if (_unreadCount != null &&
                    _unreadCount! > 0 &&
                    _showSummaryBanner &&
                    _unreadMessageTexts.isNotEmpty)
                  _buildAiSummaryBanner(),
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: BlocListener<ConversationBloc, ConversationState>(
                          listener: (context, state) {
                            // Listen kết quả tạo conversation
                            if (state is CreateConversationSuccess) {
                              setState(() {
                                _currentConversationId = state.conversation.id;
                                _isCreatingConversation = false;
                              });
                              // Load messages sau khi có conversationId
                              context.read<MessageBloc>().add(
                                LoadMessagesEvent(
                                  userId: widget.userId,
                                  conversationId: state.conversation.id,
                                  page: 1,
                                  limit: _chatLoadLimit,
                                ),
                              );
                              state is MessagesLoaded
                                  ? print('true state is: $state')
                                  : print('flase state is: $state');
                            } else if (state is CreateConversationError) {
                              setState(() {
                                _isCreatingConversation = false;
                              });
                              showErrorSnackBar(
                                context,
                                context.l10n.chatCreateConversationFailed(
                                  state.message ?? context.l10n.commonUnknown,
                                ),
                              );
                            }
                          },
                          child: BlocListener<MessageBloc, MessageState>(
                            listener: (context, state) {
                              // Listen để detect khi message được update và reload edit logs
                              if (state is MessagesLoaded) {
                                final currentMessages = state.messages.data;

                                if (_previousMessages == null) {
                                  if (_firstUnreadMessageIndex != null &&
                                      _firstUnreadMessageIndex! >= 0) {
                                    final List<String> unreadTexts = [];
                                    final limit = _firstUnreadMessageIndex! + 1;
                                    final messagesToProcess = currentMessages
                                        .take(limit)
                                        .toList()
                                        .reversed;
                                    for (final msg in messagesToProcess) {
                                      if (msg.sender.userId != widget.userId) {
                                        final senderName =
                                            msg.sender.fullName ??
                                            msg.sender.username ??
                                            'Người dùng';
                                        final text = msg.text ?? '';
                                        final attachmentsCount =
                                            msg.attachments.length;
                                        final attachmentsText =
                                            attachmentsCount > 0
                                            ? '[Đính kèm $attachmentsCount file/hình ảnh]'
                                            : '';
                                        final formatted =
                                            "$senderName: $text $attachmentsText"
                                                .trim();
                                        if (formatted.isNotEmpty) {
                                          unreadTexts.add(formatted);
                                        }
                                      }
                                    }
                                    setState(() {
                                      _unreadMessageTexts = unreadTexts;
                                    });
                                    debugPrint(
                                      '[ChatDetail] Initialized unread messages for AI: ${_unreadMessageTexts.length}',
                                    );
                                  }
                                }

                                // Check if new messages were added
                                if (_previousMessages != null &&
                                    currentMessages.length >
                                        _previousMessages!.length &&
                                    _firstUnreadMessageIndex != null) {
                                  final newMessagesCount =
                                      currentMessages.length -
                                      _previousMessages!.length;

                                  setState(() {
                                    // Increase the index by the number of new messages
                                    _firstUnreadMessageIndex =
                                        _firstUnreadMessageIndex! +
                                        newMessagesCount;
                                  });
                                  debugPrint(
                                    '[ChatDetail] Adjusted unread marker index to $_firstUnreadMessageIndex due to $newMessagesCount new messages',
                                  );
                                }

                                // Nếu có previous messages, so sánh để tìm message được update
                                if (_previousMessages != null) {
                                  for (final currentMsg in currentMessages) {
                                    final previousMsg = _previousMessages!
                                        .firstWhere(
                                          (msg) => msg.id == currentMsg.id,
                                          orElse: () => currentMsg,
                                        );

                                    // Kiểm tra xem message có bị xóa không (deletedForEveryone hoặc deletedFor thay đổi)
                                    final wasDeletedForEveryone =
                                        previousMsg.deletedForEveryone;
                                    final isDeletedForEveryone =
                                        currentMsg.deletedForEveryone;
                                    final wasDeletedForMe =
                                        previousMsg.deletedFor?.any(
                                          (user) =>
                                              user.userId == widget.userId,
                                        ) ??
                                        false;
                                    final isDeletedForMe =
                                        currentMsg.deletedFor?.any(
                                          (user) =>
                                              user.userId == widget.userId,
                                        ) ??
                                        false;

                                    // Nếu message vừa bị xóa (cho tôi hoặc cho mọi người) bởi chính user này
                                    // Chỉ show snackbar nếu là message của chính user này hoặc user này vừa xóa
                                    final isMyMessage =
                                        currentMsg.sender.userId ==
                                        widget.userId;
                                    if (isMyMessage &&
                                        ((!wasDeletedForEveryone &&
                                                isDeletedForEveryone) ||
                                            (!wasDeletedForMe &&
                                                isDeletedForMe))) {
                                      // Show success snackbar
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                            if (mounted) {
                                              showSuccessSnackBar(
                                                context,
                                                isDeletedForEveryone
                                                    ? context
                                                          .l10n
                                                          .chatDeletedForEveryone
                                                    : context
                                                          .l10n
                                                          .chatDeletedForMe,
                                              );
                                            }
                                          });
                                    }

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
                                  _previousMessages = List.from(
                                    currentMessages,
                                  );
                                }
                              }
                            },
                            child: BlocBuilder<MessageBloc, MessageState>(
                              builder: (context, state) {
                                if (state is MessagesLoading) {
                                  return Center(
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
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
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
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            context
                                                .l10n
                                                .chatOriginalMessageNotFound,
                                          ),
                                        ),
                                      );
                                    }
                                  } else {
                                    // Clean up keys cho messages không còn trong list (chỉ khi không jump)
                                    final currentMessageIds = messagesList
                                        .map((m) => m.id)
                                        .toSet();
                                    _messageKeys.removeWhere(
                                      (key, value) =>
                                          !currentMessageIds.contains(key),
                                    );

                                    // Reset loaded pages khi messages được load mới (không phải load more)
                                    // Chỉ reset khi pagination.currentPage = 1 (load lần đầu)
                                    if (state.messages.pagination.currentPage ==
                                        1) {
                                      _loadedPages.clear();
                                      _loadedPages.add(
                                        1,
                                      ); // Đánh dấu page 1 đã load
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

                                  // Preload edit logs cho tất cả tin nhắn đã load
                                  // (bao gồm cả các page cũ hơn khi scroll lên).
                                  // Hàm này tự kiểm tra cache nên sẽ không gọi trùng lặp.
                                  _preloadEditLogs(messagesList);

                                  // Khởi tạo _previousMessages lần đầu để dùng cho so sánh thay đổi.
                                  _previousMessages ??= List.from(messagesList);

                                  _isLoadingMore = false;

                                  if (messagesList.isEmpty) {
                                    return SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          ProfileHeader(
                                            isGroup: widget.isGroup,
                                            groupName: widget.groupName,
                                            groupAvatar: widget.groupAvatar,
                                            participants: widget.participants,
                                            friendInfo: widget.friendInfo,
                                          ),
                                          Center(
                                            child: Text(
                                              context
                                                  .l10n
                                                  .messageNoMessagesStartConversation,
                                              style: TextStyle(
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  return ScrollablePositionedList.builder(
                                    itemScrollController: _itemScrollController,
                                    itemPositionsListener:
                                        _itemPositionsListener,
                                    reverse:
                                        true, // Reverse để hiển thị messages mới nhất ở dưới
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.h,
                                      horizontal: 12.w,
                                    ),
                                    itemCount:
                                        messagesList.length +
                                        3, // +1 for profile, +1 for uploading, +1 for typing
                                    itemBuilder: (context, index) {
                                      // Với reverse: true, index 0 là item cuối cùng trong list (hiển thị ở dưới cùng)
                                      // index cuối là item đầu tiên trong list (hiển thị ở trên cùng)
                                      // itemCount - 1 - index sẽ là index thực tế trong list
                                      final itemCount = messagesList.length + 3;
                                      final actualIndex = itemCount - 1 - index;
                                      final pagination =
                                          state.messages.pagination;

                                      // Profile header ở actualIndex = 0 (index cuối - hiển thị ở trên cùng khi reverse)
                                      // Chỉ hiện khi không còn tin nhắn để load
                                      if (actualIndex == 0 &&
                                          !pagination.hasNextPage) {
                                        return ProfileHeader(
                                          isGroup: widget.isGroup,
                                          groupName: widget.groupName,
                                          groupAvatar: widget.groupAvatar,
                                          participants: widget.participants,
                                          friendInfo: widget.friendInfo,
                                        );
                                      }

                                      // Typing indicator ở actualIndex = itemCount - 1 (index 0 - hiển thị ở dưới cùng khi reverse)
                                      if (actualIndex == itemCount - 1) {
                                        return ChatTypingIndicator(
                                          isGroup: widget.isGroup,
                                          participants: widget.participants,
                                          friendInfo: widget.friendInfo,
                                          currentUserId: widget.userId,
                                        );
                                      }

                                      // Uploading indicator ở actualIndex = itemCount - 2
                                      if (actualIndex == itemCount - 2) {
                                        if (state.isUploadingFiles) {
                                          return _buildUploadingIndicator();
                                        }
                                        return const SizedBox.shrink();
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
                                        final message =
                                            messagesList[currentMessageIndex];

                                        // Kiểm tra xem message có bị xóa cho tôi không
                                        final isDeletedForMe =
                                            message.deletedFor?.any(
                                              (user) =>
                                                  user.userId == widget.userId,
                                            ) ??
                                            false;

                                        // Nếu bị xóa cho tôi thì không hiển thị
                                        if (isDeletedForMe) {
                                          return const SizedBox.shrink();
                                        }

                                        final fromMe =
                                            message.sender.userId ==
                                            widget.userId;

                                        // Kiểm tra xem có phải tin nhắn mới nhất không (index 0 trong list)
                                        final isLastMessage =
                                            currentMessageIndex == 0;

                                        // Tạo danh sách participants (chỉ bạn bè, không bao gồm mình)
                                        final otherParticipants =
                                            widget.friendInfo != null
                                            ? [widget.friendInfo!]
                                            : <UserEntity>[];

                                        final isHighlighted =
                                            _highlightedMessageId == message.id;

                                        // Lấy hoặc tạo GlobalKey cho message - đảm bảo chỉ tạo 1 lần
                                        final messageKey = _messageKeys
                                            .putIfAbsent(
                                              message.id,
                                              () => GlobalKey(
                                                debugLabel:
                                                    'message_${message.id}',
                                              ),
                                            );

                                        bool isFirstUnreadMessage = false;
                                        if (_firstUnreadMessageIndex != null) {
                                          isFirstUnreadMessage =
                                              _firstUnreadMessageIndex !=
                                                  null &&
                                              currentMessageIndex ==
                                                  _firstUnreadMessageIndex;
                                        }

                                        bool showAvatar = false;
                                        if (!fromMe) {
                                          MessageEntity? nextVisibleMessage;
                                          for (
                                            int i = currentMessageIndex - 1;
                                            i >= 0;
                                            i--
                                          ) {
                                            final nextMsg = messagesList[i];
                                            final isNextDeletedForMe =
                                                nextMsg.deletedFor?.any(
                                                  (user) =>
                                                      user.userId ==
                                                      widget.userId,
                                                ) ??
                                                false;
                                            if (!isNextDeletedForMe) {
                                              nextVisibleMessage = nextMsg;
                                              break;
                                            }
                                          }

                                          if (nextVisibleMessage == null) {
                                            showAvatar = true;
                                          } else {
                                            // Kiểm tra message tiếp theo có phải khác sender không
                                            if (nextVisibleMessage
                                                    .sender
                                                    .userId !=
                                                message.sender.userId) {
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
                                              messagesList[currentMessageIndex +
                                                  1];

                                          // Kiểm tra null an toàn và so sánh
                                          final difference = message.createdAt
                                              .difference(
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
                                            if (showTimeHeader)
                                              _showTimeHeader(message),

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
                                                          ? AppColors.primary
                                                                .withOpacity(
                                                                  0.15,
                                                                ) // Màu nền highlight
                                                          : Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8.r,
                                                          ),
                                                    ),

                                                    child: SwipeTo(
                                                      key: messageKey,

                                                      onRightSwipe:
                                                          ResponsiveHelper
                                                              .isWebOrDesktop
                                                          ? null
                                                          : !message
                                                                .deletedForEveryone
                                                          ? !fromMe
                                                                ? (details) {
                                                                    _setReplyMessage(
                                                                      message,
                                                                    );
                                                                  }
                                                                : null
                                                          : null,
                                                      onLeftSwipe:
                                                          ResponsiveHelper
                                                              .isWebOrDesktop
                                                          ? null
                                                          : !message
                                                                .deletedForEveryone
                                                          ? fromMe
                                                                ? (details) {
                                                                    _setReplyMessage(
                                                                      message,
                                                                    );
                                                                  }
                                                                : null
                                                          : null,

                                                      iconOnRightSwipe:
                                                          Icons.reply,
                                                      iconOnLeftSwipe:
                                                          Icons.reply,

                                                      // Màu sắc icon
                                                      iconColor: AppColors
                                                          .textSecondary,

                                                      child: MessageItem(
                                                        message: message,
                                                        fromMe: fromMe,
                                                        showAvatar: showAvatar,
                                                        onReplyTap: (replyId) =>
                                                            _jumpToMessage(
                                                              replyId,
                                                            ),
                                                        isLastMessage:
                                                            isLastMessage,
                                                        currentUserId:
                                                            widget.userId,
                                                        otherParticipants:
                                                            otherParticipants,
                                                        onLongPress: () {
                                                          if (!message
                                                              .deletedForEveryone) {
                                                            if (ResponsiveHelper
                                                                .isWebOrDesktop) {
                                                              _showMoreOptionsDialog(
                                                                message,
                                                                fromMe,
                                                              );
                                                            } else {
                                                              _handleMessageLongPress(
                                                                message,
                                                                fromMe,
                                                              );
                                                            }
                                                          }
                                                        },
                                                        onReactAction: () {
                                                          if (!message
                                                              .deletedForEveryone) {
                                                            final messageKey =
                                                                _messageKeys[message
                                                                    .id];
                                                            if (messageKey !=
                                                                null) {
                                                              MessageActionSheet.show(
                                                                context:
                                                                    context,
                                                                message:
                                                                    message,
                                                                fromMe: fromMe,
                                                                messageKey:
                                                                    messageKey,
                                                                showOnlyReactions:
                                                                    true,
                                                                onReactionSelected:
                                                                    (emoji) {
                                                                      _handleReactionSelected(
                                                                        message,
                                                                        emoji,
                                                                      );
                                                                    },
                                                                onReply: () {},
                                                                onCopy: null,
                                                                onDelete: null,
                                                                onMore: null,
                                                              );
                                                            }
                                                          }
                                                        },
                                                        onReplyAction: () {
                                                          if (!message
                                                              .deletedForEveryone) {
                                                            _setReplyMessage(
                                                              message,
                                                            );
                                                          }
                                                        },
                                                        onDoubleTap: () {
                                                          if (!message
                                                              .deletedForEveryone) {
                                                            _handleReactionSelected(
                                                              message,
                                                              EmojiType.love,
                                                            );
                                                          }
                                                        },
                                                        onEditHistoryTap:
                                                            message.isEdited
                                                            ? () =>
                                                                  _showEditHistory(
                                                                    message,
                                                                  )
                                                            : null,
                                                        onCallAgain:
                                                            message.metadata !=
                                                                    null &&
                                                                message
                                                                        .metadata!
                                                                        .callStatus ==
                                                                    'completed'
                                                            ? () {
                                                                // Convert metadata type to call type
                                                                final callType =
                                                                    message
                                                                            .metadata!
                                                                            .type ==
                                                                        'video_call'
                                                                    ? 'video'
                                                                    : 'audio';
                                                                _initiateCall(
                                                                  callType,
                                                                );
                                                              }
                                                            : null,
                                                        isFirstUnreadMessage:
                                                            isFirstUnreadMessage,
                                                        unreadCount:
                                                            _unreadCount,
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
                                      ProfileHeader(
                                        isGroup: widget.isGroup,
                                        groupName: widget.groupName,
                                        groupAvatar: widget.groupAvatar,
                                        participants: widget.participants,
                                        friendInfo: widget.friendInfo,
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                context.l10n
                                                    .chatLoadMessagesFailed(
                                                      state.message,
                                                    ),
                                                style: const TextStyle(
                                                  color: Colors.red,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 16),
                                              ElevatedButton(
                                                onPressed: () {
                                                  final conversationId =
                                                      _currentConversationId ??
                                                      widget.conversationId;
                                                  if (conversationId != null) {
                                                    context
                                                        .read<MessageBloc>()
                                                        .add(
                                                          LoadMessagesEvent(
                                                            userId:
                                                                widget.userId,
                                                            conversationId:
                                                                conversationId,
                                                          ),
                                                        );
                                                  }
                                                },
                                                child: Text(
                                                  context.l10n.commonRetry,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }

                                // Default state - show profile info only
                                return ProfileHeader(
                                  isGroup: widget.isGroup,
                                  groupName: widget.groupName,
                                  groupAvatar: widget.groupAvatar,
                                  participants: widget.participants,
                                  friendInfo: widget.friendInfo,
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 20.h,
                        right: 16.w,
                        child: ScrollToBottomButton(
                          show: _showScrollButton,
                          onPressed: _scrollToBottom,
                        ),
                      ),

                      if (_showAttachmentMenu)
                        Positioned(
                          bottom: 0,
                          left: 10.w,
                          child: AttachmentMenuWidget(
                            onClose: () {
                              setState(() {
                                _showAttachmentMenu = false;
                              });
                            },
                            onShareLocation: _shareCurrentLocation,
                            onShareFile: _shareFile,
                            onPickGiphy: _pickGiphySticker,
                          ),
                        ),
                    ],
                  ),
                ),
                _buildInputArea(),
              ],
            ),
          ),
        ),
      ),
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

  Widget _buildUploadingIndicator() {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 16.w,
                  height: 16.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  context.l10n.chatSendingFile,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    if (_isRecording) {
      return VoiceRecordingWidget(
        onSend: _stopAndSendRecording,
        onCancel: _cancelRecording,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_replyingMessage != null) _buildReplyPreview(),
        if (_editMessage != null) _buildEditPreview(),
        if (_capturedPhotoPath != null) _buildCapturedPhotoPreview(),

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
              // Mũi tên bên trái (chỉ hiện khi input expanded)
              if (_isInputExpanded)
                IconButton(
                  icon: Icon(
                    CupertinoIcons.chevron_right,
                    color: AppColors.primary,
                    size: 24.sp,
                  ),
                  onPressed: _collapseInput,
                ),

              // Các icon chỉ hiện khi input chưa expanded
              if (!_isInputExpanded) ...[
                IconButton(
                  icon: Icon(
                    _showAttachmentMenu
                        ? CupertinoIcons.xmark_circle_fill
                        : CupertinoIcons.plus_circle_fill,
                    color: AppColors.primary,
                    size: 24.sp,
                  ),
                  onPressed: () {
                    setState(() {
                      _showAttachmentMenu = !_showAttachmentMenu;
                      if (_showAttachmentMenu) {
                        _focusNode.unfocus();
                        _showPhotoPicker = false;
                      }
                    });
                  },
                ),
                if (!ResponsiveHelper.isWebOrDesktop)
                  IconButton(
                    icon: Icon(
                      CupertinoIcons.camera_fill,
                      color: AppColors.primary,
                      size: 24.sp,
                    ),
                    onPressed: _openCamera,
                  ),
                IconButton(
                  icon: Icon(
                    CupertinoIcons.photo_fill,
                    color: AppColors.primary,
                    size: 24.sp,
                  ),
                  onPressed: () async {
                    if (ResponsiveHelper.isWebOrDesktop) {
                      try {
                        final result = await FilePicker.pickFiles(
                          allowMultiple: true,
                          type: FileType.image,
                        );

                        if (result != null && result.paths.isNotEmpty) {
                          final filePaths = result.paths
                              .whereType<String>()
                              .toList();
                          if (filePaths.isEmpty) return;

                          final conversationId =
                              _currentConversationId ?? widget.conversationId;
                          if (conversationId == null) return;

                          _typingDebounceTimer?.cancel();
                          final messageBloc = context.read<MessageBloc>();
                          messageBloc.emitTypingStop(
                            widget.userId,
                            conversationId,
                          );

                          messageBloc.add(
                            SendMessageWithFilesEvent(
                              userId: widget.userId,
                              conversationId: conversationId,
                              filePaths: filePaths,
                              replyTo: _replyingMessage?.id,
                            ),
                          );
                          _clearReplyMessage();
                          _scrollToBottom();
                        }
                      } catch (e) {
                        print('Error picking image on web: $e');
                      }
                    } else {
                      if (!_showPhotoPicker) {
                        // Mở photo picker - request permission và load ảnh
                        await _requestPhotoPermissionAndLoad();
                      } else {
                        // Đóng photo picker
                        setState(() {
                          _showPhotoPicker = false;
                        });
                      }
                    }
                  },
                ),

                IconButton(
                  icon: Icon(
                    CupertinoIcons.mic_fill,
                    color: AppColors.primary,
                    size: 24.sp,
                  ),
                  onPressed: _startRecording,
                ),
              ],

              Expanded(
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: _isInputExpanded ? 120.h : 50.h,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Focus(
                    onKeyEvent: (node, event) {
                      if (ResponsiveHelper.isWebOrDesktop &&
                          event is KeyDownEvent &&
                          event.logicalKey == LogicalKeyboardKey.enter &&
                          !HardwareKeyboard.instance.isShiftPressed) {
                        _sendMessage();
                        return KeyEventResult.handled;
                      }
                      return KeyEventResult.ignored;
                    },
                    child: TextField(
                      controller: _messageController,
                      focusNode: _focusNode,
                      cursorColor: AppColors.primary,
                      onChanged: _onTextChanged,
                      onTap: () {
                        // Toggle expansion khi ấn vào TextField
                        _toggleInputExpansion();

                        // Scroll sau khi keyboard animation hoàn thành
                        Future.delayed(const Duration(milliseconds: 350), () {
                          if (mounted) {
                            _scrollToBottom();
                          }
                        });
                      },
                      maxLines: _isInputExpanded ? null : 1,
                      minLines: 1,
                      textInputAction: TextInputAction.newline,
                      keyboardType: _isInputExpanded
                          ? TextInputType.multiline
                          : TextInputType.text,
                      decoration: InputDecoration(
                        hintText: context.l10n.chatMessageHint,
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 8.h,
                        ),
                        isDense: true,
                      ),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textPrimary,
                      ),
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

        if (_showPhotoPicker) _buildPhotoPicker(),
      ],
    );
  }

  Widget _buildReplyPreview() {
    final replyText = _replyingMessage!.text?.isNotEmpty == true
        ? _replyingMessage!.text!
        : (_replyingMessage!.attachments.isNotEmpty
              ? _getAttachmentTypeString(
                  _replyingMessage!.attachments.first.type,
                )
              : context.l10n.chatMessagePlaceholder);

    final isReplyingToMe = _replyingMessage!.sender.userId == widget.userId;

    String name;
    if (isReplyingToMe) {
      // Trường hợp trả lời chính mình
      name = context.l10n.chatMyself;
    } else {
      // Trả lời người khác, lấy chữ cái cuối của tên
      final fullName =
          _replyingMessage!.sender.fullName ?? context.l10n.commonUnknown;
      final parts = fullName.split(' ');
      name = parts.isNotEmpty ? parts.last : context.l10n.commonUnknown;
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
                  context.l10n.chatReplyingTo(name),
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

          _replyingMessage!.attachments.isNotEmpty
              ? _buildReplyAttachmentPreview(
                  _replyingMessage!.attachments.first,
                )
              : SizedBox.shrink(),
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

  String _getAttachmentTypeString(String type) {
    if (type == AttachmentType.audio.name) return context.l10n.chatAudioMessage;
    if (type == AttachmentType.image.name) return context.l10n.chatPhoto;
    if (type == AttachmentType.video.name) return context.l10n.postVideo;
    if (type == AttachmentType.file.name) return context.l10n.chatFile;
    return context.l10n.chatAttachment;
  }

  Widget _buildReplyAttachmentPreview(AttachmentEntity attachment) {
    final type = attachment.type;
    if (type == AttachmentType.image.name) {
      return Image.network(
        attachment.url,
        width: 30.w,
        height: 40.h,
        fit: BoxFit.cover,
      );
    } else if (type == AttachmentType.video.name) {
      return SizedBox(
        width: 30.w,
        height: 40.h,
        child: buildVideoThumbnail(attachment.url, height: 40.h),
      );
    } else if (type == AttachmentType.file.name) {
      return Container(
        width: 30.w,
        height: 40.h,
        color: AppColors.textSecondary.withOpacity(0.1),
        child: Icon(
          Icons.insert_drive_file,
          size: 16.sp,
          color: AppColors.primary,
        ),
      );
    }
    return SizedBox.shrink();
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

  Future<void> _requestPhotoPermissionAndLoad() async {
    PermissionStatus status;

    if (Platform.isIOS) {
      // iOS dùng quyền photos
      status = await Permission.photos.request();
    } else {
      // Android
      if (Platform.isAndroid) {
        // Android 13 (SDK 33+) trở lên có quyền riêng cho ảnh
        if (await Permission.photos.isGranted ||
            await Permission.photos.request().isGranted) {
          status = PermissionStatus.granted;
        } else {
          // Dự phòng cho các bản Android cũ hơn
          status = await Permission.storage.request();
        }
      } else {
        status = await Permission.storage.request();
      }
    }

    if (status.isGranted) {
      _focusNode.unfocus();
      await Future.delayed(const Duration(milliseconds: 300));

      setState(() {
        _showPhotoPicker = true;
        _isLoadingPhotos = true;
        _photoPickerHeight = _getPhotoPickerMinHeight();
      });
      await _loadPhotos();
    } else if (status.isPermanentlyDenied) {
      // Hiển thị dialog yêu cầu mở settings
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text(context.l10n.chatPhotoPermissionTitle),
            content: Text(context.l10n.chatPhotoPermissionMessage),
            actions: [
              CupertinoDialogAction(
                child: Text(context.l10n.commonCancel),
                onPressed: () => Navigator.pop(context),
              ),
              CupertinoDialogAction(
                child: Text(context.l10n.commonOpenSettings),
                onPressed: () {
                  Navigator.pop(context);
                  openAppSettings();
                },
              ),
            ],
          ),
        );
      }
    } else {
      if (mounted) {
        showInfoSnackBar(context, context.l10n.chatPhotoPermissionRequired);
      }
    }
  }

  Future<void> _loadPhotos() async {
    try {
      // Lấy album "Tất cả ảnh"
      final albums = await PhotoManager.getAssetPathList(
        type: RequestType.common, // bao gồm cả ảnh và video
        onlyAll: true,
        filterOption: FilterOptionGroup(
          orders: [
            OrderOption(
              type: OrderOptionType.updateDate,
              asc: false, // Load ảnh mới nhất trước
            ),
          ],
        ),
      );

      if (albums.isEmpty) {
        setState(() {
          _isLoadingPhotos = false;
          _hasMorePhotos = false;
        });
        return;
      }

      final recent = albums.first;
      // Load 50 ảnh đầu tiên (từ mới nhất)
      final media = await recent.getAssetListPaged(
        page: _currentPhotoPage,
        size: _photosPerPage,
      );

      setState(() {
        _photoList = media;
        _isLoadingPhotos = false;
        _currentPhotoPage = 0;
        _hasMorePhotos = media.length == _photosPerPage;
        _selectedPhotos.clear(); // Clear selection khi load lại
      });
    } catch (e) {
      print('Error loading photos: $e');
      if (mounted) {
        setState(() {
          _isLoadingPhotos = false;
          _hasMorePhotos = false;
        });
        showErrorSnackBar(context, context.l10n.chatLoadPhotosFailed('$e'));
      }
    }
  }

  Future<void> _loadMorePhotos() async {
    if (_isLoadingMorePhotos || !_hasMorePhotos) return;

    setState(() {
      _isLoadingMorePhotos = true;
    });

    try {
      final albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        onlyAll: true,
        filterOption: FilterOptionGroup(
          orders: [
            OrderOption(
              type: OrderOptionType.updateDate,
              asc: false, // Load ảnh mới nhất trước
            ),
          ],
        ),
      );

      if (albums.isEmpty) {
        setState(() {
          _isLoadingMorePhotos = false;
          _hasMorePhotos = false;
        });
        return;
      }

      final recent = albums.first;
      final nextPage = _currentPhotoPage + 1;
      final media = await recent.getAssetListPaged(
        page: nextPage,
        size: _photosPerPage,
      );

      if (mounted) {
        setState(() {
          _photoList.addAll(media);
          _currentPhotoPage = nextPage;
          _isLoadingMorePhotos = false;
          _hasMorePhotos = media.length == _photosPerPage;
        });
      }
    } catch (e) {
      print('Error loading more photos: $e');
      if (mounted) {
        setState(() {
          _isLoadingMorePhotos = false;
          _hasMorePhotos = false;
        });
      }
    }
  }

  Future<Uint8List?> _getCachedThumbnail(
    AssetEntity asset,
    ThumbnailSize size,
  ) async {
    final cacheKey = '${asset.id}_${size.width}_${size.height}';

    if (_thumbnailCache.containsKey(cacheKey)) {
      return _thumbnailCache[cacheKey];
    }

    final thumbnail = await asset.thumbnailDataWithSize(size);
    if (thumbnail != null) {
      _thumbnailCache[cacheKey] = thumbnail;
    }
    return thumbnail;
  }

  void _togglePhotoSelection(AssetEntity asset) {
    setState(() {
      if (_selectedPhotos.contains(asset)) {
        _selectedPhotos.remove(asset);
      } else {
        _selectedPhotos.add(asset);
      }
    });
  }

  int _getPhotoIndex(AssetEntity asset) {
    return _selectedPhotos.indexOf(asset) + 1;
  }

  bool _isPhotoSelected(AssetEntity asset) {
    return _selectedPhotos.contains(asset);
  }

  Future<void> _openCamera() async {
    try {
      // Check camera permissions first
      final hasPermissions = await CameraHelper.requestCameraPermissions();

      if (!hasPermissions) {
        if (mounted) {
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: Text(context.l10n.postCameraPermissionTitle),
              content: Text(context.l10n.chatCameraPermissionMessage),
              actions: [
                CupertinoDialogAction(
                  child: Text(context.l10n.commonCancel),
                  onPressed: () => Navigator.pop(context),
                ),
                CupertinoDialogAction(
                  child: Text(context.l10n.commonOpenSettings),
                  onPressed: () {
                    Navigator.pop(context);
                    openAppSettings();
                  },
                ),
              ],
            ),
          );
        }
        return;
      }

      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CameraScreen()),
      );

      if (result != null && result is Map<String, dynamic>) {
        // Handle camera result - only handle photos for now
        if (result['type'] == 'photo' && result['path'] != null) {
          setState(() {
            _capturedPhotoPath = result['path'] as String;
          });
        }
      }
    } catch (e) {
      print('Error opening camera: $e');
      if (mounted) {
        showErrorSnackBar(context, context.l10n.chatOpenCameraFailed('$e'));
      }
    }
  }

  Widget _buildCapturedPhotoPreview() {
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
          // Preview image
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.file(
              File(_capturedPhotoPath!),
              width: 60.w,
              height: 60.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.chatCapturedPhoto,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  context.l10n.chatTapSendToShare,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Send button
          GestureDetector(
            onTap: _sendCapturedPhoto,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    CupertinoIcons.paperplane_fill,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    context.l10n.commonSend,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8.w),
          // Cancel button
          GestureDetector(
            onTap: () {
              setState(() {
                _capturedPhotoPath = null;
              });
            },
            child: Padding(
              padding: EdgeInsets.only(left: 4.w, top: 4.h),
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

  Future<void> _sendCapturedPhoto() async {
    if (_capturedPhotoPath == null) return;

    try {
      final conversationId = _currentConversationId ?? widget.conversationId;
      if (conversationId == null) {
        showErrorSnackBar(
          context,
          context.l10n.chatMissingConversationForPhoto,
        );
        return;
      }

      // Stop typing when sending message
      _typingDebounceTimer?.cancel();
      final messageBloc = context.read<MessageBloc>();
      messageBloc.emitTypingStop(widget.userId, conversationId);

      // Send message with file via HTTP (MultipartFile)
      messageBloc.add(
        SendMessageWithFilesEvent(
          userId: widget.userId,
          conversationId: conversationId,
          filePaths: [_capturedPhotoPath!],
          replyTo: _replyingMessage?.id,
        ),
      );

      // Scroll to bottom after sending
      _scrollToBottom();

      // Clear captured photo after sending
      setState(() {
        _capturedPhotoPath = null;
        _replyingMessage = null; // Clear reply if any
      });
    } catch (e) {
      print('Error sending captured photo: $e');
      if (mounted) {
        showErrorSnackBar(context, context.l10n.chatSendPhotoFailed('$e'));
      }
    }
  }

  Future<void> _sendSelectedPhotos() async {
    if (_selectedPhotos.isEmpty) return;

    try {
      final conversationId = _currentConversationId ?? widget.conversationId;
      if (conversationId == null) {
        showErrorSnackBar(
          context,
          context.l10n.chatMissingConversationForPhoto,
        );

        return;
      }

      // Get file paths from selected photos
      final List<String> filePaths = [];

      for (final asset in _selectedPhotos) {
        try {
          // Get file from asset
          final file = await asset.file;
          if (file == null) continue;

          // Add file path
          filePaths.add(file.path);
        } catch (e) {
          print('Error getting file path from asset: $e');
          // Continue with other photos
        }
      }

      if (filePaths.isEmpty) {
        if (mounted) {
          showErrorSnackBar(context, context.l10n.chatCannotProcessPhoto);
        }
        return;
      }

      // Stop typing when sending message
      _typingDebounceTimer?.cancel();
      final messageBloc = context.read<MessageBloc>();
      messageBloc.emitTypingStop(widget.userId, conversationId);

      // Send message with files via HTTP (MultipartFile)
      messageBloc.add(
        SendMessageWithFilesEvent(
          userId: widget.userId,
          conversationId: conversationId,
          filePaths: filePaths,
        ),
      );

      // Scroll to bottom after sending
      _scrollToBottom();

      // Đóng photo picker sau khi gửi
      setState(() {
        _showPhotoPicker = false;
        _selectedPhotos.clear();
      });
    } catch (e) {
      print('Error sending photos: $e');
      if (mounted) {
        showErrorSnackBar(context, context.l10n.chatSendPhotoFailed('$e'));
      }
    }
  }

  Future<void> _shareFile() async {
    try {
      final result = await FilePicker.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );

      if (result != null && result.paths.isNotEmpty) {
        final filePaths = result.paths.whereType<String>().toList();

        if (filePaths.isEmpty) return;

        final conversationId = _currentConversationId ?? widget.conversationId;
        if (conversationId == null) {
          if (mounted) {
            showErrorSnackBar(
              context,
              context.l10n.chatMissingConversationForFile,
            );
          }
          return;
        }

        // Stop typing when sending message
        _typingDebounceTimer?.cancel();
        final messageBloc = context.read<MessageBloc>();
        messageBloc.emitTypingStop(widget.userId, conversationId);

        // Send message with files via HTTP
        messageBloc.add(
          SendMessageWithFilesEvent(
            userId: widget.userId,
            conversationId: conversationId,
            filePaths: filePaths,
            replyTo: _replyingMessage?.id,
          ),
        );

        // Scroll to bottom after sending
        _scrollToBottom();

        setState(() {
          _showAttachmentMenu = false;
          _replyingMessage = null; // Clear reply if any
        });
      }
    } catch (e) {
      print('Error picking file: $e');
      if (mounted) {
        showErrorSnackBar(context, context.l10n.chatPickFileFailed('$e'));
      }
    }
  }

  Widget _buildPhotoPicker() {
    final minHeight = _getPhotoPickerMinHeight();
    final maxHeight = _getPhotoPickerMaxHeight();

    return GestureDetector(
      onVerticalDragUpdate: (details) {
        // Kéo lên/xuống để thay đổi height
        setState(() {
          _photoPickerHeight = (_photoPickerHeight - details.delta.dy).clamp(
            minHeight,
            maxHeight,
          );
        });
      },
      onVerticalDragEnd: (details) {
        // Snap về min hoặc max khi thả
        final velocity = details.primaryVelocity ?? 0;
        setState(() {
          if (velocity > 500) {
            // Kéo xuống nhanh -> đóng
            _photoPickerHeight = 0;
            _showPhotoPicker = false;
          } else if (velocity < -500) {
            // Kéo lên nhanh -> mở rộng
            _photoPickerHeight = maxHeight;
          } else {
            // Kéo chậm -> snap về gần nhất
            if (_photoPickerHeight < (minHeight + maxHeight) / 2) {
              _photoPickerHeight = minHeight;
            } else {
              _photoPickerHeight = maxHeight;
            }
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        height: _photoPickerHeight,
        constraints: BoxConstraints(maxHeight: _getPhotoPickerMaxHeight()),
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border(
            top: BorderSide(color: AppColors.textSecondary.withOpacity(0.2)),
          ),
        ),
        child: Column(
          children: [
            // Handle bar để kéo
            GestureDetector(
              onTap: () {
                setState(() {
                  final minHeight = _getPhotoPickerMinHeight();
                  final maxHeight = _getPhotoPickerMaxHeight();
                  if (_photoPickerHeight == minHeight) {
                    _photoPickerHeight = maxHeight;
                  } else {
                    _photoPickerHeight = minHeight;
                  }
                });
              },
              child: Container(
                margin: EdgeInsets.only(top: 8.h, bottom: 8.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),

            // Header với nút gửi nếu có ảnh được chọn
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.photo_on_rectangle,
                    color: AppColors.primary,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Tất cả ảnh',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  if (_selectedPhotos.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _sendSelectedPhotos();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Text(
                          context.l10n.commonSendWithCount(
                            _selectedPhotos.length,
                          ),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _photoPickerHeight = 0;
                          _showPhotoPicker = false;
                        });
                      },
                      child: Icon(
                        CupertinoIcons.chevron_down,
                        color: AppColors.textSecondary,
                        size: 16.sp,
                      ),
                    ),
                ],
              ),
            ),

            // Grid ảnh
            Flexible(
              child: _isLoadingPhotos
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
                  : _photoList.isEmpty
                  ? Center(
                      child: Text(
                        context.l10n.chatNoPhotos,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14.sp,
                        ),
                      ),
                    )
                  : NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification is ScrollUpdateNotification) {
                          _onPhotoPickerScroll(_photoPickerScrollController);
                        }
                        return false;
                      },
                      child: GridView.builder(
                        controller: _photoPickerScrollController,
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 4.w,
                          mainAxisSpacing: 4.h,
                        ),
                        itemCount:
                            _photoList.length + (_isLoadingMorePhotos ? 1 : 0),
                        itemBuilder: (context, index) {
                          // Loading indicator ở cuối
                          if (index == _photoList.length) {
                            return Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary,
                              ),
                            );
                          }

                          final asset = _photoList[index];
                          return GridImageItem(
                            key: ValueKey(asset.id),
                            asset: asset,
                            isSelected: _isPhotoSelected(asset),
                            selectedIndex: _isPhotoSelected(asset)
                                ? _getPhotoIndex(asset)
                                : 0,
                            onTap: () => _togglePhotoSelection(asset),
                            getCachedThumbnail: _getCachedThumbnail,
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiSummaryBanner() {
    final primaryColor = AppColors.primary;
    final isDark = s1<AppPreferences>().isDarkMode;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(isDark ? 0.15 : 0.08),
            primaryColor.withOpacity(isDark ? 0.08 : 0.03),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: primaryColor.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // AI Icon
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.auto_awesome, color: primaryColor, size: 20.r),
          ),
          SizedBox(width: 12.w),
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.chatAiSummaryTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  context.l10n.messageUnreadCount(_unreadCount ?? 0),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          // Action Buttons
          TextButton(
            onPressed: () {
              final conversationId =
                  _currentConversationId ?? widget.conversationId;
              if (conversationId != null) {
                _showAiSummaryBottomSheet(context, conversationId);
              } else {
                showInfoSnackBar(
                  context,
                  context.l10n.chatCannotIdentifyConversation,
                );
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            child: Text(
              context.l10n.chatSummaryButton,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, size: 18.r, color: AppColors.textSecondary),
            onPressed: () {
              setState(() {
                _showSummaryBanner = false;
              });
            },
          ),
        ],
      ),
    );
  }

  void _showAiSummaryBottomSheet(BuildContext context, String conversationId) {
    final primaryColor = AppColors.primary;

    Future<DataState<String>> fetchSummary(BuildContext ctx) {
      return s1<GetSummaryUnreadUseCase>().call(
        params: GetSummaryUnreadParams(
          conversationId: conversationId,
          messages: _unreadMessageTexts,
          lang: appTranslationTargetLang(ctx),
        ),
      );
    }

    Future<DataState<String>>? summaryFuture;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        summaryFuture ??= fetchSummary(context);

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              padding: EdgeInsets.only(
                top: 12.h,
                left: 20.w,
                right: 20.w,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Pull bar
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Header
                  Row(
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [primaryColor, primaryColor.withOpacity(0.7)],
                        ).createShader(bounds),
                        child: Icon(
                          Icons.auto_awesome,
                          color: Colors.white,
                          size: 24.r,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        context.l10n.chatAiSummaryTitle,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  SizedBox(height: 16.h),

                  // Future Builder to fetch summary
                  FutureBuilder<DataState<String>>(
                    future: summaryFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.h),
                          child: Column(
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  primaryColor,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                context.l10n.chatAiAnalyzingUnread,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: AppColors.textSecondary,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return _buildErrorState(
                          snapshot.error.toString(),
                          conversationId,
                          onRetry: () => setModalState(() {
                            summaryFuture = fetchSummary(context);
                          }),
                        );
                      }

                      final dataState = snapshot.data;
                      if (dataState is DataStateError) {
                        return _buildErrorState(
                          dataState?.error?.message ??
                              context.l10n.commonServerErrorRetryLater,
                          conversationId,
                          onRetry: () => setModalState(() {
                            summaryFuture = fetchSummary(context);
                          }),
                        );
                      }

                      final summary =
                          dataState?.data ??
                          context.l10n.chatNoSummaryAvailable;

                      return Container(
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: AppColors.secondBackground,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              summary,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.textPrimary,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 16.h),

                  // Bottom Action Button
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      context.l10n.commonClose,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildErrorState(
    String errorMsg,
    String conversationId, {
    VoidCallback? onRetry,
  }) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: Colors.red[400], size: 32.r),
          SizedBox(height: 8.h),
          Text(
            context.l10n.chatFailedToLoadSummary,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            errorMsg,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
          ),
          SizedBox(height: 12.h),
          TextButton.icon(
            onPressed: () {
              if (onRetry != null) {
                onRetry();
              } else {
                setState(() {});
              }
            },
            icon: Icon(Icons.refresh, size: 16.r, color: AppColors.primary),
            label: Text(
              context.l10n.commonRetry,
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
