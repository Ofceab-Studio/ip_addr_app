import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  Future<void> showSnackBar(String message) async {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(message)));
  }
}
