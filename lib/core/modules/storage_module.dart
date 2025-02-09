import 'package:encrypt/encrypt.dart';
import 'package:injectable/injectable.dart';
import 'package:ip_addr_show/di.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class StorageParams {
  @Named("botId")
  String get botId => "QKClrA5VpnMgjnvjGadprQ==";

  @Named("chatId")
  String get chatId => "4UxtywUZdsFm6mKg2d2p6w==";
}

class EncrypterParams {
  static final Key key = Key.fromUtf8('keyPad');
  static final IV iv = IV.fromLength(16);
}

abstract class IStorageHelper {
  Future<void> saveData(String value, bool isBotId);
  Future<bool> makeVerification();
  Future<String?> getData({required bool isChatId});
}

@LazySingleton(as: IStorageHelper)
class StorageHelper implements IStorageHelper {
  final Future<SharedPreferences> _shraedPref = SharedPreferences.getInstance();
  final Encrypter encrypter = Encrypter(AES(EncrypterParams.key));

  @override
  Future<bool> makeVerification() async {
    final chatId = await getData(isChatId: true);
    final botId = await getData(isChatId: false);
    if (chatId != null &&
        botId != null &&
        chatId.isNotEmpty &&
        botId.isNotEmpty) {
      return true;
    }
    return false;
  }

  @override
  Future<String?> getData({required bool isChatId}) async {
    final SharedPreferences instance = await _shraedPref;
    final String? botId =
        instance.getString(locator.get<String>(instanceName: "botId"));
    final String? chatId =
        instance.getString(locator.get<String>(instanceName: "chatId"));
    return isChatId ? _decryptCredentials(chatId) : _decryptCredentials(botId);
  }

  @override
  Future<void> saveData(String value, bool isBotId) async {
    final SharedPreferences instance = await _shraedPref;
    final encryptedValue = _encryptCredentials(value);
    instance.setString(
        locator.get<String>(instanceName: isBotId ? "botId" : "chatId"),
        encryptedValue);
  }

  String _encryptCredentials(String value) {
    // Encrypt value
    return value;
  }

  String? _decryptCredentials(String? value) {
    // Decrypt value
    return value;
  }
}
