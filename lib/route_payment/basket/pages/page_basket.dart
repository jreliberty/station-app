import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../blocs/order/order_bloc.dart';
import '../../../constants/colors.dart';
import '../../../core/utils/loading.dart';
import '../../../entities/cart.dart';
import '../../payment/pages/page_payment.dart';
import '../widgets/element_basket.dart';

class PageBasket extends StatefulWidget {
  final Cart cart;
  PageBasket({Key? key, required this.cart}) : super(key: key);

  @override
  _PageBasketState createState() => _PageBasketState();
}

String stringPromotions = '';

class _PageBasketState extends State<PageBasket> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        if (state is OrderLoadInProgress) return Loading();
        if (state is OrderLoadFailure) return Container();
        if (state is OrderLoadSuccess) {
          if (state.order.promotions.isNotEmpty) {
            stringPromotions = '';
            state.order.promotions.forEach((element) {
              stringPromotions += element.name;
              stringPromotions += ', ';
            });
            if ((stringPromotions.length > 1))
              stringPromotions =
                  stringPromotions.substring(0, stringPromotions.length - 2);
          }
          return Scaffold(
            body: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  alignment: Alignment.topCenter,
                  image: AssetImage("assets/patterns/PatternPanier.png"),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 24.0, right: 24, left: 10),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(FlutterRemix.arrow_left_line),
                            color: ColorsApp.ContentPrimary,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(
                                  'Panier',
                                  style: GoogleFonts.roboto(
                                      height: 1.2,
                                      fontSize: 20,
                                      color: ColorsApp.ContentPrimary,
                                      fontWeight: FontWeight.w700),
                                )),
                          ),
                          // Text(
                          //   'Modifier',
                          //   style: GoogleFonts.roboto(
                          //       height: 1.5,
                          //       fontSize: 16,
                          //       color: Color.fromRGBO(0, 125, 188, 1),
                          //       fontWeight: FontWeight.w700),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child:
                        NotificationListener<OverscrollIndicatorNotification>(
                      onNotification:
                          (OverscrollIndicatorNotification overScroll) {
                        overScroll.disallowIndicator();
                        return false;
                      },
                      child: ListView(
                        padding: EdgeInsets.all(0),
                        children: [
                          SizedBox(
                            height: 24,
                          ),
                          Column(
                            children: state.order.orderItems.map((orderItem) {
                              return ElementBasket(
                                orderItem: orderItem,
                                cart: widget.cart,
                                promotions: state.order.promotions,
                              );
                            }).toList(),
                          ),
                          // state.order.promotions.isNotEmpty
                          //     ? Column(
                          //         children: [
                          //           Padding(
                          //             padding: const EdgeInsets.only(
                          //                 right: 24.0, left: 24, bottom: 16),
                          //             child: Divider(
                          //               thickness: 1,
                          //               color: ColorsApp.ContentDivider,
                          //             ),
                          //           ),
                          //           Padding(
                          //             padding: const EdgeInsets.only(
                          //                 right: 24.0, left: 24, bottom: 8),
                          //             child: Row(
                          //               children: [
                          //                 Text(
                          //                   'Sous-total produits',
                          //                   style: GoogleFonts.roboto(
                          //                       height: 1.65,
                          //                       fontSize: 17,
                          //                       color: Color.fromRGBO(
                          //                           38, 38, 40, 1),
                          //                       fontWeight: FontWeight.w400),
                          //                 ),
                          //                 Spacer(
                          //                   flex: 1,
                          //                 ),
                          //                 Text(
                          //                   '${(state.order.publicTotal / 100).toStringAsFixed(2).replaceAll('.', ',')} €',
                          //                   style: GoogleFonts.roboto(
                          //                       height: 1.65,
                          //                       fontSize: 17,
                          //                       color: Color.fromRGBO(
                          //                           38, 38, 40, 1),
                          //                       fontWeight: FontWeight.w400),
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //           Column(
                          //             children: [
                          //               Padding(
                          //                 padding: const EdgeInsets.only(
                          //                     right: 24.0, left: 24, bottom: 8),
                          //                 child: Container(
                          //                   width: MediaQuery.of(context).size.width,
                          //                   child: Text(
                          //                     'Promotions : $stringPromotions',
                          //                     style: GoogleFonts.roboto(
                          //                         height: 1.65,
                          //                         fontSize: 17,
                          //                         color: Color.fromRGBO(
                          //                             35, 169, 66, 1),
                          //                         fontWeight: FontWeight.w400),
                          //                   ),
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //           Padding(
                          //             padding: const EdgeInsets.only(
                          //                 right: 24.0, left: 24, bottom: 16),
                          //             child: Row(
                          //               children: [
                          //                 Text(
                          //                   'Total promotions',
                          //                   style: GoogleFonts.roboto(
                          //                       height: 1.65,
                          //                       fontSize: 17,
                          //                       color: Color.fromRGBO(
                          //                           35, 169, 66, 1),
                          //                       fontWeight: FontWeight.w700),
                          //                 ),
                          //                 Spacer(
                          //                   flex: 1,
                          //                 ),
                          //                 Text(
                          //                   '${((state.order.total - state.order.publicTotal) / 100).toStringAsFixed(2).replaceAll('.', ',')} €',
                          //                   style: GoogleFonts.roboto(
                          //                       height: 1.65,
                          //                       fontSize: 17,
                          //                       color: Color.fromRGBO(
                          //                           35, 169, 66, 1),
                          //                       fontWeight: FontWeight.w700),
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //         ],
                          //       )
                          //     : Container(),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 24.0, left: 24, bottom: 16),
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
                                  '${(state.order.total / 100).toStringAsFixed(2).replaceAll('.', ',')} €',
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
                            padding: const EdgeInsets.only(
                                right: 24.0, left: 24, bottom: 16),
                            child: Divider(
                              thickness: 1,
                              color: ColorsApp.ContentDivider,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 32, left: 24, right: 24),
                            child: Container(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: ColorsApp.BackgroundAccent),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          PagePayment(
                                            order: state.order,
                                          )));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.security_outlined,
                                      color: Color.fromRGBO(0, 16, 21, 1),
                                    ),
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(left: 14),
                                        child: Text(
                                          'Paiement sécurisé (${(state.order.total / 100).toStringAsFixed(2).replaceAll('.', ',')} €)',
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
                  ),
                ],
              ),
            ),
          );
        } else
          return Container();
      },
    );
  }
}
// Padding(
                          //   padding: const EdgeInsets.only(
                          //       left: 24.0, right: 24, bottom: 24),
                          //   child: Container(
                          //     height: 60,
                          //     width: double.infinity,
                          //     decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(8),
                          //       color: Color.fromRGBO(247, 248, 249, 1),
                          //     ),
                          //     child: Row(
                          //       crossAxisAlignment: CrossAxisAlignment.center,
                          //       children: [
                          //         Padding(
                          //           padding: const EdgeInsets.all(18.0),
                          //           child: Icon(CupertinoIcons.gift),
                          //         ),
                          //         Text(
                          //           'Tu as un code promo ?',
                          //           style: GoogleFonts.roboto(
                          //               height: 1,
                          //               fontSize: 17,
                          //               color: Color.fromRGBO(0, 125, 188, 1),
                          //               fontWeight: FontWeight.w700),
                          //         ),
                          //         Spacer(
                          //           flex: 1,
                          //         ),
                          //         Padding(
                          //           padding: const EdgeInsets.only(right: 18.0),
                          //           child: Icon(
                          //             Icons.keyboard_arrow_down_outlined,
                          //             size: 24,
                          //           ),
                          //         )
                          //       ],
                          //     ),
                          //   ),
                          // ),