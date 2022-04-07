part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class GetUrlForLoginEvent extends LoginEvent {}

class JwtNotExpiredEvent extends LoginEvent {
  final Token token;

  JwtNotExpiredEvent({required this.token});
}

class ClearCookiesEvent extends LoginEvent {}

class GetJwtTokenEvent extends LoginEvent {
  final Uri uri;
  GetJwtTokenEvent({required this.uri});
}

class RefreshJwtTokenEvent extends LoginEvent {}
