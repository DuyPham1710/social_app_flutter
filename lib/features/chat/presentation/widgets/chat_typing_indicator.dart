import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/chat/presentation/bloc/bloc.dart';

class ChatTypingIndicator extends StatelessWidget {
  final String? friendAvatarUrl;
  final String? friendName;
  final String currentUserId;

  const ChatTypingIndicator({
    super.key,
    this.friendAvatarUrl,
    this.friendName,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageBloc, MessageState>(
      builder: (context, state) {
        // Check if MessagesLoaded with typing and not from current user
        if (state is MessagesLoaded &&
            state.isTyping &&
            state.typingUserId != null &&
            state.typingUserId != currentUserId) {
          return Container(
            padding: EdgeInsets.fromLTRB(0.w, 8.h, 12.w, 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar của friend đang gõ
                CircleAvatar(
                  radius: 14.r,
                  backgroundImage: NetworkImage(
                    friendAvatarUrl ?? "https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg",
                  ),
                ),
                SizedBox(width: 8.w),
                // Animation dots
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 28.w,
                        height: 20.h,
                        child: ClipRect(
                          child: OverflowBox(
                            maxWidth: 100.w,
                            maxHeight: 80.h,
                            child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                AppColors.textSecondary,
                                BlendMode.srcATop,
                              ),
                              child: Lottie.asset(
                                'animations/dots_loader.json',
                                repeat: true,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
