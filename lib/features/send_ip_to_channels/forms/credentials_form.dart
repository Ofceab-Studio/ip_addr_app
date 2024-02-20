import 'package:flutter/material.dart';
import 'package:ip_addr_show/di.dart';
import 'package:ip_addr_show/features/send_ip_to_channels/cubit/send_ip_cubit.dart';

class CredentialForm extends StatefulWidget {
  const CredentialForm({super.key});

  @override
  State<CredentialForm> createState() => _CredentialFormState();
}

class _CredentialFormState extends State<CredentialForm> {
  final GlobalKey<FormState> _forKey = GlobalKey<FormState>();
  final TextEditingController _botIdController = TextEditingController();
  final TextEditingController _chatIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _botIdController.dispose();
    _chatIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _forKey,
        child: Column(
          children: [
            const Text("Please provide your botId and chatId first !!!"),
            const SizedBox(height: 10),
            TextFormField(
              controller: _botIdController,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.only(left: 20, top: 16, bottom: 16),
                fillColor: Colors.white,
                filled: true,
                hintText: "BotId",
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _chatIdController,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.only(left: 20, top: 16, bottom: 16),
                fillColor: Colors.white,
                filled: true,
                hintText: "ChatId",
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: _onSaveButtonPressed, child: const Text("Save"))
          ],
        ));
  }

  Future<void> _onSaveButtonPressed() async {
    await locator.get<SendIpCubit>().saveCredentials(
        botId: _botIdController.text, chatId: _chatIdController.text);
  }
}
