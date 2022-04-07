import 'package:equatable/equatable.dart';

class Adjustment extends Equatable {
  final String label;
  final String description;
  final int amount;
  final bool neutral;

  Adjustment({
    required this.label,
    required this.description,
    required this.amount,
    required this.neutral,
  });
  @override
  List<Object?> get props => [label, description, amount, neutral];

  factory Adjustment.fromJson({required Map<String, dynamic> json}) {
    var label = json['label'] ?? '';
    var description = json['description'] ?? '';
    var amount = json['amount'] ?? 0;
    var neutral = json['neutral'] ?? false;

    return Adjustment(
        amount: amount,
        description: description,
        label: label,
        neutral: neutral);
  }
}
