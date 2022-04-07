import 'package:equatable/equatable.dart';

class PricesInfo extends Equatable {
  final String startDate;
  final String consumerCategory;
  final int? bestPrice;
  final int? basePrice;

  PricesInfo(
      {required this.startDate,
      required this.consumerCategory,
      required this.bestPrice,
      required this.basePrice});

  factory PricesInfo.fromJson(Map<String, dynamic> json) {
    return PricesInfo(
      basePrice: (json['baseprice'] ?? 0).toInt(),
      bestPrice: (json['best_price'] ?? 0).toInt(),
      consumerCategory: json['consumer_category'] ?? '',
      startDate: json['start_date'] ?? '',
    );
  }

  @override
  List<Object?> get props =>
      [basePrice, bestPrice, consumerCategory, startDate];
}
