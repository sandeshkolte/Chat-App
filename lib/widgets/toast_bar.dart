import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/material.dart';

class Utils {
  toastmessage(context, String message, position) {
    DelightToastBar(
      position: position,
      snackbarDuration: const Duration(milliseconds: 2000),
      autoDismiss: true,
      builder: (context) => ToastCard(
        color: Theme.of(context).primaryColor,
        title: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    ).show(context);
  }
}
