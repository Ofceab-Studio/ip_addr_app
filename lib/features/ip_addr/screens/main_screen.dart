import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ip_addr_show/features/ip_addr/cubit/ip_addr_cubit.dart';
import 'package:ip_addr_show/features/ip_addr/cubit/ip_addr_state.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ip_addr_show/core/modules/local_notification_config.dart';
import '../../../di.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ValueNotifier<bool> _isDisable = ValueNotifier(false);
  final Connectivity conn = locator.get<Connectivity>(instanceName: 'conn');

  @override
  void initState() {
    conn.onConnectivityChanged.listen((event) {
      locator.get<IpAddrCubit>().fetchIpAddr();
      _sendNofitication();
    });
    super.initState();
  }

  @override
  void dispose() {
    _isDisable.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            BlocBuilder<IpAddrCubit, IpAddrState>(
              builder: (context, state) {
                if (state is IpAddrInitialState ||
                    state is IpAddrIsProcessing) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is IpAddrDone) {
                  return Center(
                    child: _buildIpAddr(context, state.ipAddr),
                  );
                } else {
                  return const Center(
                    child: Text("Something wrong"),
                  );
                }
              },
            ),
            ListenableBuilder(
                listenable: _isDisable,
                builder: (context, _) {
                  if (_isDisable.value) {
                    return _buildHintWidget(context, _buildIcon(context));
                  }
                  return _buildHintWidget(context, _buildTextWithIcon(context));
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildIpAddr(BuildContext context, String ipAddr) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () async {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Copied to clipboad")));
            await Clipboard.setData(ClipboardData(text: ipAddr));
          },
          child: Container(
              padding: const EdgeInsets.all(10), child: const Icon(Icons.copy)),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(ipAddr, style: const TextStyle(fontSize: 24)),
        const SizedBox(
          height: 15,
        ),
        InkWell(
          onTap: () async {
            locator<IpAddrCubit>().fetchIpAddr();
          },
          child: Container(
              padding: const EdgeInsets.all(10),
              child: const Icon(Icons.replay_outlined)),
        )
      ],
    );
  }

  Widget _buildHintWidget(BuildContext context, List<Widget> widgets) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: widgets,
    );
  }

  List<Widget> _buildTextWithIcon(BuildContext context) {
    return [
      const Text(
        "There is a widget available for app. try it!",
        style: TextStyle(fontSize: 16),
      ),
      const SizedBox(
        width: 10,
      ),
      InkWell(
        onTap: () => _isDisable.value = !_isDisable.value,
        child: const Icon(Icons.close),
      )
    ];
  }

  List<Widget> _buildIcon(BuildContext context) {
    return [
      InkWell(
        onTap: () => _isDisable.value = !_isDisable.value,
        child: const Icon(Icons.info),
      )
    ];
  }

  Future<void> _sendNofitication() async {
    await requestPermission();
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
}
