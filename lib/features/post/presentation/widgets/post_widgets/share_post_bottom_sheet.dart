import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:social_app_fe/features/chat/domain/entities/conversation_entity.dart';
import 'package:social_app_fe/features/chat/presentation/bloc/conversation/conversation_bloc.dart';
import 'package:social_app_fe/features/chat/presentation/bloc/conversation/conversation_state.dart';
import 'package:social_app_fe/features/chat/presentation/bloc/conversation/conversation_event.dart';
import 'package:social_app_fe/features/chat/presentation/helper/chat_helper.dart';
import 'package:social_app_fe/features/post/domain/entities/post_entity.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';

class SharePostBottomSheet extends StatefulWidget {
  final PostEntity post;

  const SharePostBottomSheet({Key? key, required this.post}) : super(key: key);

  static void show(BuildContext context, PostEntity post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SharePostBottomSheet(post: post),
    );
  }

  @override
  State<SharePostBottomSheet> createState() => _SharePostBottomSheetState();
}

class _SharePostBottomSheetState extends State<SharePostBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _sharedConversationIds = {};
  bool _isSending = false;
  String? _userId;

  final Color _sendButtonColor = AppColors.primary;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
    _loadUserId();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUserId() async {
    final userData = await TokenStorage.getUserData();
    if (!mounted) return;

    setState(() {
      _userId = userData?['_id']?.toString() ?? userData?['id']?.toString();
    });

    if (_userId != null) {
      _loadConversations(_userId!);
    }
  }

  void _loadConversations(String userId) {
    final state = context.read<ConversationBloc>().state;
    if (state is ConversationInitial ||
        (state is ConversationsLoaded && state.conversations.data.isEmpty)) {
      context.read<ConversationBloc>().add(
        LoadConversationsEvent(userId: userId),
      );
    }
  }

  Future<void> _shareToConversation(String conversationId) async {
    if (_userId == null) return;

    setState(() {
      _isSending = true;
    });

    try {
      final sendMessageUseCase = s1<SendMessageUseCase>();
      sendMessageUseCase(
        userId: _userId!,
        conversationId: conversationId,
        postId: widget.post.id,
      );

      setState(() {
        _sharedConversationIds.add(conversationId);
        _isSending = false;
      });

      if (mounted) {
        showSuccessSnackBar(context, 'Shared successfully');
      }
    } catch (e) {
      setState(() {
        _isSending = false;
      });
      if (mounted) {
        showErrorSnackBar(context, 'Failed to share post');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildSearchField(),
          Expanded(
            child: BlocBuilder<ConversationBloc, ConversationState>(
              builder: (context, state) {
                if (state is ConversationsLoading) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                final List<ConversationEntity> conversations =
                    state is ConversationsLoaded
                    ? state.conversations.data
                    : [];
                final visibleConversations = conversations.where((conversation) {
                  final title = _getConversationTitle(conversation);
                  final query = _searchController.text.trim().toLowerCase();

                  return query.isEmpty || title.toLowerCase().contains(query);
                }).toList();

                if (visibleConversations.isEmpty) {
                  return Center(
                    child: Text(
                      _searchController.text.trim().isEmpty
                          ? 'Không có cuộc trò chuyện để chia sẻ.'
                          : 'Không tìm thấy cuộc trò chuyện.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(
                    14.rs(context),
                    8.rs(context),
                    14.rs(context),
                    14.rs(context),
                  ),
                  itemCount: visibleConversations.length,
                  itemBuilder: (context, index) {
                    final conversation = visibleConversations[index];
                    final isShared = _sharedConversationIds.contains(
                      conversation.id,
                    );

                    return _buildConversationRow(conversation, isShared);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        14.rs(context),
        8.rs(context),
        14.rs(context),
        12.rs(context),
      ),
      child: Column(
        children: [
          Container(
            width: 26.rs(context),
            height: 3.rs(context),
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 14.rs(context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Chia sẻ bài viết',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18.rsp(context),
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.close,
                  color: AppColors.textSecondary,
                  size: 22.rs(context),
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        14.rs(context),
        0,
        14.rs(context),
        8.rs(context),
      ),
      child: SizedBox(
        height: 36.rs(context),
        child: TextField(
          controller: _searchController,
          cursorColor: AppColors.primary,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13.rsp(context),
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: 'Tìm kiếm bạn bè...',
            hintStyle: TextStyle(
              color: AppColors.textSecondary.withOpacity(0.55),
              fontSize: 12.rsp(context),
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Icon(
              Icons.search,
              size: 17.rs(context),
              color: AppColors.textSecondary.withOpacity(0.55),
            ),
            prefixIconConstraints: BoxConstraints(
              minWidth: 30.rs(context),
              minHeight: 36.rs(context),
            ),
            filled: true,
            fillColor: AppColors.secondBackground.withOpacity(0.75),
            contentPadding: EdgeInsets.symmetric(vertical: 8.rs(context)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9.rs(context)),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9.rs(context)),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9.rs(context)),
              borderSide: BorderSide(color: AppColors.primary.withOpacity(0.2)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConversationRow(
    ConversationEntity conversation,
    bool isShared,
  ) {
    final title = _getConversationTitle(conversation);

    return SizedBox(
      height: 55.rs(context),
      child: Row(
        children: [
          SizedBox(
            width: 36.rs(context),
            height: 36.rs(context),
            child: _buildConversationAvatar(conversation),
          ),
          SizedBox(width: 10.rs(context)),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14.rsp(context),
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 10.rs(context)),
          SizedBox(
            height: 24.rs(context),
            child: ElevatedButton(
              onPressed: isShared || _isSending
                  ? null
                  : () => _shareToConversation(conversation.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: isShared
                    ? AppColors.secondBackground
                    : _sendButtonColor,
                disabledBackgroundColor: AppColors.secondBackground,
                foregroundColor: isShared ? AppColors.textSecondary : Colors.white,
                disabledForegroundColor: AppColors.textSecondary,
                elevation: 0,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: Size(47.rs(context), 24.rs(context)),
                padding: EdgeInsets.symmetric(horizontal: 14.rs(context)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.rs(context)),
                ),
              ),
              child: Text(
                isShared ? 'Đã gửi' : 'Gửi',
                style: TextStyle(
                  fontSize: 11.rsp(context),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationAvatar(ConversationEntity conversation) {
    final otherParticipants = _getOtherParticipants(conversation);
    final firstParticipant = otherParticipants.isNotEmpty
        ? otherParticipants.first
        : conversation.participants.isNotEmpty
        ? conversation.participants.first
        : null;

    return ChatHelper.buildAvatarWidget(
      isGroup: conversation.isGroup,
      groupAvatar: conversation.avatar,
      participants: conversation.isGroup ? otherParticipants : null,
      firstParticipant: firstParticipant,
      size: 36.rs(context),
    );
  }

  String _getConversationTitle(ConversationEntity conversation) {
    final otherParticipants = _getOtherParticipants(conversation);
    final firstParticipant = otherParticipants.isNotEmpty
        ? otherParticipants.first
        : conversation.participants.isNotEmpty
        ? conversation.participants.first
        : null;

    return ChatHelper.formatConversationName(
      conversation,
      otherParticipants,
      firstParticipant,
    );
  }

  List<UserEntity> _getOtherParticipants(ConversationEntity conversation) {
    return conversation.participants
        .where((participant) => participant.userId != _userId)
        .toList();
  }
}
