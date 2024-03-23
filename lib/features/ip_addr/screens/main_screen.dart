import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ip_addr_show/features/ip_addr/cubit/ip_addr_cubit.dart';
import 'package:ip_addr_show/features/ip_addr/cubit/ip_addr_state.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ip_addr_show/core/modules/local_notification_config.dart';
import 'package:ip_addr_show/features/send_ip_to_channels/widgets/sender_widget.dart';
import '../../../di.dart';
import '../widgets/snack_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ValueNotifier<bool> _isDisable = ValueNotifier(false);
  final ValueNotifier<String> _ipAddr = ValueNotifier("");

  @override
  void initState() {
    final Connectivity conn = locator.get<Connectivity>(instanceName: 'conn');
    final listener = conn.onConnectivityChanged.skip(1);
    listener.listen((event) {
      sendNofitication();
      locator.get<IpAddrCubit>().fetchIpAddr();
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
            _buildIpAddrWithActions(),
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

  Widget _buildIpAddr(
    BuildContext context,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(_ipAddr.value, style: const TextStyle(fontSize: 24)),
      ],
    );
  }

  InkWell _refreshIp() {
    return InkWell(
      onTap: () async {
        locator<IpAddrCubit>().fetchIpAddr();
      },
      child: Container(
          padding: const EdgeInsets.all(10),
          child: const Icon(Icons.replay_outlined)),
    );
  }

  InkWell _copieToClipBoard(BuildContext context) {
    return InkWell(
      onTap: () async {
        ScaffoldMessenger.of(context)
            .showSnackBar(snack(const Text("Copied to clipboad")));
        await Clipboard.setData(ClipboardData(text: _ipAddr.value));
      },
      child: Container(
          padding: const EdgeInsets.all(10), child: const Icon(Icons.copy)),
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

  Row _buildActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _copieToClipBoard(context),
        _buildSender(context),
        _refreshIp()
      ],
    );
  }

  Widget _buildSender(BuildContext context) {
    return SenderWidget(
      ipAddr: _ipAddr.value,
    );
  }

  Wrap _buildIpAddrWithActions() {
    return Wrap(
      runSpacing: 5,
      children: <Widget>[
        BlocBuilder<IpAddrCubit, IpAddrState>(
          builder: (context, state) {
            if (state is IpAddrInitialState || state is IpAddrIsProcessing) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
            } else if (state is IpAddrDone) {
              _ipAddr.value = state.ipAddr;
              return Center(
                child: _buildIpAddr(context),
              );
            } else if (state is IpAddrFailed) {
              return const Center(
                child: Text("Something wrong"),
              );
            }
            return _buildActions(context);
          },
        ),
        _buildActions(context)
      ],
    );
  }
}
