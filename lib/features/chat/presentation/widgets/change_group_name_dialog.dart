import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/chat/presentation/bloc/bloc.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';

class ChangeGroupNameDialog extends StatefulWidget {
  final String currentName;
  final String? conversationId;
  final String? userId;

  const ChangeGroupNameDialog({
    super.key,
    required this.currentName,
    this.conversationId,
    this.userId,
  });

  @override
  State<ChangeGroupNameDialog> createState() => _ChangeGroupNameDialogState();
}

class _ChangeGroupNameDialogState extends State<ChangeGroupNameDialog> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      contentPadding: EdgeInsets.zero,
      title: Text(
        context.l10n.chatChangeGroupName,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: TextField(
          controller: _nameController,
          autofocus: true,
          style: TextStyle(fontSize: 16.sp, color: AppColors.textPrimary),
          decoration: InputDecoration(
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.textSecondary.withOpacity(0.3),
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.textSecondary.withOpacity(0.3),
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 8.h),
          ),
          maxLength: 50,
          buildCounter:
              (
                context, {
                required currentLength,
                required isFocused,
                maxLength,
              }) {
                return null; // Ẩn counter
              },
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 16.h, 16.w, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  _nameController.clear();
                },
                child: Text(
                  context.l10n.commonRemove,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 15.sp,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  context.l10n.commonCancel,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 15.sp,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              TextButton(
                onPressed: () {
                  final newName = _nameController.text.trim();
                  if (newName.isNotEmpty) {
                    // Dispatch event để update conversation
                    if (widget.conversationId != null &&
                        widget.userId != null) {
                      try {
                        context.read<ConversationBloc>().add(
                          UpdateConversationEvent(
                            userId: widget.userId!,
                            conversationId: widget.conversationId!,
                            name: newName,
                          ),
                        );
                        Navigator.pop(context, newName);
                        showSuccessSnackBar(
                          context,
                          context.l10n.chatGroupNameChanged,
                        );
                      } catch (e) {
                        showErrorSnackBar(
                          context,
                          context.l10n.chatChangeGroupNameFailed('$e'),
                        );
                      }
                    } else {
                      Navigator.pop(context, newName);
                    }
                  }
                },
                child: Text(
                  context.l10n.commonSave,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
