import 'dart:convert';

import 'package:equatable/equatable.dart';

class PaymentResponse extends Equatable {
  final bool success;
  final bool redirect;
  final String redirectHtml;
  final String execCode;
  final String errorMessage;

  PaymentResponse({
    required this.success,
    required this.redirect,
    required this.redirectHtml,
    required this.execCode,
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [success, redirect, redirectHtml];

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    bool success = json["success"] ?? false;
    bool redirect = json["redirect"] ?? false;
    String redirectHtmlDecoded = '';
    if (redirect)
      redirectHtmlDecoded = utf8.decode(base64.decode(json["redirect_html"]));
    String execCode = json["exec_code"];
    String errorMessage = json["error_message"] ?? '';
    return PaymentResponse(
        success: success,
        redirect: redirect,
        redirectHtml: redirectHtmlDecoded,
        execCode: execCode,
        errorMessage: errorMessage);
  }
}
