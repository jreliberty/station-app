import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../blocs/orders_history/orders_history_bloc.dart';
import '../../../constants/colors.dart';
import '../../../core/errors/page_disconnected.dart';
import '../../../core/utils/loading_scaffold.dart';
import '../../../entities/order/order.dart';
import '../widgets/order_card.dart';

class PageOrders extends StatefulWidget {
  PageOrders({Key? key}) : super(key: key);

  @override
  _PageOrdersState createState() => _PageOrdersState();
}

class _PageOrdersState extends State<PageOrders> {
  List<Order> listOrdersToCome = [];
  List<Order> listOrdersPassed = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<OrdersHistoryBloc, OrdersHistoryState>(
      builder: (context, state) {
        if (state is OrdersHistoryLoadSuccess) {
          listOrdersToCome = state.orderHistory.listOrdersToCome;
          listOrdersPassed = state.orderHistory.listOrdersPassed;
          if (listOrdersPassed.isEmpty && listOrdersToCome.isEmpty)
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 24,
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(FlutterRemix.arrow_left_line),
                        color: ColorsApp.ContentPrimary,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          'Mes commandes',
                          style: GoogleFonts.roboto(
                              height: 1.2,
                              fontSize: 20,
                              color: ColorsApp.ContentPrimary,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 5 * 4,
                      child: Text(
                        'Tu n\'as encore aucune commande dans ton historique.',
                        style: GoogleFonts.roboto(
                            height: 1.43,
                            fontSize: 14,
                            color: ColorsApp.ContentTertiary,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
              ],
            );
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(FlutterRemix.arrow_left_line),
                      color: ColorsApp.ContentPrimary,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        'Mes commandes',
                        style: GoogleFonts.roboto(
                            height: 1.2,
                            fontSize: 20,
                            color: ColorsApp.ContentPrimary,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
              (listOrdersToCome.isNotEmpty)
                  ? Padding(
                      padding:
                          const EdgeInsets.only(left: 24, top: 8, bottom: 8),
                      child: Text(
                        'À venir',
                        style: GoogleFonts.roboto(
                            height: 1.5,
                            fontSize: 16,
                            color: ColorsApp.ContentPrimary,
                            fontWeight: FontWeight.w700),
                      ),
                    )
                  : Container(),
              Column(
                  children: listOrdersToCome
                      .map((_order) => OrderCard(
                          order: _order,
                          topColor: ColorsApp.ActivePrimary,
                          botColor: ColorsApp.BackgroundBrandSecondary))
                      .toList()),
              (listOrdersPassed.isNotEmpty)
                  ? Padding(
                      padding:
                          const EdgeInsets.only(left: 24, top: 32, bottom: 8),
                      child: Text(
                        'Commandes passées',
                        style: GoogleFonts.roboto(
                            height: 1.5,
                            fontSize: 16,
                            color: ColorsApp.ContentPrimary,
                            fontWeight: FontWeight.w700),
                      ),
                    )
                  : Container(),
              Column(
                  children: listOrdersPassed
                      .map((_order) => OrderCard(
                            order: _order,
                            topColor: ColorsApp.BackgroundSecondary,
                            botColor: ColorsApp.BackgroundPrimary,
                          ))
                      .toList()),
            ],
          );
        } else if (state is OrdersHistoryLoadInProgress) {
          return LoadingScaffold();
        } else
          return PageDisconnected(function: () {
            BlocProvider.of<OrdersHistoryBloc>(context)
                .add(InitOrdersHistoryEvent());
          });
      },
    ));
  }
}
