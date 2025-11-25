import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/date_time_extensions.dart';
import 'package:social_app_fe/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:social_app_fe/features/chat/presentation/bloc/chat_event.dart';
import 'package:social_app_fe/features/chat/presentation/bloc/chat_state.dart';
import 'package:social_app_fe/features/chat/presentation/pages/chat_detail_page.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/conversation_item.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/conversations_loading_widget.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/list_friend_loading.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/story_chat_item_widget.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/friend_message_suggestion_item.dart';
import 'package:social_app_fe/features/friend/presentation/bloc/friend_bloc.dart';
import 'package:social_app_fe/core/local/token_storage.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _loadFriends();
    await _loadConversations();
  }

  Future<void> _loadConversations() async {
    final userData = await TokenStorage.getUserData();
    final userId = userData?['id'];
    if (userId != null) {
      context.read<ChatBloc>().add(
        LoadConversationsEvent(userId: userId, page: 1, limit: 10),
      );
    }
  }

  void _loadFriends() {
    context.read<FriendBloc>().add(LoadFriends());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Chat error: ${state.message}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
          // } else if (state is ConversationsLoaded) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(
          //       content: Text(
          //         'Loaded ${state.conversations.data.length} conversations',
          //       ),
          //       backgroundColor: Colors.blue,
          //       duration: const Duration(seconds: 2),
          //     ),
          //   );
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
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: AppColors.background,
          elevation: 0,

          leading: Row(
            children: [
              IconButton(
                icon: Icon(CupertinoIcons.back, color: AppColors.textPrimary),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          title: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              String title = "Duy Phạm";

              return Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              );
            },
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings, color: AppColors.textPrimary),
            ),
          ],
        ),

        body: RefreshIndicator(
          onRefresh: _loadData,
          color: AppColors.primary,
          backgroundColor: AppColors.background,
          child: CustomScrollView(
            slivers: [
              // Ô tìm kiếm
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Tìm kiếm",
                      hintStyle: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.textSecondary,
                      ),
                      filled: true,
                      fillColor: AppColors.textSecondary.withOpacity(0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
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
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          itemCount:
                              friends.length + 1, // +1 for add story button
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              // Add story button
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

                            final friend = friends[index - 1];
                            return Padding(
                              padding: EdgeInsets.only(right: 12.w),
                              child: StoryChatItemWidget(
                                imageUrl:
                                    friend.avatarUrl ??
                                    "https://i.pravatar.cc/200",
                                name: friend.fullName!.trim().split(' ').last,
                                showAddButton: false,
                                onTap: () {
                                  // Navigate to chat with this friend
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (_) => ChatDetailPage(),
                                    ),
                                  );
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
              BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ConversationsLoading) {
                    return const SliverToBoxAdapter(
                      child: ConversationsLoadingWidget(),
                    );
                  } else if (state is ConversationsLoaded) {
                    final conversations = state.conversations.data;
                    if (conversations.isEmpty) {
                      // Show friend suggestions when no conversations
                      return SliverToBoxAdapter(
                        child: _buildEmptyConversationView(),
                      );
                    }
                    return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final conversation = conversations[index];
                        final otherParticipant =
                            conversation.participants.length > 1
                            ? conversation
                                  .participants[1] // Assume current user is first participant
                            : conversation.participants.firstOrNull;

                        return Padding(
                          padding: EdgeInsets.only(bottom: 6.h),
                          child: ConversationItem(
                            avatarUrl: conversation.isGroup
                                ? conversation.avatar ??
                                      "https://i.pravatar.cc/200"
                                : otherParticipant?.avatarUrl ??
                                      "https://i.pravatar.cc/200",
                            name: conversation.isGroup
                                ? conversation.name ?? "Group Chat"
                                : otherParticipant?.fullName ??
                                      otherParticipant?.username ??
                                      "Unknown",
                            preview:
                                "${conversation.lastMessage?.text} • ${conversation.lastMessage?.createdAt.formatChatTime() ?? ''}",
                            isUnread: (conversation.unreadCount ?? 0) > 0,
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => ChatDetailPage(
                                    conversationId: conversation.id,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }, childCount: conversations.length),
                    );
                  } else if (state is ConversationsError) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Error: ${state.message ?? "Unknown error"}'),
                            SizedBox(height: 16.h),
                            ElevatedButton(
                              onPressed: _loadConversations,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SliverToBoxAdapter(
                    child: Center(child: Text('No conversations loaded')),
                  );
                },
              ),
            ],
          ),
        ),
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
                    // Navigate to chat with this friend
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (_) => ChatDetailPage()),
                    );
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
