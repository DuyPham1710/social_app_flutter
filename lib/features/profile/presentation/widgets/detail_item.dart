import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class DetailItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isDisabled;

  const DetailItem({
    super.key,
    required this.icon,
    required this.text,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isDisabled ? 0.4 : 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

