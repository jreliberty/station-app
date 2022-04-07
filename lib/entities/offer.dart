import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../constants/config.dart';
import 'station.dart';

class Offer extends Equatable {
  final int id;
  final int rank;
  final Station station;
  final String title;
  final String description;
  final DateTime dateFrom;
  final DateTime dateTo;
  final int fromPrice;
  final int promoPrice;
  final bool active;
  final Image image;

  Offer({
    required this.id,
    required this.rank,
    required this.station,
    required this.active,
    required this.title,
    required this.description,
    required this.dateFrom,
    required this.dateTo,
    required this.fromPrice,
    required this.promoPrice,
    required this.image,
  });

  @override
  List<Object?> get props => [title, dateFrom, dateTo, fromPrice, promoPrice];

  factory Offer.fromJson(Map<String, dynamic> json) {
    var id = json['id'] ?? 0;
    var rank = json["rank"] ?? 0;
    var fromPrice = json["from_price"] ?? 0;
    var promoPrice = json["promo_price"] ?? 0;
    var imageUrl =
        MyConfig.BASE_URL_MEDIA + 'images/offers/' + rank.toString() + '.jpeg';
    var image = Image.network(
      imageUrl,
      fit: BoxFit.cover,
      height: 210.0,
      width: 210.0,
    );
    var active = json["active"] ?? false;
    var title = json["title"] ?? '';
    var description = json["description"] ?? '';
    var dateFrom = DateTime(
      int.parse(json['date_from'].substring(0, 4)),
      int.parse(json['date_from'].substring(5, 7)),
      int.parse(json['date_from'].substring(8, 10)),
    );
    var dateTo = DateTime(
      int.parse(json['date_to'].substring(0, 4)),
      int.parse(json['date_to'].substring(5, 7)),
      int.parse(json['date_to'].substring(8, 10)),
    );
    var station = Station.fromJson(json["ski_resort"]);
    print(station);
    return Offer(
      id: id,
      rank: rank,
      station: station,
      active: active,
      title: title,
      description: description,
      dateFrom: dateFrom,
      dateTo: dateTo,
      fromPrice: fromPrice,
      promoPrice: promoPrice,
      image: image,
    );
  }
}
