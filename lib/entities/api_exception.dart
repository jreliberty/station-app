import 'violation_error.dart';

class ApiException implements Exception {
  ViolationsError? errors;

  ApiException({this.errors});
}
