
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
      {required String botId,
      required String chatId,
      required String ipAddr,
      bool? fromSendTutton}) async {
    emit(SendToChannelsProcessing());
    try {
      if (await verifyCredentials()) {
        emit(CredentialDone());
        await _sendIp(fromSendTutton, ipAddr, botId, chatId);
      } else {
        emit(CredentialFailed());
      }
    } catch (e) {
      emit(SendToChannelsFailed(e.toString()));
    }
    emit(SendToChannelsDone(ipAddr));
  }

  Future<void> _sendIp(
      bool? fromSendTutton, String ipAddr, String botId, String chatId) async {
    final message = TelegramLoggMessage()
      ..addBoldText(fromSendTutton == null
          ? "${ChannelsMessages.formSendButtonClicked.message} $ipAddr"
          : "${ChannelsMessages.fromConnectionListener.message} $ipAddr")
      ..addNormalText("\n")
      ..addNormalText("Don't forget the awesome shortcut 👇")
      ..addCodeText("adb connect $ipAddr:5555");

    await senderModule.send(botId: botId, chatId: chatId, message: message);
  }

  Future<bool> verifyCredentials() async {
    return await locator.get<IStorageHelper>().getData();
  }

  Future<void> saveCredentials(
      {required String botId, required String chatId}) async {
    await locator.get<IStorageHelper>().saveData(botId);
    await locator.get<IStorageHelper>().saveData(chatId);
  }
}
