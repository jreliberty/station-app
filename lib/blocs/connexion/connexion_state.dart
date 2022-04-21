part of 'connexion_bloc.dart';

@immutable
abstract class ConnexionState {}

class ConnexionInitial extends ConnexionState {}

class GettingJwtInProgress extends ConnexionState {}

class GettingJwtDone extends ConnexionState {
  final Token token;

  GettingJwtDone({required this.token});
}

class GettingJwtFailure extends ConnexionState {
  final ViolationError violationError;

  GettingJwtFailure({required this.violationError});
}

class GettingCredentialsInProgress extends ConnexionState {}

class GettingCredentialsDone extends ConnexionState {
  final Credentials credentials;

  GettingCredentialsDone({required this.credentials});
}
