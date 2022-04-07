import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../blocs/fast_cart/fast_cart_bloc.dart';
import '../../../constants/colors.dart';
import '../../../core/tiles/price_tile.dart';
import '../../../entities/contact.dart';

class PassSelectedCard extends StatefulWidget {
  final Contact contact;
  PassSelectedCard({Key? key, required this.contact}) : super(key: key);

  @override
  _PassSelectedCardState createState() => _PassSelectedCardState();
}

class _PassSelectedCardState extends State<PassSelectedCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: InkWell(
        onTap: () {
          try {
            var cart = (BlocProvider.of<FastCartBloc>(context).state
                    as FastCartLoadSuccess)
                .cart;
            print(cart);
            cart.removeContact(widget.contact);
            BlocProvider.of<FastCartBloc>(context)
                .add(SetFastCartEvent(cart: cart));
          } catch (e) {
            print('Error adding pass in cart : ' + e.toString());
          }
        },
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 5,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(begin: Alignment.bottomLeft, colors: [
                  Color.fromRGBO(1, 84, 160, 1),
                  Color.fromRGBO(1, 106, 175, 1),
                  Color.fromRGBO(0, 125, 188, 1),
                ])),
            height: 205,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      ClipOval(
                        child: Container(
                          height: 64,
                          width: 64,
                          color: Color.fromRGBO(0, 125, 188, 1),
                          child: Center(
                            child: Text(
                              '${widget.contact.firstName[0].toUpperCase()}${widget.contact.lastName[0].toUpperCase()}',
                              style: GoogleFonts.roboto(
                                  fontSize: 24,
                                  color: ColorsApp.ContentPrimaryReversed,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${widget.contact.firstName} ${widget.contact.lastName}',
                              style: GoogleFonts.roboto(
                                  height: 1.5,
                                  fontSize: 16,
                                  color: ColorsApp.ContentPrimaryReversed,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              DateFormat('dd MMMM yyyy', 'fr')
                                  .format(widget.contact.birthDate),
                              style: GoogleFonts.roboto(
                                  height: 1.2,
                                  fontSize: 14,
                                  letterSpacing: -0.08,
                                  color: ColorsApp.ContentPrimaryReversed,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              widget.contact.numPass,
                              style: GoogleFonts.roboto(
                                  height: 1.2,
                                  fontSize: 14,
                                  letterSpacing: -0.08,
                                  color: ColorsApp.ContentPrimaryReversed,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 1,
                    color: ColorsApp.ContentDivider,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.contact.index == 0
                                    ? tr('orders.pass.card.mytariff', args: [
                                        widget.contact.consumerCategoryName!
                                      ])
                                    : tr('orders.pass.card.histariff', args: [
                                        widget.contact.consumerCategoryName!
                                      ]),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    color: ColorsApp.ContentPrimaryReversed,
                                    fontWeight: FontWeight.w400),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: [
                                    PriceTile(
                                        price: widget.contact.price / 100),
                                    Spacer(
                                      flex: 1,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 48,
                          width: 125,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2,
                                  color: Color.fromRGBO(217, 236, 245, 1)),
                              borderRadius: BorderRadius.circular(4),
                              color: Color.fromRGBO(217, 236, 245, 1)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check,
                                color: Color.fromRGBO(35, 169, 66, 1),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  tr('orders.pass.card.added'),
                                  style: GoogleFonts.roboto(
                                    fontSize: 16,
                                    color: Color.fromRGBO(0, 104, 157, 1),
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.27,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
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
