import 'package:flutter/material.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';

void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: ResponsiveHelper.isWebOrDesktop ? null : const EdgeInsets.all(16),
      width: ResponsiveHelper.isWebOrDesktop ? 400.0 : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: const Color.fromARGB(255, 247, 37, 72),
      content: Row(
        children: [
          const Icon(Icons.error_rounded, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 3),
    ),
  );
}
