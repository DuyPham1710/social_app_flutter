import 'package:flutter/cupertino.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class ModalGender extends StatelessWidget {
  const ModalGender({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: Text(
        context.l10n.authChooseGender,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14.rsp(context),
          color: AppColors.textSecondary,
        ),
      ),

      actions: [
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context, "Nam");
          },
          child: Text(
            context.l10n.authGenderMale,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16.rsp(context),
            ),
          ),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context, "Nữ");
          },
          child: Text(
            context.l10n.authGenderFemale,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16.rsp(context),
            ),
          ),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context, "Khác");
          },
          child: Text(
            context.l10n.authGenderOther,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16.rsp(context),
            ),
          ),
        ),
      ],

      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Navigator.pop(context);
        },
        isDefaultAction: true,
        child: Text(
          context.l10n.commonCancel,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14.rsp(context),
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
