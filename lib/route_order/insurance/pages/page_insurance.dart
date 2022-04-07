import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../blocs/cart/cart_bloc.dart';
import '../../../blocs/order/order_bloc.dart';
import '../../../constants/colors.dart';
import '../../../core/utils/loading.dart';
import '../../../entities/cart.dart';
import '../../../route_payment/basket/pages/page_basket.dart';
import '../widgets/contact_tile.dart';

const debug = true;

class PageInsurance extends StatefulWidget {
  PageInsurance({Key? key}) : super(key: key);

  @override
  _PageInsuranceState createState() => _PageInsuranceState();
}

class _PageInsuranceState extends State<PageInsurance> {
  int globalPrice = 0;
  late Cart cartForBasket;

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderLoadSuccess) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => PageBasket(
                      cart: cartForBasket,
                    )));
          }
        },
        child: WillPopScope(
          onWillPop: () {
            Navigator.of(context).pop(false);
            return Future.value(false);
          },
          child: Scaffold(
            body: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  alignment: Alignment.topCenter,
                  image: AssetImage("assets/patterns/PatternInsurance.png"),
                ),
              ),
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (OverscrollIndicatorNotification overScroll) {
                  overScroll.disallowIndicator();
                  return false;
                },
                child: BlocBuilder<OrderBloc, OrderState>(
                  builder: (context, stateOrder) {
                    return BlocBuilder<CartBloc, CartState>(
                      builder: (context, state) {
                        if (state is CartLoadSuccess) {
                          cartForBasket = state.cart;
                          globalPrice = 0;
                        }
                        return Stack(
                          children: [
                            ListView(
                              padding: EdgeInsets.all(0),
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 24, left: 10),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: IconButton(
                                      icon: Icon(FlutterRemix.arrow_left_line),
                                      color: ColorsApp.ContentPrimary,
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 24,
                                  ),
                                  child: Text(
                                    tr('orders.insurance.title'),
                                    style: GoogleFonts.roboto(
                                        height: 1.11,
                                        fontSize: 36,
                                        color: ColorsApp.ContentPrimary,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.only(
                                //       top: 16, left: 24, right: 24),
                                //   child: Text(
                                //     tr('orders.insurance.subtitle'),
                                //     style: GoogleFonts.roboto(
                                //         height: 1.33,
                                //         fontSize: 15,
                                //         letterSpacing: -0.24,
                                //         color: ColorsApp.ContentTertiary,
                                //         fontWeight: FontWeight.w400),
                                //   ),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              Color.fromRGBO(4, 70, 117, 0.08),
                                          spreadRadius: 4,
                                          blurRadius: 16,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.asset('assets/assurance.png'),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0, bottom: 8),
                                            child: Text(
                                              tr('orders.insurance.info.title'),
                                              style: GoogleFonts.roboto(
                                                  height: 1.5,
                                                  fontSize: 15,
                                                  color: Color.fromRGBO(
                                                      0, 16, 24, 1),
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          Text(
                                            "Notre assurance vous garantit !",
                                            style: GoogleFonts.roboto(
                                                height: 1.33,
                                                fontSize: 12,
                                                color: Color.fromRGBO(
                                                    0, 16, 24, 1),
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            "AVANT : Vous êtes contraint d’annuler suite à un événement soudain et imprévisible ? Remboursement du forfait.",
                                            style: GoogleFonts.roboto(
                                                height: 1.33,
                                                fontSize: 12,
                                                color: Color.fromRGBO(
                                                    0, 16, 24, 1),
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            "PENDANT : Vous êtes victime d’un d’accident de ski ? Prise en charge des frais de secours et du rapatriement au domicile.",
                                            style: GoogleFonts.roboto(
                                                height: 1.33,
                                                fontSize: 12,
                                                color: Color.fromRGBO(
                                                    0, 16, 24, 1),
                                                fontWeight: FontWeight.w400),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              launch(
                                                  "https://static.decathlonpass.com/docs/files/IPID_DECATHLON_PASS.pdf");
                                            },
                                            child: Text(
                                              "En savoir plus",
                                              style: GoogleFonts.roboto(
                                                  height: 1,
                                                  fontSize: 12,
                                                  color: Color.fromRGBO(
                                                      0, 125, 188, 1),
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  color: Color.fromRGBO(
                                                      255, 234, 40, 1)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  tr('orders.insurance.info.price',
                                                      args: [
                                                        (cartForBasket.insurance
                                                                    .priceFrom /
                                                                100)
                                                            .toStringAsFixed(2)
                                                            .replaceAll(
                                                                '.', ',')
                                                      ]),
                                                  style: GoogleFonts.roboto(
                                                      height: 1.17,
                                                      fontSize: 15,
                                                      color: Color.fromRGBO(
                                                          0, 16, 24, 1),
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 24.0, bottom: 16),
                                  child: Text(
                                    tr('orders.insurance.choose'),
                                    style: GoogleFonts.roboto(
                                        height: 1.5,
                                        fontSize: 16,
                                        color: ColorsApp.ContentPrimary,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Column(
                                      children: cartForBasket.selectedContacts
                                          .map((e) {
                                        if (cartForBasket.selectedInsurances
                                            .contains(e))
                                          globalPrice +=
                                              cartForBasket.insurance.priceFrom;
                                        return Column(
                                          children: [
                                            Divider(
                                              thickness: 1,
                                              color: Color.fromRGBO(
                                                  230, 230, 230, 1),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            ContactTile(
                                                isSelected: cartForBasket
                                                    .selectedInsurances
                                                    .contains(e),
                                                contact: e),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 16,
                                          left: 24,
                                          right: 24,
                                          top: 32),
                                      child: cartForBasket
                                              .selectedInsurances.isNotEmpty
                                          ? Container(
                                              width: double.infinity,
                                              height: 56,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: Color.fromRGBO(
                                                        255, 234, 40, 1)),
                                                onPressed: () {
                                                  BlocProvider.of<CartBloc>(
                                                          context)
                                                      .add(SetCartEvent(
                                                          cart: cartForBasket));
                                                  BlocProvider.of<OrderBloc>(
                                                          context)
                                                      .add(SaveSimulationToOrder(
                                                          cart: cartForBasket));
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      FlutterRemix
                                                          .shopping_cart_line,
                                                      color: Color.fromRGBO(
                                                          0, 16, 21, 1),
                                                    ),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 10),
                                                        child: Text(
                                                          tr('orders.insurance.buttons.button1.label',
                                                              args: [
                                                                (globalPrice / 100) %
                                                                            1 ==
                                                                        0
                                                                    ? (globalPrice /
                                                                            100)
                                                                        .truncate()
                                                                        .toString()
                                                                    : (globalPrice /
                                                                            100)
                                                                        .toStringAsFixed(
                                                                            2)
                                                                        .replaceAll(
                                                                            '.',
                                                                            ',')
                                                              ]),
                                                          style: GoogleFonts
                                                              .roboto(
                                                            fontSize: 15,
                                                            color:
                                                                Color.fromRGBO(
                                                                    0,
                                                                    16,
                                                                    21,
                                                                    1),
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Container(
                                              width: double.infinity,
                                              height: 56,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: ColorsApp
                                                      .BackgroundBrandInactive,
                                                ),
                                                onPressed: null,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      FlutterRemix
                                                          .shopping_cart_line,
                                                      color: Colors.white,
                                                    ),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 10),
                                                        child: Text(
                                                          tr('orders.insurance.buttons.button1.label',
                                                              args: [
                                                                (globalPrice / 100) %
                                                                            1 ==
                                                                        0
                                                                    ? (globalPrice /
                                                                            100)
                                                                        .truncate()
                                                                        .toString()
                                                                    : (globalPrice /
                                                                            100)
                                                                        .toStringAsFixed(
                                                                            2)
                                                                        .replaceAll(
                                                                            '.',
                                                                            ',')
                                                              ]),
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 24,
                                        left: 24,
                                        right: 24,
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        height: 56,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                side: BorderSide(
                                                    color: Color.fromRGBO(
                                                        217, 221, 225, 1),
                                                    width: 2)),
                                            elevation: 0,
                                            primary: ColorsApp
                                                .ContentPrimaryReversed,
                                          ),
                                          onPressed: () async {
                                            var cart = cartForBasket;
                                            cart.clearContactsInsurance();
                                            BlocProvider.of<CartBloc>(context)
                                                .add(SetCartEvent(cart: cart));

                                            BlocProvider.of<OrderBloc>(context)
                                                .add(SaveSimulationToOrder(
                                                    cart: cartForBasket));
                                          },
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(
                                                tr('orders.insurance.buttons.button2.label'),
                                                style: GoogleFonts.roboto(
                                                    fontSize: 15,
                                                    color: Color.fromRGBO(
                                                        0, 104, 157, 1),
                                                    fontWeight:
                                                        FontWeight.w700),
                                              )),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            (stateOrder is OrderLoadInProgress)
                                ? Loading()
                                : Container(),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ));
  }
}
