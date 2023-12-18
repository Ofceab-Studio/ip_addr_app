import 'package:equatable/equatable.dart';

abstract class IpAddrState extends Equatable {}

class IpAddrInitialState extends IpAddrState {
  @override
  List<Object?> get props => [];
}

class IpAddrIsProcessing extends IpAddrState {
  @override
  List<Object?> get props => [];
}

class IpAddrFailed extends IpAddrState {
  @override
  List<Object?> get props => [];
}

class IpAddrDone extends IpAddrState {
  final String ipAddr;
  IpAddrDone(this.ipAddr);

  @override
  List<Object?> get props => [ipAddr];
}
