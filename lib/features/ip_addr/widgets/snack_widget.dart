import 'package:flutter/material.dart';

SnackBar snack(Widget content) {
  return SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(bottom: 70, left: 20, right: 20),
      showCloseIcon: true,
      closeIconColor: Colors.white,
      content: content);
}
