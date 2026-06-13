import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/comment/presentation/bloc/comment_bloc.dart';
import 'package:social_app_fe/features/comment/presentation/bloc/comment_state.dart';

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentState>(
      builder: (context, state) {
        if (state is CommentJoined && state.typingUsers.isNotEmpty) {
          final typingUsers = state.typingUsers.toList();
          String typingText;

          if (typingUsers.length == 1) {
            typingText = '${typingUsers[0].username ?? 'Someone'} is typing...';
          } else if (typingUsers.length == 2) {
            typingText =
                '${typingUsers[0].username ?? 'Someone'} and ${typingUsers[1].username ?? 'someone'} are typing...';
          } else {
            typingText =
                '${typingUsers[0].username ?? 'Someone'} and ${typingUsers.length - 1} others are typing...';
          }

          return Container(
            padding: EdgeInsets.fromLTRB(16.rs(context), 8.rsh(context), 16.rs(context), 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //_buildTypingDots(),
                SizedBox(
                  width: 36.rs(context),
                  height: 26.rsh(context),
                  child: ClipRect(
                    child: OverflowBox(
                      maxWidth: 100.rs(context),
                      maxHeight: 80.rsh(context),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          AppColors.textSecondary, // Màu giống với text
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
                SizedBox(width: 8.rs(context)),

                Expanded(
                  child: Text(
                    typingText,
                    style: TextStyle(
                      fontSize: 12.rsp(context),
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
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
