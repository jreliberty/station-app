import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:station/route_order/pass/pages/page_selection_pass.dart';

import '../../../blocs/cart/cart_bloc.dart';
import '../../../blocs/consumer/consumer_bloc.dart';
import '../../../constants/colors.dart';
import '../../../core/utils/loading.dart';
import '../../../entities/cart.dart';
import '../../../entities/station.dart';
import '../../../entities/user.dart';
import '../widgets/card_validity.dart';

class PageSelectionValidity extends StatefulWidget {
  final Station station;

  PageSelectionValidity({Key? key, required this.station}) : super(key: key);

  @override
  _PageSelectionValidityState createState() => _PageSelectionValidityState();
}

class _PageSelectionValidityState extends State<PageSelectionValidity> {
  int globalPrice = 0;
  late Cart cart;
  User? user;
  bool popUpPromo = false;

  @override
  void initState() {
    if (BlocProvider.of<CartBloc>(context).state is CartLoadSuccess) {
      cart = (BlocProvider.of<CartBloc>(context).state as CartLoadSuccess).cart;
    }
    super.initState();
  }

  bool isPromoSimulated = false;
  bool isNotJustLoaded = false;
  bool isLocked = false;
  bool canGo = true;
  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listener: (context, state) async {
        if (state is CartLoadSuccess) if (canGo) {
          canGo = false;
          canGo = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      PageSelectionPass(station: widget.station))) ??
              true;
        }
      },
      child: BlocBuilder<ConsumerBloc, ConsumerState>(
        builder: (context, stateUser) {
          if (stateUser is ConsumerLoadSuccess) user = stateUser.user;
          return BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
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
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 24, left: 10),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: IconButton(
                                      icon: Icon(FlutterRemix.arrow_left_line),
                                      color: ColorsApp.ContentPrimary,
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 24,
                                  ),
                                  child: Text(
                                    'Durée du séjour',
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: cart.domain.validities.map((e) {
                                        return CardValidity(validity: e);
                                      }).toList(),
                                    )),
                              ],
                            )),
                  )),
                  (stateUser is ConsumerLoadInProgress)
                      ? Loading()
                      : Container(),
                  (state is CartLoadInProgress) ? Loading() : Container(),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
