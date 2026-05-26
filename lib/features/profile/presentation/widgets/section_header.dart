import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onEditTap;

  const SectionHeader({
    super.key,
    required this.title,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        GestureDetector(
          onTap: onEditTap,
          child: Text(
            context.l10n.profileEdit,
            style: TextStyle(color: AppColors.primary, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
