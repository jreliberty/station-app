import 'package:equatable/equatable.dart';

class WeatherData extends Equatable {
  final int tempMin;
  final int tempMax;
  final int skyIdMorning;
  final int snowHeight;
  final String snowQuality;
  final String avalancheRisk;
  final int visibility;
  final int uv;
  final int windSpeed;
  final int stormRisk;
  final int totalLifts;
  final int totalSlopes;
  final int openLifts;
  final int openSlopes;

  WeatherData({
    required this.tempMin,
    required this.tempMax,
    required this.skyIdMorning,
    required this.snowHeight,
    required this.snowQuality,
    required this.avalancheRisk,
    required this.visibility,
    required this.uv,
    required this.windSpeed,
    required this.stormRisk,
    required this.totalLifts,
    required this.totalSlopes,
    required this.openLifts,
    required this.openSlopes,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      tempMin: json['temp_min'],
      tempMax: json['temp_max'],
      skyIdMorning: json['sky_id_morning'],
      snowHeight: json['snow_height'],
      snowQuality: json['snow_quality'],
      avalancheRisk: json['avalanche_risk'],
      visibility: json['visibility'],
      uv: json['uv'],
      windSpeed: json['wind_speed'],
      stormRisk: json['storm_risk'],
      totalLifts: json['total_lifts'],
      totalSlopes: json['total_slopes'],
      openLifts: json['open_lifts'],
      openSlopes: json['open_slopes'],
    );
  }

  @override
  List<Object?> get props => [
        tempMax,
        tempMin,
        skyIdMorning,
        snowHeight,
        snowQuality,
        avalancheRisk,
        visibility,
        uv,
        visibility,
        windSpeed,
        stormRisk,
        totalLifts,
        totalSlopes,
        openLifts,
        openSlopes,
      ];
}
