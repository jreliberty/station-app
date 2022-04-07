import 'package:equatable/equatable.dart';

import 'consumer_category.dart';
import 'domain.dart';
import 'validity.dart';
import 'weather_data.dart';

class Station extends Equatable {
  final int id;
  final int contractorId;
  final String submerchantId;
  final String name;
  final String shortName;
  final double latitude;
  final double longitude;
  final bool active;
  final bool activeSales;
  final List<Domain> domains;
  final List<ConsumerCategory> consumerCategories;
  final WeatherData? weatherData;

  Station({
    required this.latitude,
    required this.longitude,
    required this.id,
    required this.contractorId,
    required this.name,
    required this.shortName,
    required this.active,
    required this.domains,
    required this.consumerCategories,
    required this.weatherData,
    required this.submerchantId,
    required this.activeSales,
  });

  factory Station.fromJson(Map<String, dynamic> jsonData) {
    var domains = jsonData['domains'] as List<dynamic>;
    var consumerCategories = jsonData['consumercategories'] as List<dynamic>;
    List<Domain> listDomains = [];
    List<ConsumerCategory> listConsumerCategories = [];
    domains.forEach((_domain) {
      bool domainActive = _domain['active'] ?? false;
      if (domainActive) {
        var validities = _domain['validities'] as List<dynamic>;
        List<Validity> listValidities = [];
        if (validities.isNotEmpty) {
          validities.forEach((_validity) {
            listValidities.add(Validity.fromJson(_validity));
          });
          listDomains.add(Domain.fromJson(_domain, listValidities));
        }
      }
    });
    if (listDomains.isNotEmpty)
      listDomains.sort((a, b) => b.priceFrom.compareTo(a.priceFrom));
    if (consumerCategories.isNotEmpty)
      consumerCategories.forEach((_consumerCategory) {
        listConsumerCategories
            .add(ConsumerCategory.fromJson(_consumerCategory));
      });
    return Station(
      id: (jsonData['id'] as num).toInt(),
      contractorId: (jsonData['contractor_id'] as num).toInt(),
      name: jsonData['name'],
      shortName: jsonData['short_name'],
      active: jsonData['active'] ?? false,
      domains: listDomains,
      consumerCategories: listConsumerCategories,
      latitude: (jsonData['latitude'] as num).toDouble(),
      longitude: (jsonData['longitude'] as num).toDouble(),
      weatherData: (jsonData['weather_data'] != null)
          ? WeatherData.fromJson(
              jsonData['weather_data'] as Map<String, dynamic>)
          : null,
      activeSales: jsonData['active_sales'],
      submerchantId: jsonData['submerchant_id'] ?? '',
    );
  }

  @override
  List<Object?> get props =>
      [name, shortName, active, id, contractorId, domains, consumerCategories];
}
