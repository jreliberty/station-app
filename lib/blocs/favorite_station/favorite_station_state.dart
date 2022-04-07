part of 'favorite_station_bloc.dart';

abstract class FavoriteStationState extends Equatable {
  const FavoriteStationState();

  @override
  List<Object> get props => [];
}

class FavoriteStationInitial extends FavoriteStationState {}

class FavoriteStationLoadInProgress extends FavoriteStationState {}

class FavoriteStationLoadSuccess extends FavoriteStationState {
  final int contractorId;

  FavoriteStationLoadSuccess({required this.contractorId});
}

class FavoriteStationLoadFailure extends FavoriteStationState {
  final ViolationError violationError;

  const FavoriteStationLoadFailure({required this.violationError});

  @override
  List<Object> get props => [violationError];
}
