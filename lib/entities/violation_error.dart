import 'package:equatable/equatable.dart';

class ViolationError extends Equatable {
  final int? code;
  final String? message;
  final String? propertyPath;

  /// Constructor
  ViolationError({this.code, this.message, this.propertyPath});

  /// Import object from json serialization
  factory ViolationError.fromJson(Map<String, dynamic> json) {
    return ViolationError(
      code: int.parse(json['code']),
      message: json['message'],
      propertyPath: json['propertyPath'],
    );
  }

  /// Equality
  @override
  List<Object?> get props => [code, message, propertyPath];

  /// toString Implementation
  @override
  bool get stringify => true;
}

class ViolationsError extends Equatable {
  final List<ViolationError>? list;

  /// Constructor
  ViolationsError({this.list});

  /// Import object from json serialization
  factory ViolationsError.fromJson(Map<String, dynamic> json) {
    var lcViolationErrors = <ViolationError>[];
    print('json says :  ' + json.toString());
    if (json['violations'] != null) {
      for (var violation in json['violations']) {
        print(violation);
        lcViolationErrors.add(ViolationError.fromJson(violation));
      }
    } else {
      throw (json['hydra:description']);
    }

    return ViolationsError(list: lcViolationErrors);
  }

  /// Equality
  @override
  List<Object?> get props => [list];

  /// toString Implementation
  @override
  bool get stringify => true;
}
