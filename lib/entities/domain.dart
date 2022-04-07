import 'package:equatable/equatable.dart';

import '../constants/config.dart';
import 'validity.dart';

class Domain extends Equatable {
  final int id;
  final String label;
  final String shortname;
  final String description;
  final String bottomLine;
  final String baseLine;
  final String validFrom;
  final String validTo;
  final double areaSize;
  final int slopesQuantity;
  final int liftsQuantity;
  final int priceFrom;
  final bool active;
  final List<Validity> validities;
  final String pictureUrl;

  Domain({
    required this.id,
    required this.priceFrom,
    required this.shortname,
    required this.description,
    required this.bottomLine,
    required this.baseLine,
    required this.areaSize,
    required this.liftsQuantity,
    required this.slopesQuantity,
    required this.validFrom,
    required this.validTo,
    required this.label,
    required this.active,
    required this.validities,
    required this.pictureUrl,
  });

  factory Domain.fromJson(
      Map<String, dynamic> json, List<Validity> validities) {
    return Domain(
      id: json['id'] ?? 0,
      label: json['label'] ?? '',
      shortname: json['shortname'] ?? '',
      validFrom: json['valid_from'] ?? '',
      validities: validities,
      validTo: json['valid_to'] ?? '',
      priceFrom: json['price_from'] ?? 0,
      pictureUrl: MyConfig.BASE_URL_MEDIA + json['picture_url'],
      description: json['description'] ?? '',
      bottomLine: json['bottom_line'] ?? '',
      areaSize: ((json['area_size'] ?? 0) as num).toDouble(),
      baseLine: json['base_line'] ?? 0,
      liftsQuantity: json['lifts_quantity'] ?? 0,
      slopesQuantity: json['slopes_quantity'] ?? 0,
      active: json['active'] ?? true,
    );
  }

  @override
  List<Object?> get props => [
        priceFrom,
        id,
        shortname,
        validFrom,
        validTo,
        label,
        validities,
        pictureUrl
      ];
}
