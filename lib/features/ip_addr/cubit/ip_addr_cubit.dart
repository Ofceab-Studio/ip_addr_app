import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ip_addr_show/core/modules/network_module.dart';
import 'package:ip_addr_show/features/ip_addr/cubit/ip_addr_state.dart';

@Singleton()
class IpAddrCubit extends Cubit<IpAddrState> {
  IpAddrCubit() : super(IpAddrInitialState()) {
    fetchIpAddr();
  }

  Future<void> fetchIpAddr() async {
    emit(IpAddrIsProcessing());
    Timer(const Duration(milliseconds: 200), () async {
      final netw = NetWorkModule().netw;
      final ip = await netw.getWifiIP();
      if (ip != null) {
        emit(IpAddrDone(ip));
      } else {
        emit(IpAddrFailed());
      }
    });
  }
}
