import 'package:equatable/equatable.dart';

class Promotion extends Equatable {
  final String name;
  final int id;
  final String description;

  Promotion({required this.name, required this.id, required this.description});
  @override
  List<Object?> get props => [];

  factory Promotion.fromJson({required Map<String, dynamic> json}) {
    var id = json["id"] ?? 0;
    var name = json["name"] ?? '';
    var description = json["description"] ?? '';
    return Promotion(name: name, id: id, description: description);
  }
}
