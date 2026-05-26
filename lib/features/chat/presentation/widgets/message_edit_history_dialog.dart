import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/date_time_extensions.dart';
import 'package:social_app_fe/features/chat/domain/entities/chat_entities.dart';
import 'package:social_app_fe/features/chat/domain/entities/message-edit-log_entity.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class MessageEditHistoryDialog {
  static void show({
    required BuildContext context,
    required MessageEntity message,
    required List<MessageEditLogEntity> editLogs,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) =>
          _MessageEditHistoryDialog(message: message, editLogs: editLogs),
    );
  }
}

class _MessageEditHistoryDialog extends StatelessWidget {
  final MessageEntity message;
  final List<MessageEditLogEntity> editLogs;

  const _MessageEditHistoryDialog({
    required this.message,
    required this.editLogs,
  });

  @override
  Widget build(BuildContext context) {
    // Tạo list bao gồm message hiện tại + các edit logs
    // message hiện tại ở đầu
    final allVersions = <_MessageVersion>[
      _MessageVersion(
        text: message.text ?? '',
        timestamp: message.updatedAt ?? message.createdAt,
        isCurrent: true,
      ),
      ...editLogs.map(
        (log) => _MessageVersion(
          text: log.oldText,
          timestamp: log.editedAt,
          isCurrent: false,
        ),
      ),
    ];

    // Sort từ mới nhất đến cũ nhất
    // allVersions.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return Container(
      height: 0.7.sh,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: DefaultTextStyle.merge(
        style: const TextStyle(
          decoration: TextDecoration.none,
          fontFamily: 'Roboto',
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.textSecondary.withOpacity(0.2),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      context.l10n.messageEditHistoryTitle,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      context.l10n.messageHideEditHistory,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // List of versions
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                itemCount: allVersions.length,
                itemBuilder: (context, index) {
                  final version = allVersions[index];

                  return Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 4.h,
                    ),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: version.isCurrent
                          ? AppColors.primary.withOpacity(0.1)
                          : AppColors.textSecondary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12.r),
                      border: version.isCurrent
                          ? Border.all(
                              color: AppColors.primary.withOpacity(0.3),
                              width: 1,
                            )
                          : null,
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (version.isCurrent)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  context.l10n.messageCurrentVersion,
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                            if (version.isCurrent) SizedBox(width: 8.w),

                            Text(
                              version.timestamp.formatTimeHeader(),
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 8.h),

                        Text(
                          version.text,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textPrimary,
                            fontWeight: version.isCurrent
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageVersion {
  final String text;
  final DateTime timestamp;
  final bool isCurrent;

  _MessageVersion({
    required this.text,
    required this.timestamp,
    required this.isCurrent,
  });
}
