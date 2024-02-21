import 'package:flutter/material.dart';
import 'package:ip_addr_show/di.dart';
import 'package:ip_addr_show/features/ip_addr/widgets/snack_widget.dart';
import 'package:ip_addr_show/features/send_ip_to_channels/cubit/send_ip_cubit.dart';
import 'package:ip_addr_show/features/send_ip_to_channels/widgets/credentials_dialog.dart';

class SenderWidget extends StatelessWidget {
  final String ipAddr;
  const SenderWidget({super.key, required this.ipAddr});

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
    await locator.get<SendIpCubit>().sendIpToChannels(ipAddr: ipAddr);
  }

  Future<void> _onTelegramButtonTaped(BuildContext context) async {
    final credentials = await locator.get<SendIpCubit>().verifyCredentials();
    if (credentials) {
      await _sendToMe();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(snack(const Text("Sending your ip address ...")));
    } else {
      // ignore: use_build_context_synchronously
      await showCredentialsDialog(context);
    }
  }
}
