import 'package:equatable/equatable.dart';

class ConsumerCategory extends Equatable {
  final String shortName;
  final int ageMin;
  final int ageMax;
  final String label;

  ConsumerCategory({
    required this.shortName,
    required this.ageMin,
    required this.ageMax,
    required this.label,
  });

  factory ConsumerCategory.fromJson(Map<String, dynamic> json) {
    return ConsumerCategory(
      shortName: json['shortname'],
      ageMin: (json['age_min'] as num).toInt(),
      ageMax: (json['age_max'] as num).toInt(),
      label: json['label'],
    );
  }

  @override
  List<Object> get props => [shortName, ageMin, ageMax, label];
}
