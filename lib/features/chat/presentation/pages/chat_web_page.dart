import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/features/app/presentation/widgets/side_navigation.dart';
import 'package:social_app_fe/features/chat/presentation/pages/chat_detail_page.dart';
import 'package:social_app_fe/features/chat/presentation/pages/chat_list_page.dart';
import 'package:social_app_fe/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:social_app_fe/features/notification/presentation/bloc/notification_state.dart';
import 'package:social_app_fe/features/chat/presentation/bloc/message/message_bloc.dart';
import 'package:social_app_fe/features/chat/presentation/pages/chat_info_page.dart';
import 'package:social_app_fe/features/chat/presentation/pages/group_members_page.dart';
import 'package:social_app_fe/features/chat/presentation/pages/conversation_media_page.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class ChatWebPage extends StatefulWidget {
  const ChatWebPage({super.key});

  @override
  State<ChatWebPage> createState() => _ChatWebPageState();
}

class _ChatWebPageState extends State<ChatWebPage> {
  Map<String, dynamic>? _selectedConversationArgs;
  Map<String, dynamic>? _currentUserData;
  bool _showInfoPane = false;
  bool _showMembersPane = false;
  bool _showMediaPane = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await TokenStorage.getUserData();
    if (mounted) {
      setState(() {
        _currentUserData = userData;
      });
    }
  }

  String _getAvtCurrent() {
    final avatarUrl = _currentUserData?['avatarUrl'] as String?;
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      return avatarUrl;
    }
    final avatar = _currentUserData?['avatar'] as String?;
    if (avatar != null && avatar.isNotEmpty) {
      return avatar;
    }
    return '';
  }

  void _onTabSelected(int index) {
    if (index == -2) {
      // Already on chat
      return;
    }
    if (index == -1) {
      Navigator.pushNamed(context, '/search');
      return;
    }
    // Navigate back to main page with selected tab
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/main',
      (route) => false,
      arguments: {'initialTab': index},
    );
  }

  void _handleConversationSelected(Map<String, dynamic> args) {
    // kiểm tra nếu đã chọn cuộc trò chuyện này rồi thì không cập nhật lại
    if (_selectedConversationArgs != null &&
        _selectedConversationArgs!['conversationId'] ==
            args['conversationId']) {
      return;
    }

    setState(() {
      _selectedConversationArgs = args;
      _showMembersPane = false;
      _showMediaPane = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < ResponsiveHelper.mobileBreakpoint) {
            return const ChatListPage(isWebLayout: false);
          }

          final canShowInfoPane = constraints.maxWidth >= 1150;

          return Row(
            children: [
              // Side Navigation
              BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, notificationState) {
                  return SideNavigation(
                    currentIndex: -2, // -2 is the index for Chat
                    onTabSelected: _onTabSelected,
                    unreadCount: notificationState.unread,
                    avt: _getAvtCurrent(),
                  );
                },
              ),

              // Chat List Pane
              Container(
                width: 350,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: AppColors.textSecondary.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: ChatListPage(
                  isWebLayout: true,
                  onConversationSelected: _handleConversationSelected,
                ),
              ),

              // Chat Detail Pane
              Expanded(
                child: _selectedConversationArgs != null
                    ? BlocProvider<MessageBloc>.value(
                        value:
                            _selectedConversationArgs!['messageBloc']
                                as MessageBloc,
                        child: ChatDetailPage(
                          key: ValueKey(
                            _selectedConversationArgs!['conversationId'] ??
                                _selectedConversationArgs!['friendId'],
                          ),
                          userId: _selectedConversationArgs!['userId'],
                          username: _selectedConversationArgs!['username'],
                          conversationId:
                              _selectedConversationArgs!['conversationId'],
                          friendId: _selectedConversationArgs!['friendId'],
                          friendInfo: _selectedConversationArgs!['friendInfo'],
                          unreadCount:
                              _selectedConversationArgs!['unreadCount'],
                          firstUnreadMessageIndex:
                              _selectedConversationArgs!['firstUnreadMessageIndex'],
                          isGroup:
                              _selectedConversationArgs!['isGroup'] ?? false,
                          isWebLayout: true,
                          groupName: _selectedConversationArgs!['groupName'],
                          groupAvatar:
                              _selectedConversationArgs!['groupAvatar'],
                          participants:
                              _selectedConversationArgs!['participants'],
                          onInfoTap: canShowInfoPane
                              ? () {
                                  setState(() {
                                    _showInfoPane = !_showInfoPane;
                                  });
                                }
                              : null,
                        ),
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.message_outlined,
                              size: 64,
                              color: AppColors.textSecondary.withOpacity(0.5),
                            ),

                            const SizedBox(height: 16),

                            Text(
                              context.l10n.chatTitle,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textSecondary,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              context.l10n.chatChooseConversation,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),

              // Chat Info / Members Pane (Right Side)
              if (_showInfoPane &&
                  _selectedConversationArgs != null &&
                  canShowInfoPane)
                Container(
                  width: 350,
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: AppColors.textSecondary.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: _showMediaPane
                      ? ConversationMediaPage(
                          conversationId: _selectedConversationArgs!['conversationId'] as String? ?? '',
                          isWebLayout: true,
                          onBack: () {
                            setState(() {
                              _showMediaPane = false;
                            });
                          },
                        )
                      : _showMembersPane &&
                          (_selectedConversationArgs!['isGroup'] ?? false) &&
                          _selectedConversationArgs!['participants'] != null
                      ? GroupMembersPage(
                          participants:
                              _selectedConversationArgs!['participants']
                                  as List<UserEntity>,
                          currentUserId:
                              _selectedConversationArgs!['userId'] as String?,
                          groupName:
                              _selectedConversationArgs!['groupName']
                                  as String?,
                          isWebLayout: true,
                          onBack: () {
                            setState(() {
                              _showMembersPane = false;
                            });
                          },
                        )
                      : ChatInfoPage(
                          isGroup:
                              _selectedConversationArgs!['isGroup'] ?? false,
                          displayName:
                              _selectedConversationArgs!['groupName'] ??
                              (_selectedConversationArgs!['friendInfo']
                                      as UserEntity?)
                                  ?.fullName ??
                              (_selectedConversationArgs!['friendInfo']
                                      as UserEntity?)
                                  ?.username ??
                              '',
                          groupAvatar:
                              _selectedConversationArgs!['groupAvatar'],
                          participants:
                              _selectedConversationArgs!['participants'],
                          userInfo: _selectedConversationArgs!['friendInfo'],
                          conversationId:
                              _selectedConversationArgs!['conversationId'],
                          userId: _selectedConversationArgs!['userId'],
                          isWebLayout: true,
                          onShowMembers: () {
                            setState(() {
                              _showMembersPane = true;
                            });
                          },
                          onShowMedia: () {
                            setState(() {
                              _showMediaPane = true;
                            });
                          },
                        ),
                ),
            ],
          );
        },
      ),
    );
  }
}
