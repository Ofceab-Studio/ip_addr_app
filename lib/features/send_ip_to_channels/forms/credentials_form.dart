import 'package:flutter/material.dart';
import 'package:ip_addr_show/core/extensions/context_extension.dart';
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
  late final ValueNotifier<bool> _isReady;

  @override
  void initState() {
    super.initState();
    _isReady = ValueNotifier(false);
  }

  @override
  void dispose() {
    _botIdController.dispose();
    _chatIdController.dispose();
    _isReady.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Form(
        key: _forKey,
        child: Wrap(
          runSpacing: 16,
          children: [
            const Text(
                "Please provide your BotID and ChatID to receive your ip address !!!",
                style: TextStyle(fontSize: 16)),
            _buildFields(),
            _buildAction(context)
          ],
        ),
      ),
    );
  }

  Future<void> _onSaveButtonPressed() async {
    if (_botIdController.text.isNotEmpty && _chatIdController.text.isNotEmpty) {
      await locator.get<SendIpCubit>().saveCredentials(
          botId: _botIdController.text, chatId: _chatIdController.text);
      _onCredentialSuccessfulySaved();
    } else {
      context.showSnackBar(const Text("BotID and ChatID can't be null"));
    }
  }

  void _onCredentialSuccessfulySaved() {
    Navigator.of(context).pop();
    context.showSnackBar(const Text("Credentials saved !!!"));
  }

  Widget _buildAction(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ListenableBuilder(
              listenable: _isReady,
              builder: (context, _) {
                return ElevatedButton(
                    style: ButtonStyle(
                        padding: const WidgetStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 16, horizontal: 16)),
                        backgroundColor: WidgetStatePropertyAll(_isReady.value
                            ? Colors.black
                            : const Color.fromARGB(128, 158, 158, 158))),
                    onPressed: _isReady.value ? _onSaveButtonPressed : null,
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ));
              }),
        ),
      ],
    );
  }

  Column _buildFields() {
    return Column(
      children: [
        TextFormField(
          onChanged: (value) => _validateForm(),
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
          onChanged: (value) => _validateForm(),
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

  void _validateForm() {
    _isReady.value =
        _botIdController.text.isNotEmpty && _chatIdController.text.isNotEmpty;
  }
}
