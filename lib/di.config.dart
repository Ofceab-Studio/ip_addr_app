// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'core/modules/connectivity_config.dart' as _i7;
import 'core/modules/local_notification_config.dart' as _i5;
import 'core/modules/network_module.dart' as _i4;
import 'features/ip_addr/cubit/ip_addr_cubit.dart' as _i6;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final connectivityInitializer = _$ConnectivityInitializer();
    gh.singleton<_i3.Connectivity>(
      connectivityInitializer.conn,
      instanceName: 'conn',
    );
    gh.singleton<_i4.INetworkModule>(_i4.NetWorkModule());
    gh.singleton<_i5.INotificationModule>(_i5.LocalNotificationModule());
    gh.singleton<_i6.IpAddrCubit>(_i6.IpAddrCubit(gh<_i4.INetworkModule>()));
    return this;
  }
}

class _$ConnectivityInitializer extends _i7.ConnectivityInitializer {}
