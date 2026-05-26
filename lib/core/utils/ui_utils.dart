import 'package:flutter/material.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';

class UIUtils {
  static void showErrorMessage(BuildContext context, String message) {
    if (message.contains('\n')) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(context.l10n.authErrorTitle),
          content: SingleChildScrollView(child: Text(message)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(context.l10n.commonOk),
            ),
          ],
        ),
      );
    } else {
      showErrorSnackBar(context, message);
    }
  }

  /// Show success message in SnackBar
  static void showSuccessMessage(BuildContext context, String message) {
    print('>>>Resend OTP success: $message');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Show info message in SnackBar
  static void showInfoMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
