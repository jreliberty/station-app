import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';

import '../../../blocs/cart/cart_bloc.dart';
import '../../../blocs/order/order_bloc.dart';
import '../../../blocs/orders_history/orders_history_bloc.dart';
import '../../../bottom_tab_bar/pages/page_bottom_tab_bar.dart';
import '../../../constants/colors.dart';
import '../../../entities/cart.dart';
import '../../../entities/order/order.dart';
import '../../basket/widgets/element_basket.dart';

class PagePaymentSucceed extends StatefulWidget {
  PagePaymentSucceed({Key? key}) : super(key: key);

  @override
  _PagePaymentSucceedState createState() => _PagePaymentSucceedState();
}

class _PagePaymentSucceedState extends State<PagePaymentSucceed> {
  late Order order;
  late Cart cart;
  int nbInsurances = 0;
  String labelInsurance = '';
  String priceInsurance = '';
  String textDate = '';
  String stringPromotions = '';
  @override
  void initState() {
    if (BlocProvider.of<OrderBloc>(context).state is OrderLoadSuccess) {
      order =
          (BlocProvider.of<OrderBloc>(context).state as OrderLoadSuccess).order;
      order.orderItems.forEach((element) {
        if (element.orderItemChildren.isNotEmpty) {
          labelInsurance = element.orderItemChildren[0].variant.productName;
          priceInsurance =
              '${(element.orderItemChildren[0].total / 100).toStringAsFixed(2).replaceAll('.', ',')} €';
          nbInsurances++;
        }
        if (order.promotions.isNotEmpty) {
          stringPromotions = '';
          order.promotions.forEach((element) {
            stringPromotions += element.name;
            stringPromotions += ', ';
          });
          if ((stringPromotions.length > 1))
            stringPromotions =
                stringPromotions.substring(0, stringPromotions.length - 2);
        }
      });
      if (BlocProvider.of<OrdersHistoryBloc>(context).state
          is OrdersHistoryLoadSuccess) {
        var orderHistory = (BlocProvider.of<OrdersHistoryBloc>(context).state
                as OrdersHistoryLoadSuccess)
            .orderHistory;
        BlocProvider.of<OrdersHistoryBloc>(context).add(
            UpdateOrdersHistoryEvent(orderHistory: orderHistory, order: order));
      }
    }
    if (BlocProvider.of<CartBloc>(context).state is CartLoadSuccess) {
      cart = (BlocProvider.of<CartBloc>(context).state as CartLoadSuccess).cart;
      var difference = cart.startDate.difference(DateTime.now()).inDays;
      var date = DateFormat('dd/MM/yyyy').format(cart.startDate);
      if (difference == 0)
        textDate =
            'Rendez-vous à ${cart.station.name} aujourd\'hui, le $date ! 😎';
      else if (difference == 1)
        textDate = 'Rendez-vous à ${cart.station.name} demain, le $date ! 😎';
      if (difference > 1)
        textDate =
            'Rendez-vous à ${cart.station.name} dans $difference jours, le $date ! 😎';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          return Scaffold(
            floatingActionButton: new FloatingActionButton(
              onPressed: () {
                BlocProvider.of<OrdersHistoryBloc>(context)
                    .add(InitOrdersHistoryEvent());
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => PageBottomTabBar(
                          initialIndex: 0,
                        )));
              },
              tooltip: 'Retour à l\'accueil',
              child: new Icon(FlutterRemix.home_2_line),
              elevation: 4.0,
            ),
            body: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overScroll) {
                overScroll.disallowIndicator();
                return false;
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 480,
                      child: Stack(
                        children: [
                          Image.asset(
                            'assets/tete_skieur.png',
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fill,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  'TES PASS SONT CHARGÉS !',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.robotoCondensed(
                                      fontStyle: FontStyle.italic,
                                      height: 1,
                                      fontSize: 42,
                                      color: ColorsApp.ContentPrimaryReversed,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              SizedBox(height: 16, width: double.infinity),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 50, right: 50),
                                child: Text(
                                  textDate,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.roboto(
                                      height: 1.5,
                                      fontSize: 16,
                                      color: ColorsApp.ContentPrimaryReversed,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              SizedBox(height: 22),
                              Container(
                                width: 211,
                                height: 48,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Color.fromRGBO(0, 125, 188, 1)),
                                  onPressed: () async {
                                    final availableMaps =
                                        await MapLauncher.installedMaps;

                                    await availableMaps.first.showMarker(
                                      coords: Coords(cart.station.latitude,
                                          cart.station.longitude),
                                      title: '',
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.navigation_outlined,
                                        color: ColorsApp.ContentPrimaryReversed,
                                      ),
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(left: 14),
                                          child: Text(
                                            'Comment y aller ?',
                                            style: GoogleFonts.roboto(
                                                fontSize: 16,
                                                color: ColorsApp
                                                        .ContentPrimaryReversed,
                                                fontWeight: FontWeight.w700),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 50),
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 0, right: 0, bottom: 24, top: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 24, right: 24),
                            child: Text(
                              'Details de la commande N°${order.id}',
                              style: GoogleFonts.roboto(
                                  height: 1.5,
                                  fontSize: 16,
                                  color: Color.fromRGBO(17, 35, 45, 1),
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          SizedBox(height: 8),
                          Divider(
                            thickness: 1,
                            color: ColorsApp.ContentDivider,
                          ),
                          SizedBox(height: 8),
                          // Column(
                          //   children: order.orderItems.map((orderItem) {
                          //     return Column(
                          //       children: [
                          //         Row(
                          //           children: [
                          //             Text(
                          //               orderItem.variant.productName,
                          //               style: GoogleFonts.roboto(
                          //                   height: 1.5,
                          //                   fontSize: 17,
                          //                   color:
                          //                       Color.fromRGBO(38, 38, 40, 1),
                          //                   fontWeight: FontWeight.w400),
                          //             ),
                          //             Spacer(
                          //               flex: 1,
                          //             ),
                          //             Text(
                          //               '${(orderItem.total / 100).toStringAsFixed(2)} €',
                          //               style: GoogleFonts.roboto(
                          //                   height: 1.5,
                          //                   fontSize: 17,
                          //                   color:
                          //                       Color.fromRGBO(38, 38, 40, 1),
                          //                   fontWeight: FontWeight.w400),
                          //             ),
                          //           ],
                          //         ),
                          //         SizedBox(height: 8),
                          //       ],
                          //     );
                          //   }).toList(),
                          // ),
                          // nbInsurances > 0
                          //     ? Column(
                          //         children: [
                          //           Row(
                          //             children: [
                          //               Text(
                          //                 '$nbInsurances x $labelInsurance',
                          //                 style: GoogleFonts.roboto(
                          //                     height: 1.5,
                          //                     fontSize: 17,
                          //                     color:
                          //                         Color.fromRGBO(38, 38, 40, 1),
                          //                     fontWeight: FontWeight.w400),
                          //               ),
                          //               Spacer(
                          //                 flex: 1,
                          //               ),
                          //               Text(
                          //                 priceInsurance,
                          //                 style: GoogleFonts.roboto(
                          //                     height: 1.5,
                          //                     fontSize: 17,
                          //                     color:
                          //                         Color.fromRGBO(38, 38, 40, 1),
                          //                     fontWeight: FontWeight.w400),
                          //               ),
                          //             ],
                          //           ),
                          //           SizedBox(height: 8),
                          //         ],
                          //       )
                          //     : Container(),
                          // // Column(
                          // //   children: [
                          // //     Row(
                          // //       children: [
                          // //         Text(
                          // //           'Avoirs de bienvenue',
                          // //           style: GoogleFonts.roboto(
                          // //               height: 1.5,
                          // //               fontSize: 17,
                          // //               color: Color.fromRGBO(35, 169, 66, 1),
                          // //               fontWeight: FontWeight.w400),
                          // //         ),
                          // //         Spacer(
                          // //           flex: 1,
                          // //         ),
                          // //         Text(
                          // //           '-30 €',
                          // //           style: GoogleFonts.roboto(
                          // //               height: 1.5,
                          // //               fontSize: 17,
                          // //               color: Color.fromRGBO(35, 169, 66, 1),
                          // //               fontWeight: FontWeight.w400),
                          // //         ),
                          // //       ],
                          // //     ),
                          // //     SizedBox(height: 8),
                          // //   ],
                          // // ),
                          // Row(
                          //   children: [
                          //     Text(
                          //       'Total TTC',
                          //       style: GoogleFonts.roboto(
                          //           height: 1.5,
                          //           fontSize: 17,
                          //           color: Color.fromRGBO(38, 38, 40, 1),
                          //           fontWeight: FontWeight.w700),
                          //     ),
                          //     Spacer(
                          //       flex: 1,
                          //     ),
                          //     Text(
                          //       '${(order.total / 100).toStringAsFixed(2)} €',
                          //       style: GoogleFonts.roboto(
                          //           height: 1.5,
                          //           fontSize: 17,
                          //           color: Color.fromRGBO(38, 38, 40, 1),
                          //           fontWeight: FontWeight.w700),
                          //     ),
                          //   ],
                          // ),
                          Column(
                            children: order.orderItems.map((orderItem) {
                              return ElementBasket(
                                orderItem: orderItem,
                                cart: cart,
                                promotions: order.promotions,
                              );
                            }).toList(),
                          ),
                          (false == true)
                              ? Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 0, left: 0, bottom: 16),
                                      child: Divider(
                                        thickness: 1,
                                        color: ColorsApp.ContentDivider,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 24.0, left: 24, bottom: 8),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Sous-total produits',
                                            style: GoogleFonts.roboto(
                                                height: 1.65,
                                                fontSize: 17,
                                                color: Color.fromRGBO(
                                                    38, 38, 40, 1),
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Spacer(
                                            flex: 1,
                                          ),
                                          Text(
                                            '${(order.publicTotal / 100).toStringAsFixed(2).replaceAll('.', ',')} €',
                                            style: GoogleFonts.roboto(
                                                height: 1.65,
                                                fontSize: 17,
                                                color: Color.fromRGBO(
                                                    38, 38, 40, 1),
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 24.0, left: 24, bottom: 8),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Text(
                                              'Promotions : $stringPromotions',
                                              style: GoogleFonts.roboto(
                                                  height: 1.65,
                                                  fontSize: 17,
                                                  color: Color.fromRGBO(
                                                      35, 169, 66, 1),
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 24.0, left: 24, bottom: 16),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Total promotions',
                                            style: GoogleFonts.roboto(
                                                height: 1.65,
                                                fontSize: 17,
                                                color: Color.fromRGBO(
                                                    35, 169, 66, 1),
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Spacer(
                                            flex: 1,
                                          ),
                                          Text(
                                            '${((order.total - order.publicTotal) / 100).toStringAsFixed(2).replaceAll('.', ',')} €',
                                            style: GoogleFonts.roboto(
                                                height: 1.65,
                                                fontSize: 17,
                                                color: Color.fromRGBO(
                                                    35, 169, 66, 1),
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Divider(
                              thickness: 1,
                              color: ColorsApp.ContentDivider,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 24.0, left: 24, bottom: 16),
                            child: Row(
                              children: [
                                Text(
                                  'Total TTC',
                                  style: GoogleFonts.roboto(
                                      height: 1.5,
                                      fontSize: 16,
                                      color: Color.fromRGBO(38, 38, 40, 1),
                                      fontWeight: FontWeight.w700),
                                ),
                                Spacer(
                                  flex: 1,
                                ),
                                Text(
                                  //'${(state.order.total/ 100) % 1 == 0 ? (state.order.total / 100).truncate() : (state.order.total / 100).toStringAsFixed(2)} €',
                                  '${(order.total / 100).toStringAsFixed(2).replaceAll('.', ',')} €',
                                  style: GoogleFonts.roboto(
                                      height: 1.5,
                                      fontSize: 16,
                                      color: Color.fromRGBO(38, 38, 40, 1),
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Divider(
                              thickness: 1,
                              color: ColorsApp.ContentDivider,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 24, right: 24, bottom: 16),
                            child: Container(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: ColorsApp.BackgroundAccent),
                                onPressed: () {
                                  BlocProvider.of<OrdersHistoryBloc>(context)
                                      .add(InitOrdersHistoryEvent());
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              PageBottomTabBar(
                                                initialIndex: 0,
                                              )));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      FlutterRemix.home_2_line,
                                      color: Color.fromRGBO(0, 16, 21, 1),
                                    ),
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          'Retour à l\'accueil',
                                          style: GoogleFonts.roboto(
                                              fontSize: 16,
                                              color:
                                                  Color.fromRGBO(0, 16, 21, 1),
                                              fontWeight: FontWeight.w700),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
