import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/consumer/consumer_bloc.dart';
import '../../../core/errors/page_disconnected.dart';
import '../../../core/utils/page_creation_pass.dart';
import '../../common_widgets/button_add.dart';
import '../../common_widgets/title_widget.dart';
import '../widgets/pass_card.dart';

class PagePass extends StatefulWidget {
  PagePass({Key? key}) : super(key: key);

  @override
  _PagePassState createState() => _PagePassState();
}

class _PagePassState extends State<PagePass> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          flex: 1,
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overScroll) {
              overScroll.disallowIndicator();
              return false;
            },
            child: ListView(children: [
              TitleWidget(label: 'Mes Decathlon Pass'),
              ButtonAdd(
                  label: 'Ajouter un pass',
                  onPressed: () {
                    showCupertinoModalPopup(
                        context: context,
                        builder: (context) => PageCreationPass(
                              contact: null,
                            ));
                  }),
              BlocBuilder<ConsumerBloc, ConsumerState>(
                builder: (context, state) {
                  if (state is ConsumerLoadSuccess) {
                    state.user.contacts
                        .sort((a, b) => a.index.compareTo(b.index));
                    return Column(
                      children: state.user.contacts
                          .map((e) => (e.middleName == 'deleted')
                              ? Container()
                              : PassCard(
                                  contact: e,
                                ))
                          .toList(),
                    );
                  } else if (state is ConsumerLoadInProgress)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  else
                    return PageDisconnected(function: () {
                      BlocProvider.of<ConsumerBloc>(context)
                          .add(InitConsumerEvent());
                    });
                },
              ),
              //ButtonSave()
            ]),
          ),
        )
      ],
    ));
  }
}
