import 'package:equatable/equatable.dart';

abstract class SendIpState extends Equatable {}

class InitialState extends SendIpState {
  @override
  List<Object?> get props => [];
}

class SendToChannelsFailed extends SendIpState {
  final String message;
  SendToChannelsFailed(this.message);

  @override
  List<Object?> get props => [message];
}

class SendToChannelsDone extends SendIpState {
  final String ip;
  SendToChannelsDone(this.ip);

  @override
  List<Object?> get props => [ip];
}

class SendToChannelsProcessing extends SendIpState {
  @override
  List<Object?> get props => [];
}

class CredentialDone extends SendIpState {
  @override
  List<Object?> get props => [];
}

class CredentialFailed extends SendIpState {
  @override
  List<Object?> get props => [];
}
