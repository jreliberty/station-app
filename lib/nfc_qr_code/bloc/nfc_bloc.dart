import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../nfc_reading.dart';

part 'nfc_event.dart';
part 'nfc_state.dart';

class NfcBloc extends Bloc<NfcEvent, NfcState> {
  NfcBloc() : super(NfcInitial());

  @override
  Stream<NfcState> mapEventToState(
    NfcEvent event,
  ) async* {
    if (event is LaunchNFCReading) {
      yield NfcReading();
      tagRead(event.nfcBloc);
    } else if (event is NFCReadingFinished) {
      yield NfcReaded(event.uuid);
    } else if (event is StopNFCReading) {
      yield NfcInitial();
    }
  }
}
