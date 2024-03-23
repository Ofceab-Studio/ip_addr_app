import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:ip_addr_show/core/extensions/context_extension.dart';
import 'package:ip_addr_show/di.dart';
import 'package:ip_addr_show/root.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class INotificationModule {
  get plugin;
}

@Singleton(as: INotificationModule)
class LocalNotificationModule implements INotificationModule {
  @override
  FlutterLocalNotificationsPlugin get plugin =>
      FlutterLocalNotificationsPlugin();
}

Future<void> initializeLocalNotification() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_launcher_background');

  const LinuxInitializationSettings initializationSettingsLinux =
      LinuxInitializationSettings(defaultActionName: 'Open notification');

  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      linux: initializationSettingsLinux);

  final pl = locator.get<INotificationModule>().plugin;
  if (pl is FlutterLocalNotificationsPlugin) {
    await pl.initialize(
      initializationSettings,
    );
  } else {
    navKey.currentContext
        ?.showSnackBar("Unable to initialize local notification plugin");
  }
}

Future<void> requestNotificationPermission() async {
  final status = await Permission.notification.isDenied;
  if (status) {
    Permission.notification.request();
  }
}

Future<void> sendNofitication() async {
  await requestNotificationPermission();
  final plugin = locator.get<INotificationModule>().plugin
      as FlutterLocalNotificationsPlugin;
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails("0", 'IPChannelName',
          channelDescription: 'IPChannelName',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);
  await plugin.show(
    0,
    'Your ip address changed bro',
    'See ip widget to save your time !!!',
    notificationDetails,
  );
}
