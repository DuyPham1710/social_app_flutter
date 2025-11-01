import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/friend/presentation/bloc/friend_bloc.dart';
import 'package:social_app_fe/features/post/domain/entities/react_post_entity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/features/post/presentation/widgets/react_widgets/react_item_widget.dart';

class ReactListWidget extends StatelessWidget {
  final List<ReactPostEntity> reacts;
  const ReactListWidget({super.key, required this.reacts});

  @override
  Widget build(BuildContext context) {
    if (reacts.isEmpty) {
      return Center(
        child: Text(
          'Chưa có ai bày tỏ cảm xúc',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
        ),
      );
    }

    return BlocBuilder<FriendBloc, FriendState>(
      builder: (context, state) {
        if (state is FriendLoading) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final Map<String, String> receiverToRequestId = {};
        final Set<String> receiverIds = {};

        if (state is SentFriendRequestsLoaded) {
          final sentRequests = state.sentRequests;
          final cancelled = state.cancelledRequestIds;

          for (final req in sentRequests) {
            // Skip requests that were cancelled during this session
            if (cancelled.contains(req.requestId)) continue;

            String? rid;
            if (req.receiverId is String) {
              rid = req.receiverId as String?;
            } else if (req.receiverId is Map<String, dynamic>) {
              rid = (req.receiverId as Map<String, dynamic>)['_id'] as String?;
            }

            if (rid != null) {
              receiverIds.add(rid);
              receiverToRequestId[rid] = req.requestId;
            }
          }
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          itemCount: reacts.length,
          itemBuilder: (context, index) {
            final react = reacts[index];

            final reactReceiverId = react.user.userId;

            final isSend = receiverIds.contains(reactReceiverId);
            // print('>>> isSend for ${react.user.userId}: $isSend');
            final requestId = receiverToRequestId[reactReceiverId];

            return ReactItemWidget(
              react: react,
              isSend: isSend,
              requestId: requestId,
            );
          },
        );
      },
    );
  }
}
