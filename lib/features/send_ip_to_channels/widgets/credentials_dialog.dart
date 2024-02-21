import 'package:flutter/material.dart';
import 'package:ip_addr_show/features/send_ip_to_channels/forms/credentials_form.dart';

Future<void> showCredentialsDialog(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (context) => Dialog(
          child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              height: 280,
              child: const CredentialForm())));
}
