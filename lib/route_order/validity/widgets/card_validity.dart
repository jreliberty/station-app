import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:station/blocs/consumer/consumer_bloc.dart';
import 'package:station/entities/validity.dart';

import '../../../blocs/cart/cart_bloc.dart';
import '../../../constants/colors.dart';
import '../../../core/tiles/price_tile.dart';

class CardValidity extends StatefulWidget {
  final Validity validity;
  CardValidity({Key? key, required this.validity}) : super(key: key);

  @override
  _CardValidityState createState() => _CardValidityState();
}

class _CardValidityState extends State<CardValidity> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: InkWell(
        onTap: () {
          try {
            var cart =
                (BlocProvider.of<CartBloc>(context).state as CartLoadSuccess)
                    .cart;
            var user = (BlocProvider.of<ConsumerBloc>(context).state
                    as ConsumerLoadSuccess)
                .user;

            var formatter = new DateFormat('yyyy-MM-dd');
            BlocProvider.of<CartBloc>(context).add(GetFirstSimulationEvent(
                station: cart.station,
                domain: cart.domain,
                user: user,
                startDate: formatter.format(cart.startDate),
                selectedContacts: cart.selectedContacts,
                selectedValidity: widget.validity));
            cart.selectedValidity = widget.validity;
          } catch (e) {
            print('Error simulation : ' + e.toString());
          }
        },
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 5,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: ColorsApp.ContentPrimaryReversed),
            height: 104,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.validity.label,
                                style: GoogleFonts.roboto(
                                    height: 1.11,
                                    fontSize: 24,
                                    //color: Color(#687787),
                                    color: ColorsApp.ContentPrimary,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                        // Container(
                        //   height: 48,
                        //   width: 125,
                        //   decoration: BoxDecoration(
                        //       border: Border.all(
                        //           width: 2,
                        //           color: Color.fromRGBO(217, 221, 225, 1)),
                        //       borderRadius: BorderRadius.circular(4),
                        //       color: ColorsApp.ContentPrimaryReversed),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       Icon(
                        //         Icons.add,
                        //         color: Color.fromRGBO(0, 104, 157, 1),
                        //       ),
                        //       Padding(
                        //         padding: const EdgeInsets.only(left: 10),
                        //         child: Text(
                        //           tr('orders.pass.card.notadded'),
                        //           style: GoogleFonts.roboto(
                        //             fontSize: 16,
                        //             color: Color.fromRGBO(0, 104, 157, 1),
                        //             fontWeight: FontWeight.w700,
                        //             letterSpacing: 0.27,
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // )
                        Row(
                          children: [
                            PriceTile(
                                price: widget.validity.pricesInfo.bestPrice! /
                                    100),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
