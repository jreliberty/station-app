import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/consumer/consumer_bloc.dart';
import '../../common_widgets/button_add.dart';
import '../../common_widgets/button_save.dart';
import '../../common_widgets/title_widget.dart';
import '../widgets/card_tile.dart';
import '../widgets/slidable_widget_cards.dart';

class PageCards extends StatefulWidget {
  PageCards({Key? key}) : super(key: key);

  @override
  _PageCardsState createState() => _PageCardsState();
}

class _PageCardsState extends State<PageCards> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<ConsumerBloc, ConsumerState>(
      builder: (context, state) {
        if (state is ConsumerLoadSuccess)
          return Column(
            children: [
              Expanded(
                flex: 1,
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overScroll) {
                    overScroll.disallowIndicator();
                    return false;
                  },
                  child: ListView(children: [
                    TitleWidget(label: 'Mes cartes bancaires'),
                    ButtonAdd(
                      label: 'Ajouter une CB',
                      onPressed: () {},
                    ),
                    Divider(
                      height: 0,
                      thickness: 1,
                      color: Color.fromRGBO(230, 230, 230, 1),
                    ),
                    Column(
                      children: state.user.adresses
                          .map((e) =>
                              SlidableWidgetCard(child: CardTile(adress: e)))
                          .toList(),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    ButtonSave()
                  ]),
                ),
              )
            ],
          );
        else
          return Container();
      },
    ));
  }
}
