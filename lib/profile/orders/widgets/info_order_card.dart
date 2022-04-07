import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/colors.dart';

import '../../../entities/cart.dart';
import '../../../entities/order/order.dart';
import 'element_basket_history.dart';

class InfoOrderCard extends StatefulWidget {
  final Order order;
  final Cart cart;
  final String stringPromotions;
  InfoOrderCard(
      {Key? key,
      required this.order,
      required this.cart,
      required this.stringPromotions})
      : super(key: key);

  @override
  _InfoOrderCardState createState() => _InfoOrderCardState();
}

class _InfoOrderCardState extends State<InfoOrderCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: widget.order.orderItems.map((orderItem) {
            return ElementBasketHistory(
              orderItem: orderItem,
              cart: widget.cart,
            );
          }).toList(),
        ),
        (false == true)
            ? Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 0, left: 0, bottom: 16),
                    child: Divider(
                      thickness: 1,
                      color: ColorsApp.ContentDivider,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 24.0, left: 24, bottom: 8),
                    child: Row(
                      children: [
                        Text(
                          'Sous-total produits',
                          style: GoogleFonts.roboto(
                              height: 1.65,
                              fontSize: 17,
                              color: Color.fromRGBO(38, 38, 40, 1),
                              fontWeight: FontWeight.w400),
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        Text(
                          '${(widget.order.publicTotal / 100).toStringAsFixed(2).replaceAll('.', ',')} €',
                          style: GoogleFonts.roboto(
                              height: 1.65,
                              fontSize: 17,
                              color: Color.fromRGBO(38, 38, 40, 1),
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
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            'Promotions : ${widget.stringPromotions}',
                            style: GoogleFonts.roboto(
                                height: 1.65,
                                fontSize: 17,
                                color: Color.fromRGBO(35, 169, 66, 1),
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
                              color: Color.fromRGBO(35, 169, 66, 1),
                              fontWeight: FontWeight.w700),
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        Text(
                          '${((widget.order.total - widget.order.publicTotal) / 100).toStringAsFixed(2).replaceAll('.', ',')} €',
                          style: GoogleFonts.roboto(
                              height: 1.65,
                              fontSize: 17,
                              color: Color.fromRGBO(35, 169, 66, 1),
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
          padding: const EdgeInsets.only(right: 24.0, left: 24, bottom: 16),
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
                '${(widget.order.total / 100).toStringAsFixed(2).replaceAll('.', ',')} €',
                style: GoogleFonts.roboto(
                    height: 1.5,
                    fontSize: 16,
                    color: Color.fromRGBO(38, 38, 40, 1),
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 16,
        )
      ],
    );
  }
}
