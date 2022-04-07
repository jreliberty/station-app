import 'package:equatable/equatable.dart';

class Token extends Equatable {
  final String token;
  final String refreshToken;

  Token({required this.token, required this.refreshToken});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      token: json['token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
    );
  }

  @override
  List<Object?> get props => [token, refreshToken];
}
