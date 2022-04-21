part of 'connexion_bloc.dart';

@immutable
abstract class ConnexionEvent {}

class GetJWTEvent extends ConnexionEvent {
  final String email;
  final String password;

  GetJWTEvent({required this.email, required this.password});
}

class GetCredentialsEvent extends ConnexionEvent{}
