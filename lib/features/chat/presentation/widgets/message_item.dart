import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/chat/domain/entities/chat_entities.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageItem extends StatelessWidget {
  final MessageEntity message;
  final bool fromMe;
  final bool showAvatar;

  const MessageItem({
    super.key,
    required this.message,
    required this.fromMe,
    required this.showAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 10.h,
        left: fromMe ? 60.w : 0,
        right: fromMe ? 0 : 60.w,
      ),
      child: Row(
        mainAxisAlignment: fromMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!fromMe) ...[
            if (showAvatar)
              CircleAvatar(
                radius: 14.r,
                backgroundImage: NetworkImage(
                  message.sender.avatarUrl ?? "https://i.pravatar.cc/200",
                ),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.text != null && message.text!.isNotEmpty)
                    Text(
                      message.text!,
                      style: TextStyle(
                        color: fromMe ? Colors.white : AppColors.textPrimary,
                        fontSize: 14.sp,
                      ),
                    ),

                  // Show attachments if any
                  if (message.attachments.isNotEmpty)
                    ...message.attachments.map(
                      (attachment) => Container(
                        margin: EdgeInsets.only(top: 4.h),
                        child: Text(
                          '[${attachment.type.toUpperCase()}] ${attachment.url}',
                          style: TextStyle(
                            color: fromMe
                                ? Colors.white70
                                : AppColors.textSecondary,
                            fontSize: 12.sp,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),

                  // Show reactions if any
                  if (message.reactions.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(top: 4.h),
                      child: Wrap(
                        children: message.reactions
                            .map(
                              (reaction) => Text(
                                reaction.reaction,
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
