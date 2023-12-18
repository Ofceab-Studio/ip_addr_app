import 'package:injectable/injectable.dart';
import 'package:network_info_plus/network_info_plus.dart';

@Singleton()
class NetWorkModule {
  final _netw = NetworkInfo();
  NetworkInfo get netw => _netw;
}
