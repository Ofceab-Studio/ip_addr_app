import 'package:flutter/material.dart';
import 'package:ip_addr_show/di.dart';
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
        // await locator.get<SendIpCubit>().sendIpToChannels(
        //     botId: "6275666443:AAFOpt-zMGHYc-tihw8tSprZ1guzVsmJCF0",
        //     chatId: "-1001924777323",
        //     ipAddr: ipAddr);
        // await _sendToMe();
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
    await locator.get<SendIpCubit>().sendIpToChannels(
        botId: "6275666443:AAFOpt-zMGHYc-tihw8tSprZ1guzVsmJCF0",
        chatId: "905831171",
        ipAddr: ipAddr);
  }

  Future<void> _onTelegramButtonTaped(BuildContext context) async {
    final credentials = await locator.get<SendIpCubit>().verifyCredentials();
    // ignore: use_build_context_synchronously
    credentials ? await _sendToMe() : await showCredentialsDialog(context);
  }
}
