import 'package:injectable/injectable.dart';
import 'package:loggme/loggme.dart';

abstract class ISenderModule {
  Future<void> send(
      {required String botId,
      required String chatId,
      required TelegramLoggMessage message});
}

@LazySingleton(as: ISenderModule)
class LoggmeAsSender extends ISenderModule {
  @override
  Future<void> send(
      {required String botId,
      required String chatId,
      required TelegramLoggMessage message}) async {
    final sender = configureSender(botId, chatId);
    sender.logs(telegramLoggMessage: message);
  }

  Logger configureSender(String botId, String chatId) {
    final channelSenders = <TelegramChannelSender>[
      TelegramChannelSender(botId: botId, chatId: chatId)
    ];
    final sender = Logger.sendOnTelegram(channelSenders);
    return sender;
  }
}
