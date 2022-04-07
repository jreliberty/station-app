part of 'stations_bloc.dart';

abstract class StationsEvent extends Equatable {
  const StationsEvent();

  @override
  List<Object> get props => [];
}

class InitStationsEvent extends StationsEvent {
  final OrdersHistoryBloc ordersHistoryBloc;

  InitStationsEvent({required this.ordersHistoryBloc});
}

class SelectStationEvent extends StationsEvent {
  final List<Station> listStations;
  final Station selectedStation;
  final DateTime? date;

  SelectStationEvent(
      {required this.selectedStation, this.date, required this.listStations});
}

class DeselectStationEvent extends StationsEvent {
  final DateTime? date;
  final List<Station> listStations;
  final Station? selectedStation;

  DeselectStationEvent({
    this.date,
    required this.selectedStation,
    required this.listStations,
  });
}

class ResetStationEvent extends StationsEvent {
  final DateTime date;
  final Station? selectedStation;

  ResetStationEvent({
    required this.date,
    required this.selectedStation,
  });
}
