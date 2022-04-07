part of 'nfc_bloc.dart';

@immutable
abstract class NfcEvent {}

class LaunchNFCReading extends NfcEvent {
  final NfcBloc nfcBloc;

  LaunchNFCReading(this.nfcBloc);
}

class NFCReadingFinished extends NfcEvent {
  final String uuid;

  NFCReadingFinished(this.uuid);
}

class StopNFCReading extends NfcEvent {}
