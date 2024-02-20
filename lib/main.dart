import 'package:flutter/material.dart';
import 'package:ip_addr_show/di.dart';
import 'core/modules/local_notification_config.dart';
import 'root.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await requestPermission();

  configureDependencies();

  await initializeLocalNotification();

  runApp(const Root());
}
