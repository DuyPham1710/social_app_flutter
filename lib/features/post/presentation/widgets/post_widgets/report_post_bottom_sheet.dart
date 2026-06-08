import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/di/injection.dart' as di;
import 'package:social_app_fe/features/post/domain/usecases/report_post_usecase.dart';
import 'package:social_app_fe/l10n/generated/app_localizations.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_info_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';

class ReportPostBottomSheet extends StatefulWidget {
  final String postId;
  final String? ownerUserId;

  const ReportPostBottomSheet({
    super.key,
    required this.postId,
    this.ownerUserId,
  });

  static Future<void> show(
    BuildContext context, {
    required String postId,
    String? ownerUserId,
  }) async {
    final userData = await TokenStorage.getUserData();
    if (!context.mounted) return;

    final currentUserId = userData?['id'];
    final l10n = context.l10n;

    // Không cho phép báo cáo bài viết của chính mình
    if (currentUserId != null &&
        ownerUserId != null &&
        ownerUserId == currentUserId) {
      showErrorSnackBar(context, l10n.postReportSelfNotAllowed);
      return;
    }

    if (ResponsiveHelper.isWebOrDesktop) {
      showDialog(
        context: context,
        builder: (ctx) {
          return Dialog(
            backgroundColor: AppColors.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.rsr(ctx)),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 480.rs(ctx)),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(24.rs(ctx)),
                  child: ReportPostBottomSheet(
                    postId: postId,
                    ownerUserId: ownerUserId,
                  ),
                ),
              ),
            ),
          );
        },
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.background,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (ctx) {
          return Padding(
            padding: EdgeInsets.only(
              left: 16.rs(context),
              right: 16.rs(context),
              top: 16.rsh(context),
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 16.rsh(context),
            ),
            child: ReportPostBottomSheet(
              postId: postId,
              ownerUserId: ownerUserId,
            ),
          );
        },
      );
    }
  }

  @override
  State<ReportPostBottomSheet> createState() => _ReportPostBottomSheetState();
}

class _ReportPostBottomSheetState extends State<ReportPostBottomSheet> {
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedReason;
  bool _isSubmitting = false;

  List<String> _quickReasons(AppLocalizations l10n) => [
    l10n.postReportReasonOffensive,
    l10n.postReportReasonViolence,
    l10n.postReportReasonSpam,
    l10n.postReportReasonMisinformation,
    l10n.postReportReasonHarassment,
  ];

  @override
  void dispose() {
    _reasonController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final l10n = context.l10n;
    final reasonText = _reasonController.text.trim();
    final descriptionText = _descriptionController.text.trim();
    final finalReason = reasonText.isNotEmpty ? reasonText : _selectedReason;

    if (finalReason == null || finalReason.isEmpty) {
      showInfoSnackBar(context, l10n.postReportReasonRequired);
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final usecase = di.s1<ReportPostUseCase>();
    final result = await usecase(
      params: ReportPostParams(
        postId: widget.postId,
        reason: finalReason,
        description: descriptionText.isEmpty ? null : descriptionText,
      ),
    );

    setState(() {
      _isSubmitting = false;
    });

    if (result is DataStateSuccess) {
      if (mounted) {
        Navigator.of(context).pop();
        showSuccessSnackBar(context, l10n.postReportSuccess);
      }
    } else {
      if (mounted) {
        showErrorSnackBar(context, l10n.postReportFailed);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final quickReasons = _quickReasons(l10n);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 36.rs(context),
              height: 36.rs(context),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.flag_outlined, color: Colors.red),
            ),
            SizedBox(width: 12.rs(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.postReportTitle,
                    style: TextStyle(
                      fontSize: 18.rsp(context),
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.rsh(context)),
                  Text(
                    l10n.postReportIntro,
                    style: TextStyle(
                      fontSize: 12.rsp(context),
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16.rsh(context)),
        Text(
          l10n.postReportQuickReason,
          style: TextStyle(
            fontSize: 13.rsp(context),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),

        SizedBox(height: 8.rsh(context)),

        Wrap(
          spacing: 8.rs(context),
          runSpacing: 8.rsh(context),
          children: quickReasons.map((reason) {
            final isSelected = _selectedReason == reason;
            return ChoiceChip(
              label: Text(
                reason,
                style: TextStyle(
                  fontSize: 12.rsp(context),
                  color: isSelected
                      ? AppColors.background
                      : AppColors.textPrimary,
                ),
              ),
              selected: isSelected,
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.secondBackground,
              checkmarkColor: isSelected ? AppColors.background : null,
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.divider,
              ),
              onSelected: (selected) {
                setState(() {
                  _selectedReason = selected ? reason : null;
                  if (selected && _reasonController.text.isEmpty) {
                    // Gợi ý lý do vào textfield nếu đang trống
                    _reasonController.text = reason;
                  }
                });
              },
            );
          }).toList(),
        ),
        SizedBox(height: 16.rsh(context)),
        Text(
          l10n.postReportDetailReason,
          style: TextStyle(
            fontSize: 13.rsp(context),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.rsh(context)),
        TextField(
          controller: _reasonController,
          style: TextStyle(
            fontSize: 14.rsp(context),
            color: AppColors.textPrimary,
          ),
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            hintText: l10n.postReportReasonHint,
            hintStyle: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14.rsp(context),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.rs(context),
              vertical: 10.rsh(context),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.rsr(context)),
              borderSide: BorderSide(color: AppColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.rsr(context)),
              borderSide: BorderSide(color: AppColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.rsr(context)),
              borderSide: BorderSide(color: AppColors.primary),
            ),
            fillColor: AppColors.secondBackground,
            filled: true,
          ),
        ),
        SizedBox(height: 12.rsh(context)),
        Text(
          l10n.postReportDescriptionLabel,
          style: TextStyle(
            fontSize: 13.rsp(context),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.rsh(context)),
        TextField(
          controller: _descriptionController,
          maxLines: 3,
          style: TextStyle(
            fontSize: 14.rsp(context),
            color: AppColors.textPrimary,
          ),
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            hintText: l10n.postReportDescriptionHint,
            hintStyle: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14.rsp(context),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.rs(context),
              vertical: 10.rsh(context),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.rsr(context)),
              borderSide: BorderSide(color: AppColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.rsr(context)),
              borderSide: BorderSide(color: AppColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.rsr(context)),
              borderSide: BorderSide(color: AppColors.primary),
            ),
            fillColor: AppColors.secondBackground,
            filled: true,
          ),
        ),
        SizedBox(height: 16.rsh(context)),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: ButtonStyle(
                  side: WidgetStateProperty.all(
                    BorderSide(color: AppColors.divider),
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.rsr(context)),
                    ),
                  ),
                ),
                onPressed: _isSubmitting
                    ? null
                    : () {
                        Navigator.of(context).pop();
                      },
                child: Text(
                  l10n.commonCancel,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14.rsp(context),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.rs(context)),
            Expanded(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(AppColors.primary),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.rsr(context)),
                    ),
                  ),
                ),
                onPressed: _isSubmitting ? null : _handleSubmit,
                child: _isSubmitting
                    ? SizedBox(
                        width: 18.rs(context),
                        height: 18.rs(context),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.background,
                          ),
                        ),
                      )
                    : Text(
                        l10n.postSendReport,
                        style: TextStyle(
                          fontSize: 14.rsp(context),
                          color: AppColors.background,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
