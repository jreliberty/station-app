import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/colors.dart';
import '../../../core/tiles/price_tile.dart';
import '../../../entities/domain.dart';

class TooltipPriceTile extends StatefulWidget {
  final Domain domain;
  TooltipPriceTile({Key? key, required this.domain}) : super(key: key);

  @override
  _TooltipPriceTileState createState() => _TooltipPriceTileState();
}

class _TooltipPriceTileState extends State<TooltipPriceTile> {
  double price = 0;
  @override
  void initState() {
    super.initState();
  }

  bool showTooltip = false;

  @override
  Widget build(BuildContext context) {
    price = (widget.domain.validities.isNotEmpty)
        ? (widget.domain.validities[0].pricesInfo.bestPrice!).toDouble()
        : (widget.domain.priceFrom).toDouble();
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PriceTile(price: price / 100),
            (price < (widget.domain.priceFrom).toDouble())
                ? Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          ((widget.domain.priceFrom / 100) % 1) == 0
                              ? '${(widget.domain.priceFrom / 100).truncate()} €'
                              : '${(widget.domain.priceFrom / 100).toStringAsFixed(2).replaceAll('.', ',')} €',
                          style: GoogleFonts.roboto(
                              decoration: TextDecoration.lineThrough,
                              decorationThickness: 1,
                              letterSpacing: -0.08,
                              fontSize: 15,
                              height: 1,
                              //color: Color(#687787),
                              color: ColorsApp.ContentPrimary,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      IconButton(
                        padding: EdgeInsets.all(0),
                        constraints: BoxConstraints(maxWidth: 25),
                        iconSize: 18,
                        onPressed: () {},
                        tooltip: 'Sur la base d’un adulte en haute saison',
                        icon: Icon(
                          FlutterRemix.information_line,
                          size: 18,
                        ),
                      )
                    ],
                  )
                // ? Tooltip(
                //   triggerMode: TooltipTriggerMode.tap,
                //     message: 'Sur la base d’un adulte en haute saison',
                //     child: Row(
                //       children: [
                //         Padding(
                //           padding: const EdgeInsets.only(left: 8.0),
                //           child: Text(
                //             ((widget.domain.priceFrom / 100) % 1) == 0
                //                 ? '${(widget.domain.priceFrom / 100).truncate()} €'
                //                 : '${(widget.domain.priceFrom / 100).toStringAsFixed(2).replaceAll('.', ',')} €',
                //             style: GoogleFonts.roboto(
                //                 decoration: TextDecoration.lineThrough,
                //                 decorationThickness: 1,
                //                 letterSpacing: -0.08,
                //                 fontSize: 15,
                //                 height: 1,
                //                 //color: Color(#687787),
                //                 color: ColorsApp.ContentPrimary,
                //                 fontWeight: FontWeight.w400),
                //           ),
                //         ),
                //         SizedBox(
                //           width: 4,
                //         ),
                //         Icon(
                //           FlutterRemix.information_line,
                //           size: 18,
                //         ),
                //       ],
                //     ),
                //   )
                : Container(),
            // Container(
            //   alignment: Alignment.center,
            //   height: 32,
            //   width: 48,
            //   color: ColorsApp.BackgorundAccent,
            //   child: Text(
            //     '${(price[0] / 100).truncate()} €',
            //     style: GoogleFonts.roboto(
            //         fontSize: 16,
            //         //color: Color(#687787),
            //         color: ColorsApp.ContentPrimary,
            //         fontWeight: FontWeight.w700),
            //   ),
            // ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  tr('orders.map.labels.tariff',
                      args: ['Adulte', widget.domain.label]),
                  style: GoogleFonts.roboto(
                      fontSize: 14,
                      //color: Color(#687787),
                      color: ColorsApp.ContentPrimary,
                      fontWeight: FontWeight.w400),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
