part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class GettingUrlInProgress extends LoginState {}

class GettingUrlDone extends LoginState {
  final String url;

  const GettingUrlDone({required this.url});
}

class GettingUrlFailure extends LoginState {
  final ViolationError violationError;

  const GettingUrlFailure({required this.violationError});
}

class GettingJwtInProgress extends LoginState {}

class GettingJwtDone extends LoginState {
  final Token token;

  const GettingJwtDone({required this.token});
}

class GettingJwtFailure extends LoginState {
  final ViolationError violationError;

  const GettingJwtFailure({required this.violationError});
}
