part of 'stations_bloc.dart';

abstract class StationsState extends Equatable {
  const StationsState();

  @override
  List<Object> get props => [];
}

class StationsInitial extends StationsState {}

class StationsLoadInProgress extends StationsState {}

class StationsLoadSuccess extends StationsState {
  final List<Station> listStations;
  final bool isSelectedStation;
  final Station? selectedStation;
  final DateTime? date;
  final bool isReset;

  StationsLoadSuccess(this.date, this.isSelectedStation, this.selectedStation,
      {required this.listStations, required this.isReset});
}

class StationsLoadFailure extends StationsState {
  final ViolationError violationError;

  const StationsLoadFailure({required this.violationError});
}
