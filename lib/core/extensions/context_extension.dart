import 'package:flutter/material.dart';

import '../../features/ip_addr/widgets/snack_widget.dart';

extension ContextExtension on BuildContext {
  void showSnackBar(Widget child) async {
    ScaffoldMessenger.of(this).removeCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(snack(child));
  }

  void showModal(Widget child) {
    showModalBottomSheet(
      context: this,
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: child));
      },
    );
  }
}
