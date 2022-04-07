part of 'nfc_bloc.dart';

@immutable
abstract class NfcState {}

class NfcInitial extends NfcState {}

class NfcReading extends NfcState {}

class NfcReaded extends NfcState {
  final String uuid;

  NfcReaded(this.uuid);
}

class NfcError extends NfcState {}
