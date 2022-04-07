part of 'network_bloc.dart';

abstract class NetworkState extends Equatable {
  const NetworkState();

  @override
  List<Object> get props => [];
}

class NetworkInitial extends NetworkState {}

class NetworkSuccess extends NetworkState {
  final bool airplaneMode;

  NetworkSuccess(this.airplaneMode);
}

class NetworkFailure extends NetworkState {
  final bool isAirplaneModeOn;

  NetworkFailure(this.isAirplaneModeOn);
}
