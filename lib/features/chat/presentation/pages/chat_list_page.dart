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
import 'package:social_app_fe/features/chat/presentation/pages/chat_detail_page.dart';
import 'package:social_app_fe/features/chat/presentation/pages/chat_search_page.dart';
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

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

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
      _loadFriends();
      await _loadConversations();
    }
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
      for (final conversation in conversations) {
        _conversationBloc.add(
          LeaveConversationEvent(conversationId: conversation.id),
        );
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
  ) async {
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not found. Please login again.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
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
          ),
        ),
      ),
    );
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
            return {conversation.id: conversation.unreadCount ?? 0};
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not found. Please login again.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
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
        print(
          'Found existing conversation: $existingConversationId with friend: ${friend.userId}',
        );
        _joinConversationAndNavigate(
          existingConversationId,
          friendInfo,
          unreadCount,
        );
      } else {
        print(
          'No existing conversation with friend: ${friend.userId}, creating new chat',
        );
        messageBloc = s1<MessageBloc>();

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
    } catch (e) {
      // Hide loading indicator if error
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error finding conversation: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Conversation error: ${state.message}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        } else if (state is CreateConversationSuccess) {
          // Khi tạo conversation thành công, reload conversations để hiển thị conversation mới
          if (userId != null) {
            _loadConversations();
          }
        } else if (state is ConversationsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Conversations Error: ${state.message ?? "Unknown error"}',
              ),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 3),
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
            return Text('Lỗi: ${state.message}');
          }

          if (state is MenuLoadedState) {
            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                surfaceTintColor: Colors.transparent,
                backgroundColor: AppColors.background,
                elevation: 0,

                leading: Row(
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
                title: Text(
                  state.user.fullName ?? "Chats",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.settings,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),

              body: RefreshIndicator(
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
                          borderRadius: BorderRadius.circular(30),
                          onTap: () {
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
                              color: AppColors.textSecondary.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.search,
                                  color: AppColors.textSecondary,
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  "Tìm kiếm",
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
                                    name: "Tin của bạn",
                                    showAddButton: true,
                                    onTap: () {
                                      // Handle add story tap
                                    },
                                  ),
                                );
                              }
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                itemCount:
                                    friends.length +
                                    1, // +1 for add story button
                                itemBuilder: (context, index) {
                                  if (index == 0) {
                                    // Add story button
                                    return Padding(
                                      padding: EdgeInsets.only(right: 12.w),
                                      child: StoryChatItemWidget(
                                        imageUrl:
                                            state.user.avatarUrl ??
                                            "https://i.pravatar.cc/200",
                                        name: "Tạo tin",
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

                              if (conversation.lastMessage != null) {
                                // Tìm participant khác với user hiện tại
                                final otherParticipant =
                                    conversation.participants
                                        .where(
                                          (participant) =>
                                              participant.userId != userId,
                                        )
                                        .firstOrNull ??
                                    conversation.participants.firstOrNull;

                                final bool fromMe =
                                    conversation.lastMessage?.sender.userId ==
                                    userId;

                                final String lastName = otherParticipant!
                                    .fullName!
                                    .trim()
                                    .split(' ')
                                    .last;
                                final String previewText;

                                if (conversation
                                    .lastMessage!
                                    .attachments
                                    .isNotEmpty) {
                                  previewText =
                                      "${fromMe ? "Bạn" : " $lastName"} đã gửi ${conversation.lastMessage?.attachments.first.type}   •   ${conversation.lastMessage?.createdAt.formatChatTime() ?? ''}";
                                } else {
                                  previewText =
                                      "${fromMe ? "Bạn: " : ""}${conversation.lastMessage?.text}   •   ${conversation.lastMessage?.createdAt.formatChatTime() ?? ''}";
                                }
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 6.h),
                                  child: ConversationItem(
                                    avatarUrl: conversation.isGroup
                                        ? conversation.avatar ??
                                              "https://i.pravatar.cc/200"
                                        : otherParticipant.avatarUrl ??
                                              "https://i.pravatar.cc/200",
                                    name: conversation.isGroup
                                        ? conversation.name ?? "Group Chat"
                                        : otherParticipant.fullName ??
                                              otherParticipant.username ??
                                              "Unknown",
                                    preview: previewText,
                                    isUnread:
                                        (conversation.unreadCount ?? 0) > 0,
                                    onTap: () {
                                      _joinConversationAndNavigate(
                                        conversation.id,
                                        otherParticipant,
                                        conversation.unreadCount ?? 0,
                                      );
                                    },
                                  ),
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            }, childCount: conversations.length),
                          );
                        }

                        // Show loading indicator at bottom when loading more
                        if (state is ConversationsLoaded && _isLoadingMore) {
                          return SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.all(16.h),
                              child: const Center(
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Error: ${state.message ?? "Unknown error"}',
                                  ),
                                  SizedBox(height: 16.h),
                                  ElevatedButton(
                                    onPressed: _loadConversations,
                                    child: const Text('Retry'),
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
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No friends found. Add some friends to start chatting!',
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
                  'Bạn bè gợi ý để nhắn tin',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              ...friends.map((friend) {
                return FriendMessageSuggestionItem(
                  avatar: friend.avatarUrl ?? "https://i.pravatar.cc/200",
                  name: friend.fullName ?? friend.username ?? "Unknown",
                  onTap: () {
                    // Check if conversation exists with this friend
                    _handleFriendTap(friend);
                  },
                );
              }),
            ],
          );
        } else if (friendState is FriendLoading) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }
        return const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: Text('No conversations found')),
        );
      },
    );
  }
}
