import 'package:equatable/equatable.dart';

class PassPermission extends Equatable {
  final bool permission;
  final String passNumber;

  PassPermission(
      {required this.permission,
      required this.passNumber}); // ou final String idPass
  @override
  List<Object?> get props => [];
}
