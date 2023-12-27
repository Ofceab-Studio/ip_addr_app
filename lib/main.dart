import 'package:flutter/material.dart';
import 'package:ip_addr_show/di.dart';
import 'local_notification_config.dart';
import 'root.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureDependencies();
  initializeLocalNotification();

  runApp(const Root());
}
