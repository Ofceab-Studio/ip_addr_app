import 'package:injectable/injectable.dart';
import 'package:network_info_plus/network_info_plus.dart';

abstract class INetworkModule {
  NetworkInfo getNetworkInfo();
}

@Singleton(as: INetworkModule)
class NetWorkModule implements INetworkModule {
  @override
  NetworkInfo getNetworkInfo() {
    final netw = NetworkInfo();
    return netw;
  }
}
