import 'dart:typed_data';

import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

import 'bloc/nfc_bloc.dart';

extension IntExtension on int {
  String toHexString() {
    return toRadixString(16).padLeft(2, '0').toUpperCase();
  }
}

extension Uint8ListExtension on Uint8List {
  String toHexString({String empty = '-', String separator = ' '}) {
    return isEmpty ? empty : map((e) => e.toHexString()).join(separator);
  }
}

void tagRead(NfcBloc nfcBloc) {
  NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
    var identifier = NfcA.from(tag)?.identifier ??
        NfcB.from(tag)?.identifier ??
        NfcF.from(tag)?.identifier ??
        NfcV.from(tag)?.identifier ??
        Uint8List(0);
    print(identifier);

    var uid = identifier.toHexString(separator: ' ');
    print(uid);
    print(tag.data);

    print('go');
    NfcManager.instance.stopSession();
    nfcBloc.add(NFCReadingFinished(uid));
  });
}
