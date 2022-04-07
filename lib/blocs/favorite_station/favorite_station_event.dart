part of 'favorite_station_bloc.dart';

abstract class FavoriteStationEvent extends Equatable {
  const FavoriteStationEvent();

  @override
  List<Object> get props => [];
}

class InitFavoriteStationEvent extends FavoriteStationEvent {}

class UpdateFavoriteStationEvent extends FavoriteStationEvent {
  final int contractorId;

  UpdateFavoriteStationEvent({required this.contractorId});
}
