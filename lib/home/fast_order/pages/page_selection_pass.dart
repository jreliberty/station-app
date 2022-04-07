import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../blocs/consumer/consumer_bloc.dart';
import '../../../blocs/fast_cart/fast_cart_bloc.dart';
import '../../../constants/colors.dart';
import '../../../core/utils/loading.dart';
import '../../../core/utils/page_creation_pass.dart';
import '../../../entities/cart.dart';
import '../../../entities/prices_info.dart';
import '../../../entities/user.dart';
import '../../../entities/validity.dart';
import '../widgets/pass_not_selected_card.dart';
import '../widgets/pass_selected_card.dart';

class PageSelectionPassFastOrder extends StatefulWidget {
  PageSelectionPassFastOrder({Key? key}) : super(key: key);

  @override
  _PageSelectionPassFastOrderState createState() =>
      _PageSelectionPassFastOrderState();
}

class _PageSelectionPassFastOrderState
    extends State<PageSelectionPassFastOrder> {
  int globalPrice = 0;
  late Cart cart;
  User? user;
  bool popUpPromo = false;

  @override
  void initState() {
    if (BlocProvider.of<FastCartBloc>(context).state is FastCartLoadSuccess) {
      cart =
          (BlocProvider.of<FastCartBloc>(context).state as FastCartLoadSuccess)
              .cart;
    }
    super.initState();
  }

  bool isPromoSimulated = false;
  bool isNotJustLoaded = false;
  bool isLocked = false;
  @override
  Widget build(BuildContext context) {
    return BlocListener<ConsumerBloc, ConsumerState>(
      listener: (context, state) {
        if (state is ConsumerLoadSuccess) {
          if (BlocProvider.of<FastCartBloc>(context).state
              is FastCartLoadSuccess) {
            var formatter = new DateFormat('yyyy-MM-dd');
            var cart = (BlocProvider.of<FastCartBloc>(context).state
                    as FastCartLoadSuccess)
                .cart;
            BlocProvider.of<FastCartBloc>(context).add(
                GetFirstSimulationFastCartEvent(
                    station: cart.station,
                    domain: cart.domain,
                    user: state.user,
                    startDate: formatter.format(cart.startDate),
                    selectedContacts: cart.selectedContacts,
                    selectedValidity: Validity(
                        label: "1 Jour",
                        shortName: "1DAY",
                        pricesInfo: PricesInfo(
                            startDate: "",
                            consumerCategory: "",
                            bestPrice: 0,
                            basePrice: 0))));
          }
        }
      },
      child: BlocBuilder<ConsumerBloc, ConsumerState>(
        builder: (context, stateUser) {
          if (stateUser is ConsumerLoadSuccess) user = stateUser.user;
          return BlocBuilder<FastCartBloc, FastCartState>(
            builder: (context, state) {
              globalPrice = 0;
              if (state is FastCartLoadSuccess) {
                cart = state.cart;
                cart.contacts.sort((a, b) => a.index.compareTo(b.index));
                if (cart.selectedContacts.isNotEmpty &&
                    cart.selectedContacts.length == 3 &&
                    isPromoSimulated &&
                    !isLocked) {
                  if (!isNotJustLoaded) {
                    isNotJustLoaded = true;
                    isPromoSimulated = false;
                    popUpPromo = false;
                    var formatter = new DateFormat('yyyy-MM-dd');
                    BlocProvider.of<FastCartBloc>(context).add(
                        GetFirstSimulationFastCartEvent(
                            station: cart.station,
                            domain: cart.domain,
                            user: user!,
                            startDate: formatter.format(cart.startDate),
                            selectedContacts: cart.selectedContacts,
                            selectedValidity: Validity(
                                label: "1 Jour",
                                shortName: "1DAY",
                                pricesInfo: PricesInfo(
                                    startDate: "",
                                    consumerCategory: "",
                                    bestPrice: 0,
                                    basePrice: 0))));
                  } else
                    isNotJustLoaded = false;
                } else if (cart.selectedContacts.isNotEmpty &&
                    cart.selectedContacts.length >= 4 &&
                    !isLocked) {
                  if (!isNotJustLoaded) {
                    isNotJustLoaded = true;
                    isPromoSimulated = true;
                    var formatter = new DateFormat('yyyy-MM-dd');
                    BlocProvider.of<FastCartBloc>(context).add(
                        GetFirstSimulationFastCartEventWithPossiblePromoEvent(
                            station: cart.station,
                            domain: cart.domain,
                            user: user!,
                            startDate: formatter.format(cart.startDate),
                            selectedContacts: cart.selectedContacts,
                            selectedValidity: Validity(
                                label: "1 Jour",
                                shortName: "1DAY",
                                pricesInfo: PricesInfo(
                                    startDate: "",
                                    consumerCategory: "",
                                    bestPrice: 0,
                                    basePrice: 0))));
                  } else {
                    isNotJustLoaded = false;
                    if (cart.promotions.isNotEmpty && !popUpPromo) {
                      cart.promotions.forEach((element) {
                        if (element.description
                            .toLowerCase()
                            .contains('famille')) {
                          popUpPromo = true;
                          Future.delayed(
                              Duration.zero,
                              () => showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text('Bonne nouvelle !'),
                                      content: const Text(
                                          'La promotion famille est appliquée.'),
                                      actions: <Widget>[
                                        new TextButton(
                                          child: const Text('Fermer'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  ));
                        }
                      });
                    }
                  }
                } else
                  isNotJustLoaded = false;
              }
              return Stack(
                children: [
                  Scaffold(
                      body: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        alignment: Alignment.topCenter,
                        image: AssetImage("assets/patterns/PatternPass.png"),
                      ),
                    ),
                    child: NotificationListener<
                            OverscrollIndicatorNotification>(
                        onNotification:
                            (OverscrollIndicatorNotification overScroll) {
                          overScroll.disallowIndicator();
                          return false;
                        },
                        child: ListView(
                          padding: EdgeInsets.all(0),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 24, left: 10),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                  icon: Icon(FlutterRemix.arrow_left_line),
                                  color: ColorsApp.ContentPrimary,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    // update fast cart
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 24,
                              ),
                              child: Text(
                                tr('orders.pass.title',
                                    args: [cart.station.name]),
                                style: GoogleFonts.roboto(
                                    height: 1.11,
                                    fontSize: 36,
                                    //color: Color(#687787),
                                    color: ColorsApp.ContentPrimary,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(
                                    top: 24.0, left: 24, right: 24),
                                child: Column(
                                  children: cart.contacts.map((e) {
                                    if (cart.selectedContacts.contains(e)) {
                                      globalPrice += e.price;
                                      return PassSelectedCard(contact: e);
                                    } else
                                      return PassNotSelectedCard(contact: e);
                                  }).toList(),
                                )),
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 24,
                                left: 24,
                                right: 24,
                              ),
                              child: Container(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary:
                                          ColorsApp.BackgroundBrandSecondary),
                                  onPressed: () {
                                    showCupertinoModalPopup(
                                        context: context,
                                        builder: (context) => PageCreationPass(
                                              contact: null,
                                            ));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: Color.fromRGBO(0, 104, 157, 1),
                                      ),
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Text(
                                            tr('orders.pass.buttons.button1.label'),
                                            style: GoogleFonts.roboto(
                                                fontSize: 15,
                                                color: Color.fromRGBO(
                                                    0, 104, 157, 1),
                                                fontWeight: FontWeight.w700),
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
                              child: cart.selectedContacts.isNotEmpty
                                  ? Container(
                                      width: double.infinity,
                                      height: 56,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Color.fromRGBO(
                                                255, 234, 40, 1)),
                                        onPressed: () {
                                          // var formatter =
                                          //     new DateFormat('yyyy-MM-dd');
                                          // BlocProvider.of<FastCartBloc>(context)
                                          //     .add(
                                          //         GetFirstSimulationFastCartEvent(
                                          //             user: user,
                                          //             domain: cart.domain,
                                          //             station: cart.station,
                                          //             startDate:
                                          //                 formatter.format(
                                          //                     cart.startDate),
                                          //             selectedContacts: cart
                                          //                 .selectedContacts));
                                          Navigator.of(context).pop();
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              FlutterRemix.shopping_cart_line,
                                              color:
                                                  Color.fromRGBO(0, 16, 21, 1),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(
                                                  tr('orders.pass.buttons.button2.label',
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
                                                                    '.', ',')
                                                      ]),
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 15,
                                                      color: Color.fromRGBO(
                                                          0, 16, 21, 1),
                                                      fontWeight:
                                                          FontWeight.w700),
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
                                          primary:
                                              ColorsApp.BackgroundBrandInactive,
                                        ),
                                        onPressed: null,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              FlutterRemix.shopping_cart_line,
                                              color: Colors.white,
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(
                                                  tr('orders.pass.buttons.button2.label',
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
                                                                    '.', ',')
                                                      ]),
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        )),
                  )),
                  (stateUser is ConsumerLoadInProgress)
                      ? Loading()
                      : Container(),
                  (state is FastCartLoadInProgress) ? Loading() : Container(),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
