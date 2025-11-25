import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/chat/presentation/pages/chat_info_page.dart';

class ChatDetailPage extends StatelessWidget {
  final String? conversationId;
  ChatDetailPage({super.key, this.conversationId});

  // Mock data messages
  final List<Map<String, dynamic>> messages = [
    {"fromMe": false, "text": "Mới tới cổng"},
    {"fromMe": true, "text": "nào cbi lên nhớ cái nha 😁"},
    {"fromMe": false, "text": "Mất phí nha"},
    {"fromMe": true, "text": "mua giúp ly nước chỗ relax hehe"},
    {"fromMe": false, "text": "Đù"},
    {"fromMe": false, "text": "Muacho êm à"},
    {"fromMe": true, "text": "cho myself :))"},
    {"fromMe": false, "text": "Ok"},
    {"fromMe": false, "text": "Nhớ nhắc"},
    {"fromMe": true, "text": "ok em 💩"},
    {"fromMe": false, "text": "Mới tới cổng"},
    {"fromMe": true, "text": "nào cbi lên nhớ cái nha 😁"},
    {"fromMe": false, "text": "Mất phí nha"},
    {"fromMe": true, "text": "mua giúp ly nước chỗ relax hehe"},
    {"fromMe": false, "text": "Đù"},
    {"fromMe": false, "text": "Muacho êm à"},
    {"fromMe": true, "text": "cho myself :))"},
    {"fromMe": false, "text": "Ok"},
    {"fromMe": false, "text": "Nhớ nhắc"},
    {"fromMe": true, "text": "ok em 💩"},
    {"fromMe": false, "text": "Mới tới cổng"},
    {"fromMe": true, "text": "nào cbi lên nhớ cái nha 😁"},
    {"fromMe": false, "text": "Mất phí nha"},
    {"fromMe": true, "text": "mua giúp ly nước chỗ relax hehe"},
    {"fromMe": false, "text": "Đù"},
    {"fromMe": false, "text": "Muacho êm à"},
    {"fromMe": true, "text": "cho myself :))"},
    {"fromMe": false, "text": "Ok"},
    {"fromMe": false, "text": "Nhớ nhắc"},
    {"fromMe": true, "text": "ok em 💩"},
    {"fromMe": true, "text": "ok em 💩"},
    {"fromMe": true, "text": "ok em 💩"},
    {"fromMe": true, "text": "ok em 💩"},
    {"fromMe": false, "text": "Nhớ nhắc"},
    {"fromMe": false, "text": "Nhớ nhắc"},
    {"fromMe": false, "text": "Nhớ nhắc"},
    {"fromMe": false, "text": "Nhớ nhắc"},
    {"fromMe": false, "text": "Nhớ nhắc"},
  ];

  @override
  Widget build(BuildContext context) {
    print("Conversation ID: $conversationId");
    return Scaffold(
      backgroundColor: AppColors.background,

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
                backgroundImage: NetworkImage("https://i.pravatar.cc/200"),
                radius: 18.r,
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nguyễn Khang",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
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
                CupertinoPageRoute(builder: (context) => const ChatInfoPage()),
              );
            },
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
              itemCount: messages.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildProfileInfo();
                }
                final int currentMsgIndex = index - 1;
                final msg = messages[currentMsgIndex];
                final fromMe = msg["fromMe"] as bool;

                bool showAvatar = false;

                if (!fromMe) {
                  if (currentMsgIndex == messages.length - 1) {
                    showAvatar = true;
                  } else {
                    final nextMsg = messages[currentMsgIndex + 1];
                    final nextFromMe = nextMsg["fromMe"] as bool;

                    if (nextFromMe) {
                      showAvatar = true;
                    }
                  }
                }
                return _buildMessageItem(msg, fromMe, showAvatar);
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
            backgroundImage: NetworkImage("https://i.pravatar.cc/200"),
          ),
          SizedBox(height: 12.h),

          // Tên hiển thị
          Text(
            "Nguyễn Khang",
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Username nhỏ
          Text(
            "@nguyen.khang.dev", // Mock username
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
            "Bạn và Khang hiện đã là bạn bè.",
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(
    Map<String, dynamic> msg,
    bool fromMe,
    bool showAvatar,
  ) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 10.h,
        left: fromMe ? 60.w : 0,
        right: fromMe ? 0 : 60.w,
      ),
      //alignment: fromMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        // Căn chỉnh hàng: fromMe thì nằm phải, người khác thì nằm trái
        mainAxisAlignment: fromMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        // Căn đáy để Avatar nằm ở dưới cùng của bubble chat
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!fromMe) ...[
            if (showAvatar)
              CircleAvatar(
                radius: 14.r,
                backgroundImage: NetworkImage("https://i.pravatar.cc/200"),
              )
            else
              SizedBox(width: 28.r),

            SizedBox(width: 8.w),
          ],

          // Dùng Flexible để tin nhắn không bị tràn khi có thêm avatar
          Flexible(
            child: Container(
              // Giới hạn chiều rộng tối đa của tin nhắn (khoảng 70% màn hình)
              constraints: BoxConstraints(maxWidth: 0.7.sw),
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 14.w),
              decoration: BoxDecoration(
                color: fromMe
                    ? AppColors.primary
                    : AppColors.textSecondary.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14.r),
                  topRight: Radius.circular(14.r),
                  bottomLeft: Radius.circular(fromMe ? 14.r : 0),
                  bottomRight: Radius.circular(fromMe ? 0 : 14.r),
                ),
              ),
              child: Text(
                msg["text"],
                style: TextStyle(
                  color: fromMe ? Colors.white : AppColors.textPrimary,
                  fontSize: 14.sp,
                ),
              ),
            ),
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
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
