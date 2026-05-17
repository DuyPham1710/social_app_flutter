import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Future<dynamic> showDialogSuccess(
  BuildContext parentContext,
  String message, {
  bool? isNavigateLogin = true,
}) {
  return showDialog(
    barrierDismissible: false,
    context: parentContext,
    builder: (dialogContext) {
      Future.delayed(Duration(seconds: 3), () {
        Navigator.of(dialogContext).pop(); // đóng dialog
        if (isNavigateLogin == true) {
          Navigator.pushReplacementNamed(parentContext, '/login');
        }
        // Navigator.pushNamed(context, '/login');
      });

      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'animations/success.json',
                width: 120,
                height: 120,
                repeat: false,
              ),
              SizedBox(height: 10),
              Text(
                '$message!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    },
  );
}
