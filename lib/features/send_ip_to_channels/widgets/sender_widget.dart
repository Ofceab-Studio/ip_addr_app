import 'package:flutter/material.dart';
import 'package:ip_addr_show/core/extensions/context_extension.dart';
import 'package:ip_addr_show/di.dart';
import 'package:ip_addr_show/features/send_ip_to_channels/cubit/send_ip_cubit.dart';
import 'package:ip_addr_show/features/send_ip_to_channels/forms/credentials_form.dart';

class SenderWidget extends StatefulWidget {
  final String ipAddr;
  const SenderWidget({super.key, required this.ipAddr});

  @override
  State<SenderWidget> createState() => _SenderWidgetState();
}

class _SenderWidgetState extends State<SenderWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await _onTelegramButtonTaped(context);
      },
      child: Container(
          padding: const EdgeInsets.all(10),
          child: const Icon(
            Icons.telegram,
            size: 70,
          )),
    );
  }

  Future<void> _sendToMe() async {
    await locator.get<SendIpCubit>().sendIpToChannels(ipAddr: widget.ipAddr);
  }

  Future<void> _onTelegramButtonTaped(BuildContext context) async {
    final credentials = await locator.get<SendIpCubit>().verifyCredentials();
    if (credentials) {
      _showSendingMessage();
      await _sendToMe();
    } else {
      _showCredentialsForm();
    }
  }

  void _showSendingMessage() =>
      context.showSnackBar(const Text('Sending your ip address ...'));

  void _showCredentialsForm() {
    context.showModal(const CredentialForm());
  }
}
