import 'dart:async';

import 'package:airplane_mode_detection/airplane_mode_detection.dart';
import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

part 'network_event.dart';
part 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  NetworkBloc() : super(NetworkInitial());

  late StreamSubscription _subscription;

  @override
  Stream<NetworkState> mapEventToState(NetworkEvent event) async* {
    if (event is ListenConnection) {
      _subscription = Connectivity().onConnectivityChanged.listen((event) {
        switch (event) {
          case ConnectivityResult.wifi:
            add(ConnectionChanged(true));
            break;
          case ConnectivityResult.mobile:
            add(ConnectionChanged(true));
            break;
          case ConnectivityResult.none:
            add(ConnectionChanged(false));
            break;
          default:
            add(ConnectionChanged(false));
            break;
        }
      });
    }
    if (event is ConnectionChanged) {
      String airplaneMode;
      // Platform messages may fail, so we use a try/catch PlatformException.
      try {
        airplaneMode = await AirplaneModeDetection.detectAirplaneMode();
      } on PlatformException {
        airplaneMode = 'Failed to get AirPlane Mode.';
      }
      bool isAirplaneModeOn = false;
      if (airplaneMode.toLowerCase() == "on" || !airplaneMode.toLowerCase().contains("not")) isAirplaneModeOn = true;
      print(airplaneMode);
      if (event.connection)
        yield NetworkSuccess(isAirplaneModeOn);
      else
        yield NetworkFailure(isAirplaneModeOn);
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
