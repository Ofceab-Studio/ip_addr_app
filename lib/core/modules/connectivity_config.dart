import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

@module
abstract class ConnectivityInitializer {
  final Connectivity _connInstance = Connectivity();
  @Named('conn')
  @Singleton()
  Connectivity get conn => _connInstance;
}
