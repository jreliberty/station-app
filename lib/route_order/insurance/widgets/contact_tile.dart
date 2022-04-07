import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../blocs/cart/cart_bloc.dart';
import '../../../constants/colors.dart';
import '../../../entities/cart.dart';
import '../../../entities/contact.dart';

class ContactTile extends StatefulWidget {
  final bool isSelected;
  final Contact contact;
  ContactTile({Key? key, required this.isSelected, required this.contact})
      : super(key: key);

  @override
  _ContactTileState createState() => _ContactTileState();
}

class _ContactTileState extends State<ContactTile> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoadSuccess)
          return GestureDetector(
            onTap: () {
              Cart cart = state.cart;
              if (widget.isSelected)
                cart.removeContactInsurance(widget.contact);
              else
                cart.addContactInsurance(widget.contact);
              BlocProvider.of<CartBloc>(context).add(SetCartEvent(cart: cart));
            },
            child: Container(
              height: 80,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 16.0,
                    ),
                    child: Checkbox(
                        value: widget.isSelected,
                        onChanged: (checkState) {
                          Cart cart = state.cart;
                          if (checkState!)
                            cart.addContactInsurance(widget.contact);
                          else
                            cart.removeContactInsurance(widget.contact);
                          BlocProvider.of<CartBloc>(context)
                              .add(SetCartEvent(cart: cart));
                        }),
                  ),
                  Row(
                    children: [
                      ClipOval(
                        child: Container(
                          height: 64,
                          width: 64,
                          color: ColorsApp.BackgroundBrandPrimary,
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
                                  color: ColorsApp.ContentPrimary,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              DateFormat('dd MMMM yyyy', 'fr')
                                  .format(widget.contact.birthDate),
                              style: GoogleFonts.roboto(
                                  height: 1.2,
                                  fontSize: 14,
                                  letterSpacing: -0.08,
                                  color: ColorsApp.ContentTertiary,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              widget.contact.numPass,
                              style: GoogleFonts.roboto(
                                  height: 1.2,
                                  fontSize: 14,
                                  letterSpacing: -0.08,
                                  color: ColorsApp.ContentTertiary,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        else
          return Container();
      },
    );
  }
}
