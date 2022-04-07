import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../constants/colors.dart';
import '../../../entities/cart.dart';
import '../../../entities/contact.dart';
import '../../../entities/domain.dart';
import '../../../entities/order/order_item.dart';
import '../../../entities/station.dart';
import '../../../home/functions/string_extension.dart';

class ElementBasketHistory extends StatefulWidget {
  final OrderItem orderItem;
  final Cart cart;
  ElementBasketHistory({
    Key? key,
    required this.orderItem,
    required this.cart,
  }) : super(key: key);

  @override
  _ElementBasketHistoryState createState() => _ElementBasketHistoryState();
}

class _ElementBasketHistoryState extends State<ElementBasketHistory> {
  Contact? contact;
  late Station station;
  late Domain domain;
  late String dateSki;
  late bool isWithOptions;
  @override
  void initState() {
    super.initState();
    if (widget.cart.contacts.isNotEmpty)
      contact = widget.cart.contacts
          .where((element) => element.elibertyId == widget.orderItem.skierId)
          .first;
    station = widget.cart.station;
    domain = widget.cart.domain;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final aDate = DateTime(widget.orderItem.startDate.year,
        widget.orderItem.startDate.month, widget.orderItem.startDate.day);
    if (aDate == today) {
      dateSki =
          'Aujourd\'hui - Le ${DateFormat('dd/MM/yyyy', 'fr').format(aDate)}';
    } else if (aDate == tomorrow) {
      dateSki = 'Demain - Le ${DateFormat('dd/MM/yyyy', 'fr').format(aDate)}';
    } else
      dateSki = 'Le ${DateFormat('dd/MM/yyyy', 'fr').format(aDate)}';

    if (widget.orderItem.orderItemChildren.isNotEmpty)
      isWithOptions = true;
    else
      isWithOptions = false;
  }

  @override
  Widget build(BuildContext context) {
    if (contact != null)
      return Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 24, bottom: 24),
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Column(
                    children: [
                      ClipOval(
                        child: Container(
                          height: 64,
                          width: 64,
                          color: Color.fromRGBO(0, 125, 188, 1),
                          child: Center(
                            child: Text(
                              '${contact!.firstName[0].toUpperCase()}${contact!.lastName[0].toUpperCase()}',
                              style: GoogleFonts.roboto(
                                  fontSize: 24,
                                  color: ColorsApp.ContentPrimaryReversed,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                      Container(
                          height: 28,
                          child: VerticalDivider(
                            color: ColorsApp.BackgroundBrandSecondary,
                            thickness: 2,
                          )),
                      Row(
                        children: [
                          Container(
                            height: 0,
                            width: 41,
                          ),
                          Container(
                              height: 0,
                              width: 41,
                              child: Divider(
                                color: ColorsApp.BackgroundBrandSecondary,
                                thickness: 2,
                              )),
                        ],
                      ),
                      isWithOptions
                          ? Column(
                              children: [
                                Container(
                                    height: 41,
                                    child: VerticalDivider(
                                      color: ColorsApp.BackgroundBrandSecondary,
                                      thickness: 2,
                                    )),
                                Row(
                                  children: [
                                    Container(
                                      height: 0,
                                      width: 41,
                                    ),
                                    Container(
                                        height: 0,
                                        width: 41,
                                        child: Divider(
                                          color: ColorsApp
                                              .BackgroundBrandSecondary,
                                          thickness: 2,
                                        )),
                                  ],
                                ),
                              ],
                            )
                          : Container(),
                      // Container(
                      //     height: 46,
                      //     child: VerticalDivider(
                      //       color: ColorsApp.BackgroundBrandSecondary,
                      //       thickness: 2,
                      //     )),
                      // Row(
                      //   children: [
                      //     Container(
                      //       height: 0,
                      //       width: 41,
                      //     ),
                      //     Container(
                      //         height: 0,
                      //         width: 41,
                      //         child: Divider(
                      //           color: ColorsApp.BackgroundBrandSecondary,
                      //           thickness: 2,
                      //         )),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${contact!.firstName.capitalize()} ${contact!.lastName.capitalize()}',
                      style: GoogleFonts.roboto(
                          height: 1.5,
                          fontSize: 16,
                          color: ColorsApp.ContentPrimary,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      DateFormat('dd MMMM yyyy', 'fr')
                          .format(contact!.birthDate),
                      style: GoogleFonts.roboto(
                          height: 1.325,
                          fontSize: 13,
                          color: ColorsApp.ContentTertiary,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      contact!.numPass,
                      style: GoogleFonts.roboto(
                          height: 1.325,
                          fontSize: 13,
                          color: ColorsApp.ContentTertiary,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 19,
                    ),
                    Row(
                      children: [
                        Text(
                          widget.orderItem.variant.productName,
                          style: GoogleFonts.roboto(
                              height: 1.5,
                              fontSize: 16,
                              color: ColorsApp.ContentPrimary,
                              fontWeight: FontWeight.w700),
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        Text(
                          '${(widget.orderItem.maxPublicPrice / 100).toStringAsFixed(2).replaceAll('.', ',')} €',
                          style: GoogleFonts.roboto(
                              height: 1.5,
                              fontSize: 16,
                              color: ColorsApp.ContentPrimary,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                    isWithOptions
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 16,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Assurance journée',
                                    style: GoogleFonts.roboto(
                                        height: 1.5,
                                        fontSize: 16,
                                        color: ColorsApp.ContentPrimary,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Spacer(
                                    flex: 1,
                                  ),
                                  Text(
                                    '${(widget.orderItem.orderItemChildren[0].total / 100).toStringAsFixed(2).replaceAll('.', ',')} €',
                                    style: GoogleFonts.roboto(
                                        height: 1.5,
                                        fontSize: 16,
                                        color: ColorsApp.ContentPrimary,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              Text(
                                'Allianz',
                                style: GoogleFonts.roboto(
                                    height: 1.429,
                                    fontSize: 14,
                                    color: ColorsApp.ContentTertiary,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          )
                        : Container(),
                    // SizedBox(
                    //   height: 24,
                    // ),
                    // Row(
                    //   children: [
                    //     Text(
                    //       'Avoir de bienvenue',
                    //       style: GoogleFonts.roboto(
                    //           height: 1.5,
                    //           fontSize: 16,
                    //           color: Color.fromRGBO(35, 169, 66, 1),
                    //           fontWeight: FontWeight.w700),
                    //     ),
                    //     Spacer(
                    //       flex: 1,
                    //     ),
                    //     Text(
                    //       '-15 €',
                    //       style: GoogleFonts.roboto(
                    //           height: 1.5,
                    //           fontSize: 16,
                    //           color: Color.fromRGBO(35, 169, 66, 1),
                    //           fontWeight: FontWeight.w700),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    else
      return Container();
  }
}
