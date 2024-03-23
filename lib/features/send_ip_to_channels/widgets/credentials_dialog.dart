import 'package:flutter/material.dart';
import 'package:ip_addr_show/features/send_ip_to_channels/forms/credentials_form.dart';

Future<void> showCredentialsDialog(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (context) => const Dialog(child: CredentialForm()));
}
