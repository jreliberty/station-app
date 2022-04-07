import 'package:equatable/equatable.dart';

import 'station.dart';

class StationTileData extends Equatable {
  final Station station;
  final double? distance;

  StationTileData({required this.station, required this.distance});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
