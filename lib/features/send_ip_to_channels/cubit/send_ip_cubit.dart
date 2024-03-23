import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ip_addr_show/core/modules/sender_module.dart';
import 'package:ip_addr_show/core/modules/storage_module.dart';
import 'package:ip_addr_show/di.dart';
import 'package:ip_addr_show/features/send_ip_to_channels/cubit/send_ip_state.dart';
import 'package:loggme/loggme.dart';

enum ChannelsMessages {
  formSendButtonClicked("There is your ip address: "),
  fromConnectionListener("Your ip address changed to: ");

  final String message;
  const ChannelsMessages(this.message);
}

@Singleton()
class SendIpCubit extends Cubit<SendIpState> {
  final ISenderModule senderModule;
  SendIpCubit(this.senderModule) : super(InitialState());

  Future<void> sendIpToChannels(
      {required String ipAddr, bool? fromSendButton}) async {
    emit(SendToChannelsProcessing());
    await _tryCatch(fromSendButton, ipAddr);
    emit(SendToChannelsDone(ipAddr));
  }

  Future<void> _tryCatch(bool? fromSendButton, String ipAddr) async {
    try {
      if (await verifyCredentials()) {
        emit(CredentialDone());
        // Get Credentials
        final botId =
            await locator.get<IStorageHelper>().getData(isChatId: false);
        final chatId =
            await locator.get<IStorageHelper>().getData(isChatId: true);
        await _sendIp(fromSendButton, ipAddr, botId!, chatId!);
      } else {
        emit(CredentialFailed());
      }
    } catch (e) {
      emit(SendToChannelsFailed(e.toString()));
    }
  }

  Future<void> _sendIp(
      bool? fromSendButton, String ipAddr, String botId, String chatId) async {
    final message = TelegramLoggMessage()
      ..addBoldText(fromSendButton == null
          ? "${ChannelsMessages.formSendButtonClicked.message} $ipAddr"
          : "${ChannelsMessages.fromConnectionListener.message} $ipAddr")
      ..addNormalText("\n")
      ..addNormalText("\n")
      ..addNormalText("Don't forget the awesome shortcut 👇")
      ..addCodeText("adb connect $ipAddr:5555");

    await senderModule.send(botId: botId, chatId: chatId, message: message);
  }

  Future<bool> verifyCredentials() async {
    log("Verifing credentials");
    final result = await locator.get<IStorageHelper>().makeVerification();
    log(result.toString());
    return result;
  }

  Future<void> saveCredentials(
      {required String botId, required String chatId}) async {
    log("Start saving credentials");
    await locator.get<IStorageHelper>().saveData(botId, true);
    await locator.get<IStorageHelper>().saveData(chatId, false);
  }
}
