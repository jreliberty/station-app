import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Insurance extends Equatable {
  final String slug;
  final String shortName;
  final String name;
  final String header;
  final int priceFrom;
  final String type;
  final String image;

  Insurance({
    required this.slug,
    required this.shortName,
    required this.name,
    required this.header,
    required this.priceFrom,
    required this.type,
    required this.image,
  });

  @override
  List<Object?> get props => [slug, shortName, name, type, image, header];

  factory Insurance.fromJson({required Map<String, dynamic> json}) {
    return Insurance(
        slug: json['slug'],
        shortName: json['shortname'],
        name: json['name'],
        header: json['header'],
        priceFrom: json['priceFrom'],
        type: json['type'],
        image: json['image']);
  }
}
