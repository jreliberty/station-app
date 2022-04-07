import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../constants/config.dart';

class Advantage extends Equatable {
  final String title;
  final String description;
  final Image image;
  final String redirectUrl;
  final bool active;
  final int rank;
  final int id;

  Advantage({
    required this.active,
    required this.rank,
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.redirectUrl,
  });

  @override
  List<Object?> get props => [title, description, image];

  factory Advantage.fromJson(Map<String, dynamic> json) {
    var id = json['id'] ?? 0;
    var rank = json["rank"] ?? 0;
    var description = json["description"] ?? '';
    var imageUrl = MyConfig.BASE_URL_MEDIA +
        'images/advantages/' +
        rank.toString() +
        '.jpeg';
    var image = Image.network(
      imageUrl,
      fit: BoxFit.cover,
      height: 300.0,
      width: 300.0,
    );
    var redirectUrl = json["main_picture_url"] ?? '';
    var active = json["active"] ?? false;
    var title = json["title"] ?? '';
    return Advantage(
      active: active,
      rank: rank,
      id: id,
      title: title,
      description: description,
      image: image,
      redirectUrl: redirectUrl,
    );
  }
}
