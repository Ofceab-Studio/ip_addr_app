import 'package:flutter/material.dart';
import 'package:ip_addr_show/di.dart';
import 'package:ip_addr_show/features/ip_addr/widgets/snack_widget.dart';
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Form(
        key: _forKey,
        child: Wrap(
          runSpacing: 10,
          children: [
            const Text(
                "Please provide your BotID and ChatID to receive your ip address !!!",
                style: TextStyle(fontSize: 16)),
            _buildFields(),
            _buildActions(context)
          ],
        ),
      ),
    );
  }

  Future<void> _onSaveButtonPressed() async {
    if (_botIdController.text.isNotEmpty && _chatIdController.text.isNotEmpty) {
      await locator.get<SendIpCubit>().saveCredentials(
          botId: _botIdController.text, chatId: _chatIdController.text);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(snack(const Text("Credentials saved !!!")));
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(snack(const Text("BotID and ChatID can't be null")));
    }
  }

  Row _buildActions(BuildContext context) {
    return Row(
      children: [
        OutlinedButton(
            style: const ButtonStyle(
                padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(vertical: 16, horizontal: 16))),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.black),
            )),
        const SizedBox(
          width: 10,
        ),
        ElevatedButton(
            style: const ButtonStyle(
                padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(vertical: 16, horizontal: 16)),
                backgroundColor: WidgetStatePropertyAll(Colors.black)),
            onPressed: _onSaveButtonPressed,
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.white),
            ))
      ],
    );
  }

  Column _buildFields() {
    return Column(
      children: [
        TextFormField(
          controller: _botIdController,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: 10),
            hintText: "BotID",
            hintStyle: const TextStyle(fontSize: 14),
            border: OutlineInputBorder(
                borderSide: const BorderSide(),
                borderRadius: BorderRadius.circular(5)),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          controller: _chatIdController,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: 10),
            hintText: "ChatID",
            hintStyle: const TextStyle(fontSize: 14),
            border: OutlineInputBorder(
                borderSide: const BorderSide(),
                borderRadius: BorderRadius.circular(5)),
          ),
        ),
      ],
    );
  }
}
