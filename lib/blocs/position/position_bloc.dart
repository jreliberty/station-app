import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

import '../../route_order/map/functions/geolocate.dart';

part 'position_event.dart';
part 'position_state.dart';

class PositionBloc extends Bloc<PositionEvent, PositionState> {
  PositionBloc() : super(PositionInitial());

  @override
  Stream<PositionState> mapEventToState(PositionEvent event) async* {
    if (event is InitPositionEvent) {
      Position? position;
      try {
        if (Platform.isAndroid)
          position = await determinePositionAndroid();
        else
          position = await determinePositionIos();
      } catch (e) {
        print(e);
      }
      yield PositionLoadSuccess(position: position);
    }
  }
}
