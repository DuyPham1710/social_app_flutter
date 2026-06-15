import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/chat/presentation/helper/chat_helper.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/change_avatar_dialog.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/change_group_name_dialog.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/pages/other_profile_page.dart';
import 'package:social_app_fe/core/di/injection.dart' as di;
import 'package:social_app_fe/l10n/l10n.dart';

class ChatInfoPage extends StatefulWidget {
  final bool isGroup;
  final String? displayName;
  final String? groupAvatar;
  final List<UserEntity>? participants;
  final UserEntity? userInfo;
  final String? conversationId;
  final String? userId;
  final Function(String callType)? onInitiateCall;
  final bool isWebLayout;

  const ChatInfoPage({
    super.key,
    this.isGroup = false,
    this.displayName,
    this.groupAvatar,
    this.participants,
    this.userInfo,
    this.conversationId,
    this.userId,
    this.onInitiateCall,
    this.isWebLayout = false,
  });

  @override
  State<ChatInfoPage> createState() => _ChatInfoPageState();
}

class _ChatInfoPageState extends State<ChatInfoPage> {
  late String _groupName;

  @override
  void initState() {
    super.initState();
    _groupName = widget.displayName ?? "";
  }

  @override
  Widget build(BuildContext context) {
    Widget avatarWidget = ChatHelper.buildAvatarWidget(
      isGroup: widget.isGroup,
      groupAvatar: widget.groupAvatar,
      participants: widget.participants,
      firstParticipant: widget.userInfo,
      size: 80,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: widget.isWebLayout
            ? const SizedBox.shrink()
            : IconButton(
                icon: Icon(CupertinoIcons.back, color: AppColors.textPrimary),
                onPressed: () => Navigator.pop(context, _groupName),
              ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: AppColors.textPrimary),
            color: AppColors.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            offset: Offset(0, 50),
            itemBuilder: (BuildContext context) => [
              if (widget.isGroup) ...[
                PopupMenuItem<String>(
                  value: 'change_avatar',
                  child: Text(
                    context.l10n.chatChangeGroupPhoto,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'change_name',
                  child: Text(
                    context.l10n.chatChangeName,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'delete_conversation',
                  child: Text(
                    context.l10n.chatDeleteConversation,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'leave_group',
                  child: Text(
                    context.l10n.communityLeaveGroup,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ],
            onSelected: (String value) {
              switch (value) {
                case 'change_avatar':
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        const ChangeAvatarDialog(),
                  );
                case 'change_name':
                  _showChangeGroupNameDialog(context);
                case 'delete_conversation':
                  // Xử lý xóa cuộc trò chuyện
                  break;
                case 'leave_group':
                  // Xử lý rời nhóm
                  break;
              }
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10.h),

            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (widget.isGroup) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              const ChangeAvatarDialog(),
                        );
                      }
                    },
                    child: Stack(
                      children: [
                        // Avatar
                        avatarWidget,

                        // Badge trạng thái hoạt động
                        // Positioned(
                        //   bottom: 0,
                        //   right: 0,
                        //   child: Container(
                        //     padding: EdgeInsets.symmetric(
                        //       horizontal: 4.w,
                        //       vertical: 2.h,
                        //     ),
                        //     decoration: BoxDecoration(
                        //       color: Colors.green.shade100,
                        //       borderRadius: BorderRadius.circular(12.r),
                        //       border: Border.all(
                        //         color: AppColors.background,
                        //         width: 2,
                        //       ),
                        //     ),

                        //     child: Text(
                        //       "26 phút",
                        //       style: TextStyle(
                        //         color: Colors.green.shade700,
                        //         fontSize: 10.sp,
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),

                  SizedBox(height: 12.h),

                  GestureDetector(
                    onTap: () {
                      if (widget.isGroup) {
                        _showChangeGroupNameDialog(context);
                      }
                    },
                    child: Text(
                      _groupName.isNotEmpty
                          ? _groupName
                          : widget.userInfo?.fullName ?? context.l10n.authUsername,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // ACTION BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildActionBtn(
                  onTap: () => widget.onInitiateCall?.call('audio'),
                  icon: CupertinoIcons.phone_fill,
                  label: context.l10n.chatAudioCall,
                ),
                _buildActionBtn(
                  onTap: () => widget.onInitiateCall?.call('video'),
                  icon: CupertinoIcons.videocam_fill,
                  label: context.l10n.chatVideoCall,
                ),

                widget.isGroup
                    ? _buildActionBtn(
                        onTap: () {},
                        icon: Icons.person_add,
                        label: context.l10n.chatAddMember,
                        size: 20.sp,
                      )
                    : _buildActionBtn(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (_) => di.s1<OtherProfileBloc>()
                                  ..add(
                                    LoadOtherUserProfileEvent(
                                      userId: widget.userInfo!.userId,
                                    ),
                                  ),
                                child: OtherProfilePage(
                                  userId: widget.userInfo!.userId,
                                ),
                              ),
                            ),
                          );
                        },
                        icon: CupertinoIcons.person_fill,
                        label: context.l10n.profileTitle,
                        size: 22.sp,
                      ),
                _buildActionBtn(
                  onTap: () {},
                  icon: CupertinoIcons.bell_fill,
                  label: context.l10n.chatMuteNotifications,
                  size: 20.sp,
                ),
              ],
            ),

            SizedBox(height: 20.h),
            Divider(thickness: 8.h, color: AppColors.divider.withOpacity(0.1)),

            // SECTION: TÙY CHỈNH
            _buildSectionTitle(context.l10n.appearanceCustomAccentColor),
            _buildListTile(
              iconWidget: _buildCircleIcon(Colors.orange, isGradient: true),
              title: context.l10n.chatTheme,
              onTap: () {},
            ),

            _buildListTile(
              iconWidget: Icon(
                Icons.text_fields,
                color: AppColors.textPrimary,
                size: 24.sp,
              ),
              title: context.l10n.chatNickname,
              onTap: () {},
            ),

            SizedBox(height: 10.h),
            Divider(
              height: 1,
              color: AppColors.divider,
              indent: 16.w,
              endIndent: 16.w,
            ),

            // SECTION: Thông tin về đoạn chat
            widget.isGroup
                ? _buildSectionInfoGroupChat(widget.participants!)
                : SizedBox.shrink(),

            // SECTION: HÀNH ĐỘNG KHÁC
            _buildSectionTitle(context.l10n.commonMoreActions),
            !widget.isGroup
                ? _buildListTile(
                    iconWidget: Icon(
                      CupertinoIcons.person_2_fill,
                      color: AppColors.textPrimary,
                      size: 24.sp,
                    ),
                    title: context.l10n.chatCreateGroup,
                    onTap: () {},
                  )
                : SizedBox.shrink(),
            _buildListTile(
              iconWidget: Icon(
                CupertinoIcons.photo,
                color: AppColors.textPrimary,
                size: 24.sp,
              ),
              title: context.l10n.chatViewMediaFilesLinks,
              onTap: () {},
            ),
            _buildListTile(
              iconWidget: Icon(
                CupertinoIcons.pin_fill,
                color: AppColors.textPrimary,
                size: 24.sp,
              ),
              title: context.l10n.chatPinnedMessages,
              onTap: () {},
            ),
            _buildListTile(
              iconWidget: Icon(
                CupertinoIcons.search,
                color: AppColors.textPrimary,
                size: 24.sp,
              ),
              title: context.l10n.chatSearchInConversation,
              onTap: () {},
            ),
            _buildListTile(
              iconWidget: Icon(
                CupertinoIcons.share,
                color: AppColors.textPrimary,
                size: 24.sp,
              ),
              title: context.l10n.chatShareContactInfo,
              onTap: () {},
            ),

            SizedBox(height: 10.h),
            Divider(
              height: 1,
              color: Colors.grey.shade200,
              indent: 16.w,
              endIndent: 16.w,
            ),

            // SECTION: QUYỀN RIÊNG TƯ & HỖ TRỢ
            _buildSectionTitle(context.l10n.commonPrivacySupport),

            _buildListTile(
              iconWidget: Icon(
                CupertinoIcons.eye_fill,
                color: AppColors.textPrimary,
                size: 24.sp,
              ),
              title: context.l10n.chatReadReceipts,
              onTap: () {},
            ),
            _buildListTile(
              iconWidget: Icon(
                CupertinoIcons.chat_bubble_text_fill,
                color: AppColors.textPrimary,
                size: 24.sp,
              ),
              title: context.l10n.chatTypingIndicators,
              subtitle: context.l10n.commonEnabled,
              onTap: () {},
            ),
            _buildListTile(
              iconWidget: Icon(
                CupertinoIcons.nosign,
                color: AppColors.textPrimary,
                size: 24.sp,
              ),
              title: context.l10n.commonRestrict,
              onTap: () {},
            ),
            _buildListTile(
              iconWidget: Icon(
                CupertinoIcons.minus_circle_fill,
                color: AppColors.textPrimary,
                size: 24.sp,
              ),
              title: context.l10n.commonBlock,
              onTap: () {},
            ),
            _buildListTile(
              iconWidget: Icon(
                CupertinoIcons.exclamationmark_triangle_fill,
                color: AppColors.textPrimary,
                size: 24.sp,
              ),
              title: context.l10n.commonReport,
              subtitle: context.l10n.chatFeedbackAndReportConversation,
              onTap: () {},
            ),

            // SECTION: ACTIONS CHỈ CHO NHÓM
            if (widget.isGroup) ...[
              _buildListTile(
                iconWidget: Icon(Icons.logout, color: Colors.red, size: 24.sp),
                title: context.l10n.chatLeaveConversation,
                onTap: () {
                  // Xử lý rời khỏi đoạn chat
                },
              ),
              _buildListTile(
                iconWidget: Icon(
                  CupertinoIcons.delete,
                  color: Colors.red,
                  size: 24.sp,
                ),
                title: context.l10n.chatDeleteChat,
                onTap: () {
                  // Xử lý xóa đoạn chat
                },
              ),
            ],

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionInfoGroupChat(List<UserEntity> participants) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context.l10n.chatConversationInfo),

        _buildListTile(
          iconWidget: Icon(
            CupertinoIcons.person_2_fill,
            color: AppColors.textPrimary,
            size: 24.sp,
          ),
          title: context.l10n.chatViewGroupMembers,
          subtitle: context.l10n.chatMembersCount(participants.length),
          onTap: () {},
        ),
        _buildListTile(
          iconWidget: Icon(
            CupertinoIcons.link,
            color: AppColors.textPrimary,
            size: 24.sp,
          ),
          title: context.l10n.chatGroupLink,
          onTap: () {},
        ),
        SizedBox(height: 10.h),
        Divider(
          height: 1,
          color: AppColors.divider,
          indent: 16.w,
          endIndent: 16.w,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            color: AppColors.textSecondary.withOpacity(0.6),
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildActionBtn({
    required VoidCallback onTap,
    required IconData icon,
    required String label,
    double size = 24,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.textPrimary, size: size.sp),
          ),
          SizedBox(height: 6.h),
          SizedBox(
            width: 70.w, // Giới hạn chiều rộng để text tự xuống dòng nếu dài
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.textPrimary,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required Widget iconWidget,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            SizedBox(
              width: 30.w,
              height: 30.w,
              child: Center(child: iconWidget),
            ),

            SizedBox(width: 14.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  // Nếu có subtitle thì mới render
                  if (subtitle != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget vẽ hình tròn icon "Chủ đề"
  Widget _buildCircleIcon(Color color, {bool isGradient = false}) {
    return Container(
      width: 24.w,
      height: 24.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isGradient ? null : color,
        gradient: isGradient
            ? LinearGradient(
                colors: [color, color.withOpacity(0.5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
      ),
      child: Center(
        child: Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  void _showChangeGroupNameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => ChangeGroupNameDialog(
        currentName: _groupName.isNotEmpty ? _groupName : context.l10n.chatGroupName,
        conversationId: widget.conversationId,
        userId: widget.userId,
      ),
    ).then((newName) {
      if (newName != null) {
        setState(() {
          _groupName = newName;
        });
      }
    });
  }
}
