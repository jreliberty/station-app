import 'package:equatable/equatable.dart';

import 'prices_info.dart';

class Validity extends Equatable {
  final String shortName;
  final String label;
  final PricesInfo pricesInfo;

  Validity(
      {required this.pricesInfo, required this.shortName, required this.label});

  factory Validity.fromJson(Map<String, dynamic> json) {
    return Validity(
      label: json['label'],
      shortName: json['shortname'],
      pricesInfo: json['prices_info'] == null
          ? PricesInfo(
              basePrice: null,
              bestPrice: null,
              consumerCategory: '',
              startDate: '')
          : PricesInfo.fromJson(json['prices_info'] as Map<String, dynamic>),
    );
  }

  @override
  List<Object?> get props => [shortName, label,pricesInfo];
}