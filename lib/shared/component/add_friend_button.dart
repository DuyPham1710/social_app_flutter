import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/features/friend/presentation/bloc/friend_bloc.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class AddFriendButton extends StatelessWidget {
  final String userId;
  final bool isSend;
  final String? requestId;

  const AddFriendButton({
    super.key,
    required this.userId,
    required this.isSend,
    this.requestId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!isSend) {
          context.read<FriendBloc>().add(SendFriendRequest(receiverId: userId));
        } else {
          final idToCancel = requestId ?? userId;

          context.read<FriendBloc>().add(
            CancelSentFriendRequest(requestId: idToCancel),
          );
        }
      },

      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.rs(context),
          vertical: 8.rsh(context),
        ),
        decoration: BoxDecoration(
          color: isSend ? Colors.grey[200] : AppColors.primary,
          borderRadius: BorderRadius.circular(6.rsr(context)),
        ),
        child: isSend
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    CupertinoIcons.person_badge_minus,
                    color: Colors.grey[600],
                    size: 16.rsr(context),
                  ),
                  SizedBox(width: 8.rs(context)),
                  Text(
                    context.l10n.friendCancelRequest,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12.rsp(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : Text(
                context.l10n.friendAdd,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.rsp(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
