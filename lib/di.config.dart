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

import 'core/modules/connectivity_config.dart' as _i10;
import 'core/modules/local_notification_config.dart' as _i5;
import 'core/modules/network_module.dart' as _i4;
import 'core/modules/sender_module.dart' as _i6;
import 'core/modules/storage_module.dart' as _i7;
import 'features/ip_addr/cubit/ip_addr_cubit.dart' as _i8;
import 'features/send_ip_to_channels/cubit/send_ip_cubit.dart' as _i9;

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
    final storageParams = _$StorageParams();
    gh.singleton<_i3.Connectivity>(
      connectivityInitializer.conn,
      instanceName: 'conn',
    );
    gh.singleton<_i4.INetworkModule>(_i4.NetWorkModule());
    gh.singleton<_i5.INotificationModule>(_i5.LocalNotificationModule());
    gh.lazySingleton<_i6.ISenderModule>(() => _i6.LoggmeAsSender());
    gh.lazySingleton<_i7.IStorageHelper>(() => _i7.StorageHelper());
    gh.singleton<_i8.IpAddrCubit>(_i8.IpAddrCubit(gh<_i4.INetworkModule>()));
    gh.singleton<_i9.SendIpCubit>(_i9.SendIpCubit(gh<_i6.ISenderModule>()));
    gh.factory<String>(
      () => storageParams.botId,
      instanceName: 'botId',
    );
    gh.factory<String>(
      () => storageParams.chatId,
      instanceName: 'chatId',
    );
    return this;
  }
}

class _$ConnectivityInitializer extends _i10.ConnectivityInitializer {}

class _$StorageParams extends _i7.StorageParams {}
