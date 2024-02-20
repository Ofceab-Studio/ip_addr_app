import 'package:injectable/injectable.dart';
import 'package:ip_addr_show/di.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class StorageModule {
  @Singleton()
  @Name("botId")
  String get botId => "QKClrA5VpnMgjnvjGadprQ==";

  @Singleton()
  @Name("chatId")
  String get chatId => "4UxtywUZdsFm6mKg2d2p6w==";
}

abstract class IStorageHelper {
  Future<void> saveData(String value);
  Future<bool> getData();
}

@LazySingleton(as: IStorageHelper)
class StorageHelper implements IStorageHelper {
  final Future<SharedPreferences> shraedPref = SharedPreferences.getInstance();

  @override
  Future<bool> getData() async {
    final instance = await shraedPref;
    final chatId =
        instance.getString(locator.get<String>(instanceName: "chatId"));
    final botId =
        instance.getString(locator.get<String>(instanceName: "botId"));
    if (chatId != null &&
        botId != null &&
        chatId.isNotEmpty &&
        botId.isNotEmpty) {
      return true;
    }
    return false;
  }

  @override
  Future<void> saveData(String value) async {
    final instance = await shraedPref;
    instance.setString(locator.get<String>(instanceName: "chatId"), value);
  }
}
