import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/nfc_bloc.dart';

class PageNFC extends StatefulWidget {
  final NfcBloc nfcBloc;

  const PageNFC({Key? key, required this.nfcBloc}) : super(key: key);
  @override
  State<PageNFC> createState() => _PageNFCState();
}

class _PageNFCState extends State<PageNFC> {
  @override
  void initState() {
    super.initState();
    widget.nfcBloc.add(LaunchNFCReading(widget.nfcBloc));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Veuillez approcher votre pass du téléphone.'),
      content: Container(
        height: 200,
        child: BlocBuilder<NfcBloc, NfcState>(
          builder: (context, state) {
            if (state is NfcInitial) {
              return Container();
            } else if (state is NfcReading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is NfcReaded) {
              Navigator.of(context).pop(state.uuid);
            }
            return Container();
          },
        ),
      ),
    );
  }
}
