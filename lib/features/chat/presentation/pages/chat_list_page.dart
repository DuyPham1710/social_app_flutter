import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/date_time_extensions.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/chat/presentation/bloc/conversation/conversation_bloc.dart';
import 'package:social_app_fe/features/chat/presentation/bloc/conversation/conversation_event.dart';
import 'package:social_app_fe/features/chat/presentation/bloc/conversation/conversation_state.dart';
import 'package:social_app_fe/features/chat/presentation/helper/chat_helper.dart';
import 'package:social_app_fe/features/chat/presentation/pages/chat_detail_page.dart';
import 'package:social_app_fe/features/chat/presentation/pages/chat_search_page.dart';
import 'package:social_app_fe/features/chat/presentation/pages/create_group_chat_page.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/conversation_item.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/conversations_loading_widget.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/list_friend_loading.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/story_chat_item_widget.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/friend_message_suggestion_item.dart';
import 'package:social_app_fe/features/friend/domain/entities/friend_entity.dart';
import 'package:social_app_fe/features/friend/presentation/bloc/friend_bloc.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/features/chat/presentation/bloc/message/message_bloc.dart';
import 'package:social_app_fe/features/chat/presentation/bloc/message/message_event.dart';
import 'package:social_app_fe/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:social_app_fe/features/menu/presentation/bloc/menu_state.dart';
import 'package:social_app_fe/features/story/presentation/pages/story_create_page.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/core/network/websocket/socket_client.dart';
import 'package:social_app_fe/features/chat/data/services/chat_presence_service.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class ChatListPage extends StatefulWidget {
  final bool isWebLayout;
  final Function(Map<String, dynamic>)? onConversationSelected;

  const ChatListPage({
    super.key,
    this.isWebLayout = false,
    this.onConversationSelected,
  });

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  String? userId;
  String? username;
  late MessageBloc messageBloc;

  late final ConversationBloc _conversationBloc;
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  bool _isSearching = false;

  SocketClient? _presenceSocketClient;
  ChatPresenceService? _chatPresenceService;
  StreamSubscription<Map<String, ChatPresenceStatus>>? _presenceSub;
  Map<String, ChatPresenceStatus> _presenceByUserId = {};
  final Set<String> _presenceRequestedUserIds = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Lấy bloc 1 lần, khi context còn sống
    _conversationBloc = context.read<ConversationBloc>();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    _setupScrollListener();
  }

  // này là đang cho rời khỏi trang chat list thì leave tất cả conversation (sẽ không nhận đc update nữa)
  @override
  void dispose() {
    _scrollController.dispose();
    _leaveAllConversations();
    _presenceSub?.cancel();
    _chatPresenceService?.dispose();
    super.dispose();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      // Kiểm tra xem đã scroll gần đến cuối chưa (còn 200px)
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _loadMoreConversations();
      }
    });
  }

  void _loadMoreConversations() {
    // Tránh load trùng
    if (_isLoadingMore || userId == null) return;

    final state = _conversationBloc.state;
    if (state is ConversationsLoaded) {
      final pagination = state.conversations.pagination;

      // Chỉ load nếu còn page tiếp theo
      if (pagination.hasNextPage) {
        setState(() {
          _isLoadingMore = true;
        });

        _conversationBloc.add(
          LoadConversationsEvent(
            userId: userId!,
            page: pagination.currentPage + 1,
            limit: pagination.itemsPerPage,
          ),
        );
      }
    }
  }

  Future<void> _loadData() async {
    await _loadUserInfo();
    if (userId != null) {
      _initPresence();
      _loadFriends();
      await _loadConversations();
    }
  }

  void _initPresence() {
    if (userId == null || username == null) return;
    _presenceSocketClient ??= s1<SocketClient>(instanceName: 'chatSocket');
    _chatPresenceService ??= ChatPresenceService(_presenceSocketClient!);
    _chatPresenceService!.connect(userId: userId!, username: username!);

    _presenceSub?.cancel();
    _presenceSub = _chatPresenceService!.presenceStream.listen((map) {
      if (!mounted) return;
      setState(() {
        _presenceByUserId = map;
      });
    });
  }

  Future<void> _loadUserInfo() async {
    final userData = await TokenStorage.getUserData();
    userId = userData?['id'];
    username = userData?['username'];
  }

  Future<void> _loadConversations() async {
    if (userId == null) return;
    context.read<ConversationBloc>().add(
      LoadConversationsEvent(userId: userId!, page: 1, limit: 10),
    );
  }

  void _loadFriends() {
    context.read<FriendBloc>().add(LoadFriends());
  }

  void _leaveAllConversations() {
    final chatState = _conversationBloc.state;

    if (chatState is ConversationsLoaded) {
      final conversations = chatState.conversations.data;

      // Leave tất cả conversations
      if (userId != null) {
        for (final conversation in conversations) {
          _conversationBloc.add(
            LeaveConversationEvent(
              conversationId: conversation.id,
              userId: userId!,
            ),
          );
        }
      }

      print(
        'Left ${conversations.length} conversations when exiting chat list page',
      );
    }
  }

  Future<void> _joinConversationAndNavigate(
    String conversationId,
    UserEntity friendInfo,
    int unreadCount,
    int? firstUnreadMessageIndex, {
    bool isGroup = false,
    String? groupName,
    String? groupAvatar,
    List<UserEntity>? participants,
  }) async {
    if (userId == null) {
      showErrorSnackBar(context, context.l10n.chatUserNotFound);

      return;
    }

    // Luôn khởi tạo messageBloc
    messageBloc = s1<MessageBloc>();

    if (unreadCount > 0) {
      // Mark all messages as read when navigating to chat detail (without messageId)
      // This will mark all unread messages in the conversation as read
      messageBloc.add(
        MarkAsReadEvent(
          userId: userId!,
          conversationId: conversationId,
          // messageId is null to mark all messages as read
        ),
      );
    }

    if (widget.isWebLayout) {
      widget.onConversationSelected?.call({
        'userId': userId!,
        'username': username!,
        'conversationId': conversationId,
        'friendInfo': friendInfo,
        'unreadCount': unreadCount,
        'firstUnreadMessageIndex': firstUnreadMessageIndex,
        'isGroup': isGroup,
        'groupName': groupName,
        'groupAvatar': groupAvatar,
        'participants': participants,
        'messageBloc': messageBloc,
      });
    } else {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => messageBloc,
            child: ChatDetailPage(
              userId: userId!,
              username: username!,
              conversationId: conversationId,
              friendInfo: friendInfo,
              unreadCount: unreadCount,
              firstUnreadMessageIndex: firstUnreadMessageIndex,
              isGroup: isGroup,
              groupName: groupName,
              groupAvatar: groupAvatar,
              participants: participants,
            ),
          ),
        ),
      );
    }
  }

  /// Find existing 1-1 conversation with a friend
  /// Returns conversationId if found, null if not found
  Future<Map<String, int>?> _findConversationWithFriend(String friendId) async {
    final chatState = context.read<ConversationBloc>().state;
    final userData = await TokenStorage.getUserData();
    final currentUserId = userData?['id'];

    if (chatState is ConversationsLoaded && currentUserId != null) {
      final conversations = chatState.conversations.data;

      // Look for 1-1 conversation (not group) that includes both current user and friend
      for (final conversation in conversations) {
        if (!conversation.isGroup && conversation.participants.length == 2) {
          final participantIds = conversation.participants
              .map((p) => p.userId)
              .toList();

          // Check if conversation contains both current user and the friend
          final hasCurrentUser = participantIds.contains(currentUserId);
          final hasThisFriend = participantIds.contains(friendId);

          if (hasCurrentUser && hasThisFriend) {
            return {
              conversation.id: conversation.unreadCount ?? 0,
              "firstUnreadMessageIndex":
                  conversation.firstUnreadMessageIndex ?? -1,
            };
          }
        }
      }
    }

    return null; // No existing conversation found
  }

  /// Handle tap on friend (story or suggestion)
  /// Check if conversation exists, if yes join it, if no create new one
  Future<void> _handleFriendTap(FriendEntity friend) async {
    if (userId == null) {
      showErrorSnackBar(context, context.l10n.chatUserNotFound);

      return;
    }

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );

      final existingConversation = await _findConversationWithFriend(
        friend.userId,
      );

      // Hide loading indicator
      Navigator.of(context).pop();

      UserEntity friendInfo = UserEntity(
        userId: friend.userId,
        username: friend.username,
        fullName: friend.fullName,
        avatarUrl: friend.avatarUrl,
      );

      if (existingConversation != null) {
        final existingConversationId = existingConversation.keys.first;
        final unreadCount = existingConversation[existingConversationId] ?? 0;
        final firstUnreadMessageIndex =
            existingConversation["firstUnreadMessageIndex"] ?? -1;
        print(
          'Found existing conversation: $existingConversationId with friend: ${friend.userId}',
        );
        _joinConversationAndNavigate(
          existingConversationId,
          friendInfo,
          unreadCount,
          firstUnreadMessageIndex,
        );
      } else {
        print(
          'No existing conversation with friend: ${friend.userId}, creating new chat',
        );
        messageBloc = s1<MessageBloc>();

        if (widget.isWebLayout) {
          widget.onConversationSelected?.call({
            'userId': userId!,
            'username': username!,
            'friendId': friend.userId,
            'friendInfo': friendInfo,
            'messageBloc': messageBloc,
          });
        } else {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => messageBloc,
                child: ChatDetailPage(
                  // Pass friendId to create new conversation
                  userId: userId!,
                  username: username!,
                  friendId: friend.userId,
                  friendInfo: friendInfo,
                ),
              ),
            ),
          );
        }
      }
    } catch (e) {
      // Hide loading indicator if error
      Navigator.of(context).pop();

      showErrorSnackBar(context, context.l10n.chatFindConversationFailed('$e'));
    }
  }

  Route _searchRoute(List<FriendEntity> friends) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, __, ___) =>
          ChatSearchPage(friends: friends, onNavigateToChat: _handleFriendTap),
      transitionsBuilder: (_, animation, __, child) {
        final offsetAnimation = Tween(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(animation);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConversationBloc, ConversationState>(
      listener: (context, state) {
        if (state is ConversationError) {
          showErrorSnackBar(
            context,
            context.l10n.chatConversationError(state.message),
          );
        } else if (state is CreateConversationSuccess) {
          // Khi tạo conversation thành công, reload conversations để hiển thị conversation mới
          if (userId != null) {
            _loadConversations();
          }
        } else if (state is ConversationsError) {
          showErrorSnackBar(
            context,
            context.l10n.chatConversationsError(
              state.message ?? context.l10n.commonUnknown,
            ),
          );
          // Reset loading flag khi có lỗi
          if (_isLoadingMore) {
            setState(() {
              _isLoadingMore = false;
            });
          }
        } else if (state is ConversationsLoaded) {
          // Reset loading flag khi conversations được load thành công
          if (_isLoadingMore) {
            setState(() {
              _isLoadingMore = false;
            });
          }
        }
      },
      child: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          if (state is MenuLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MenuErrorState) {
            return Text(context.l10n.commonErrorWithMessage(state.message));
          }

          if (state is MenuLoadedState) {
            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                surfaceTintColor: Colors.transparent,
                backgroundColor: AppColors.background,
                elevation: 0,

                leading: widget.isWebLayout
                    ? const SizedBox.shrink()
                    : Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              CupertinoIcons.back,
                              color: AppColors.textPrimary,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                leadingWidth: widget.isWebLayout ? 16 : null,
                title: Text(
                  state.user.fullName ?? context.l10n.chatTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      final friendState = context.read<FriendBloc>().state;
                      List<FriendEntity> friendsList = [];

                      if (friendState is FriendLoaded) {
                        friendsList = friendState.friends;
                      }

                      if (widget.isWebLayout) {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: 500,
                                maxHeight: 0.8.sh,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.r),
                                child: CreateGroupChatPage(
                                  friends: friendsList,
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) =>
                                CreateGroupChatPage(friends: friendsList),
                          ),
                        );
                      }
                    },
                    icon: Icon(
                      CupertinoIcons.plus_app,
                      color: AppColors.textPrimary,
                      size: 24.sp,
                    ),
                  ),

                  // IconButton(
                  //   onPressed: () {},
                  //   icon: Icon(Icons.settings, color: AppColors.textPrimary),
                  // ),
                ],
              ),

              body: _isSearching && widget.isWebLayout
                  ? Builder(
                      builder: (context) {
                        final friendState = context.read<FriendBloc>().state;
                        List<FriendEntity> friendsList = [];

                        if (friendState is FriendLoaded) {
                          friendsList = friendState.friends;
                        }
                        return ChatSearchPage(
                          friends: friendsList,
                          onNavigateToChat: (friend) async {
                            await _handleFriendTap(friend);
                            if (mounted) {
                              setState(() {
                                _isSearching = false;
                              });
                            }
                          },
                          isWebLayout: true,
                          onBack: () {
                            setState(() {
                              _isSearching = false;
                            });
                          },
                        );
                      },
                    )
                  : RefreshIndicator(
                      onRefresh: _loadData,
                      color: AppColors.primary,
                      backgroundColor: AppColors.background,
                      child: CustomScrollView(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          // Ô tìm kiếm
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                              child: InkWell(
                                mouseCursor: SystemMouseCursors.text,
                                borderRadius: BorderRadius.circular(30),
                                onTap: () {
                                  if (widget.isWebLayout) {
                                    setState(() {
                                      _isSearching = true;
                                    });
                                    return;
                                  }

                                  final friendState = context
                                      .read<FriendBloc>()
                                      .state;
                                  List<FriendEntity> friendsList = [];

                                  if (friendState is FriendLoaded) {
                                    friendsList = friendState.friends;
                                  }

                                  Navigator.of(
                                    context,
                                  ).push(_searchRoute(friendsList));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 10.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.textSecondary.withOpacity(
                                      0.05,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.search,
                                        color: AppColors.textSecondary,
                                      ),
                                      SizedBox(width: 10.w),
                                      Text(
                                        context.l10n.chatSearchHint,
                                        style: TextStyle(
                                          color: AppColors.textSecondary,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Story List (Friends)
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height: 95.h,
                              child: BlocBuilder<FriendBloc, FriendState>(
                                builder: (context, friendState) {
                                  if (friendState is FriendLoaded) {
                                    final friends = friendState.friends;

                                    if (friends.isEmpty) {
                                      return Padding(
                                        padding: EdgeInsets.only(right: 12.w),
                                        child: StoryChatItemWidget(
                                          imageUrl: "https://i.pravatar.cc/200",
                                          name: context.l10n.chatYourStory,
                                          showAddButton: true,
                                          onTap: () {
                                            // Handle add story tap
                                          },
                                        ),
                                      );
                                    }
                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                      ),
                                      itemCount:
                                          friends.length +
                                          1, // +1 for add story button
                                      itemBuilder: (context, index) {
                                        if (index == 0) {
                                          // Add story button
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              right: 12.w,
                                            ),
                                            child: StoryChatItemWidget(
                                              imageUrl:
                                                  state.user.avatarUrl ??
                                                  "https://i.pravatar.cc/200",
                                              name:
                                                  context.l10n.chatCreateStory,
                                              showAddButton: true,
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                    builder: (context) {
                                                      return StoryCreatePage();
                                                    },
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        }

                                        final friend = friends[index - 1];
                                        return Padding(
                                          padding: EdgeInsets.only(right: 12.w),
                                          child: StoryChatItemWidget(
                                            imageUrl:
                                                friend.avatarUrl ??
                                                "https://i.pravatar.cc/200",
                                            name: friend.fullName!
                                                .trim()
                                                .split(' ')
                                                .last,
                                            showAddButton: false,
                                            onTap: () {
                                              // Check if conversation exists with this friend
                                              _handleFriendTap(friend);
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  } else if (friendState is FriendLoading) {
                                    return const ListFriendLoading();
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                          ),

                          // Spacing
                          SliverToBoxAdapter(child: SizedBox(height: 4.h)),

                          // Danh sách hội thoại
                          BlocBuilder<ConversationBloc, ConversationState>(
                            builder: (context, state) {
                              // Handle loading state
                              if (state is ConversationsLoading) {
                                return const SliverToBoxAdapter(
                                  child: ConversationsLoadingWidget(),
                                );
                              }

                              // Handle loaded state (including when join conversation is successful)
                              // ConversationsLoaded? conversationsState;
                              // if (state is ConversationsLoaded) {
                              //   conversationsState = state;
                              // }
                              // // Keep showing conversations even after successful join
                              // else if (state is JoinConversationSuccess) {
                              //   // Try to get the last conversations state from bloc
                              //   // For now, we'll trigger a reload
                              //   WidgetsBinding.instance.addPostFrameCallback((_) {
                              //     _loadConversations();
                              //   });
                              //   // return const SliverToBoxAdapter(
                              //   //   child: ConversationsLoadingWidget(),
                              //   // );
                              // }

                              if (state is ConversationsLoaded) {
                                final conversations = state.conversations.data;
                                if (conversations.isEmpty) {
                                  // Show friend suggestions when no conversations
                                  return SliverToBoxAdapter(
                                    child: _buildEmptyConversationView(),
                                  );
                                }
                                return SliverList(
                                  delegate: SliverChildBuilderDelegate((
                                    context,
                                    index,
                                  ) {
                                    final conversation = conversations[index];

                                    // Lấy danh sách participants khác với user hiện tại
                                    final otherParticipants = conversation
                                        .participants
                                        .where(
                                          (participant) =>
                                              participant.userId != userId,
                                        )
                                        .toList();

                                    // Participant đầu tiên để dùng cho navigation
                                    final firstParticipant =
                                        otherParticipants.isNotEmpty
                                        ? otherParticipants.first
                                        : conversation.participants.firstOrNull;

                                    // Xử lý tên hiển thị cho group
                                    String displayName =
                                        ChatHelper.formatConversationName(
                                          conversation,
                                          otherParticipants,
                                          firstParticipant,
                                        );

                                    // Xử lý preview text
                                    final String previewText;

                                    if (conversation.lastMessage != null) {
                                      final bool fromMe =
                                          conversation
                                              .lastMessage!
                                              .sender
                                              .userId ==
                                          userId;

                                      // Lấy tên người gửi
                                      String senderName;
                                      if (fromMe) {
                                        senderName = context.l10n.chatYou;
                                      } else if (conversation.isGroup) {
                                        // Trong group, hiển thị tên người gửi
                                        final sender = conversation.participants
                                            .firstWhere(
                                              (p) =>
                                                  p.userId ==
                                                  conversation
                                                      .lastMessage!
                                                      .sender
                                                      .userId,
                                            );
                                        senderName =
                                            sender.fullName
                                                ?.trim()
                                                .split(' ')
                                                .last ??
                                            sender.username ??
                                            context.l10n.commonUser;
                                      } else {
                                        senderName = "";
                                      }

                                      if (conversation
                                          .lastMessage!
                                          .attachments
                                          .isNotEmpty) {
                                        previewText = context.l10n
                                            .chatSentAttachmentPreview(
                                              senderName.isNotEmpty
                                                  ? '$senderName '
                                                  : '',
                                              conversation
                                                  .lastMessage!
                                                  .attachments
                                                  .first
                                                  .type,
                                              conversation
                                                  .lastMessage!
                                                  .createdAt
                                                  .formatChatTime(),
                                            );
                                      } else {
                                        previewText = context.l10n
                                            .chatTextPreview(
                                              senderName.isNotEmpty || fromMe
                                                  ? '$senderName: '
                                                  : '',
                                              conversation.lastMessage!.text ??
                                                  '',
                                              conversation
                                                  .lastMessage!
                                                  .createdAt
                                                  .formatChatTime(),
                                            );
                                      }
                                    } else {
                                      // Không có lastMessage
                                      if (conversation.isGroup) {
                                        // Group mới tạo - hiển thị người tạo
                                        final creator = conversation.createdBy!;
                                        final creatorName =
                                            creator.userId == userId
                                            ? context.l10n.chatYou
                                            : creator.fullName
                                                      ?.trim()
                                                      .split(' ')
                                                      .last ??
                                                  creator.username ??
                                                  context.l10n.chatSomeone;
                                        previewText = context.l10n
                                            .chatGroupCreatedPreview(
                                              creatorName,
                                            );
                                      } else {
                                        // 1-1 chat chưa có tin nhắn
                                        previewText =
                                            context.l10n.chatConnected;
                                      }
                                    }

                                    bool? isOnline;
                                    if (!conversation.isGroup &&
                                        firstParticipant != null) {
                                      final otherUserId =
                                          firstParticipant.userId;
                                      final status =
                                          _presenceByUserId[otherUserId];
                                      if (status != null) {
                                        isOnline = status.isOnline;
                                      }

                                      if (_chatPresenceService != null &&
                                          !_presenceRequestedUserIds.contains(
                                            otherUserId,
                                          )) {
                                        _presenceRequestedUserIds.add(
                                          otherUserId,
                                        );
                                        _chatPresenceService!.requestPresence([
                                          otherUserId,
                                        ]);
                                      }
                                    }

                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 6.h),
                                      child: ConversationItem(
                                        avatarUrl:
                                            conversation.isGroup &&
                                                conversation.avatar != null
                                            ? conversation.avatar
                                            : firstParticipant!.avatarUrl ??
                                                  'https://i.pravatar.cc/200',
                                        name: displayName,
                                        preview: previewText,
                                        isUnread:
                                            (conversation.unreadCount ?? 0) > 0,
                                        isGroup: conversation.isGroup,
                                        participants: conversation.isGroup
                                            ? otherParticipants
                                            : (firstParticipant != null
                                                  ? [firstParticipant]
                                                  : null),
                                        isOnline: isOnline,
                                        onTap: () {
                                          _joinConversationAndNavigate(
                                            conversation.id,
                                            firstParticipant!,
                                            conversation.unreadCount ?? 0,
                                            conversation
                                                .firstUnreadMessageIndex,
                                            isGroup: conversation.isGroup,
                                            groupName: displayName,
                                            groupAvatar: conversation.avatar,
                                            participants: conversation.isGroup
                                                ? otherParticipants
                                                : null,
                                          );
                                        },
                                      ),
                                    );
                                  }, childCount: conversations.length),
                                );
                              }

                              // Show loading indicator at bottom when loading more
                              if (state is ConversationsLoaded &&
                                  _isLoadingMore) {
                                return SliverToBoxAdapter(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.h),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              // Handle error state
                              else if (state is ConversationsError) {
                                return SliverToBoxAdapter(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          context.l10n.commonErrorWithMessage(
                                            state.message ??
                                                context.l10n.commonUnknown,
                                          ),
                                        ),
                                        SizedBox(height: 16.h),
                                        ElevatedButton(
                                          onPressed: _loadConversations,
                                          child: Text(context.l10n.commonRetry),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return const SliverToBoxAdapter(
                                  child: ConversationsLoadingWidget(),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildEmptyConversationView() {
    return BlocBuilder<FriendBloc, FriendState>(
      builder: (context, friendState) {
        if (friendState is FriendLoaded) {
          final friends = friendState.friends;
          if (friends.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                context.l10n.chatNoFriendsToStart,
                textAlign: TextAlign.center,
              ),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Text(
                  context.l10n.chatSuggestedFriends,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              ...friends.map((friend) {
                return FriendMessageSuggestionItem(
                  avatar: friend.avatarUrl ?? '',
                  name:
                      friend.fullName ??
                      friend.username ??
                      context.l10n.commonUser,
                  onTap: () {
                    // Check if conversation exists with this friend
                    _handleFriendTap(friend);
                  },
                );
              }),
            ],
          );
        } else if (friendState is FriendLoading) {
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(child: Text(context.l10n.chatNoConversations)),
        );
      },
    );
  }
}
