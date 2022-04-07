import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../blocs/consumer/consumer_bloc.dart';
import '../../../blocs/stations/stations_bloc.dart';
import '../../../constants/colors.dart';
import '../../../entities/cart.dart';
import '../../../entities/contact.dart';
import '../../../entities/domain.dart';
import '../../../entities/insurance.dart';
import '../../../entities/order/order.dart';
import '../../../entities/station.dart';
import '../../../entities/user.dart';
import 'info_order_card.dart';

class OrderCard extends StatefulWidget {
  final Color topColor;
  final Color botColor;
  final Order order;
  OrderCard(
      {Key? key,
      required this.topColor,
      required this.botColor,
      required this.order})
      : super(key: key);

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  late Station station;
  late Domain domain;
  List<Contact> contacts = [];
  late Cart cart;
  String dateSkiLabel = '';
  String skiersLabel = '';
  bool showDetail = false;
  String stringPromotions = '';
  @override
  void initState() {
    List<Station> stations = [];
    late User user;
    if (BlocProvider.of<StationsBloc>(context).state is StationsLoadSuccess)
      stations =
          (BlocProvider.of<StationsBloc>(context).state as StationsLoadSuccess)
              .listStations;
    if (BlocProvider.of<ConsumerBloc>(context).state is ConsumerLoadSuccess)
      user =
          (BlocProvider.of<ConsumerBloc>(context).state as ConsumerLoadSuccess)
              .user;
    print(stations);
    if (stations.isNotEmpty) {
      station = (stations
          .where((element) => element.contractorId == widget.order.contractorId)
          .first);
      if (station.domains.isNotEmpty) {
        domain = station.domains
            .where((element) =>
                element.shortname ==
                widget.order.orderItems[0].variant.productCategoryShortName)
            .first;
      }
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final aDate = DateTime(widget.order.skiDate.year,
        widget.order.skiDate.month, widget.order.skiDate.day);
    if (aDate == today) {
      dateSkiLabel =
          'Aujourd\'hui - Le ${DateFormat('dd/MM/yyyy', 'fr').format(aDate)}';
    } else if (aDate == tomorrow) {
      dateSkiLabel =
          'Demain - Le ${DateFormat('dd/MM/yyyy', 'fr').format(aDate)}';
    } else
      dateSkiLabel = 'Le ${DateFormat('dd/MM/yyyy', 'fr').format(aDate)}';

    widget.order.orderItems.forEach((element) {
      try {
        skiersLabel += user.contacts
                .where(
                    (userElement) => userElement.elibertyId == element.skierId)
                .first
                .firstName +
            ', ';
      } catch (e) {
        print('WTF is this contact : ${element.skierId}');
      }
    });

    widget.order.orderItems.forEach((element) {
      try {
        contacts.add(user.contacts
            .where((userElement) => userElement.elibertyId == element.skierId)
            .first);
      } catch (e) {
        print('WTF is this contact : ${element.skierId}');
      }
    });
    if (widget.order.promotions.isNotEmpty) {
      stringPromotions = '';
      widget.order.promotions.forEach((element) {
        stringPromotions += element.name;
        stringPromotions += ', ';
      });
      if ((stringPromotions.length > 1))
        stringPromotions =
            stringPromotions.substring(0, stringPromotions.length - 2);
    }
    cart = Cart(
        station: station,
        domain: domain,
        startDate: aDate,
        validity: '',
        contacts: contacts,
        selectedContacts: [],
        selectedInsurances: [],
        promotions: [],
        insurance: Insurance(
            header: '',
            image: '',
            name: '',
            priceFrom: 0,
            shortName: '',
            slug: '',
            type: ''));
    if ((skiersLabel.length > 1))
      skiersLabel = skiersLabel.substring(0, skiersLabel.length - 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        GestureDetector(
          onTap: () => setState(() {
            showDetail = !showDetail;
          }),
          child: Container(
            height: 56,
            color: widget.topColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 24,
                ),
                Text(
                  DateFormat('dd MMMM yyyy', 'fr')
                      .format(widget.order.createdAt),
                  style: GoogleFonts.roboto(
                      height: 1.5,
                      fontSize: 16,
                      color: ColorsApp.ContentPrimary,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'FR${widget.order.id}',
                  style: GoogleFonts.roboto(
                      letterSpacing: -0.24,
                      height: 1.33,
                      fontSize: 15,
                      color: ColorsApp.ContentPrimary,
                      fontWeight: FontWeight.w400),
                ),
                Spacer(flex: 1),
                Icon(
                  showDetail
                      ? CupertinoIcons.chevron_down
                      : CupertinoIcons.chevron_right,
                  size: 16,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 24,
                )
              ],
            ),
          ),
        ),
        Container(
          height: 132,
          color: widget.botColor,
          child: Padding(
            padding: const EdgeInsets.only(
                left: 24.0, right: 24, top: 16, bottom: 16),
            child: Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      domain.pictureUrl,
                      fit: BoxFit.cover,
                      height: 100.0,
                      width: 100.0,
                    )),
                SizedBox(
                  width: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      station.name, //widget.order.station.name,
                      style: GoogleFonts.roboto(
                          height: 1.2,
                          fontSize: 18,
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontWeight: FontWeight.w700),
                    ),
                    Spacer(flex: 1),
                    Text(
                      domain.label,
                      style: GoogleFonts.roboto(
                          height: 1.5,
                          fontSize: 16,
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontWeight: FontWeight.w700),
                    ),
                    Spacer(flex: 1),
                    Text(
                      dateSkiLabel,
                      style: GoogleFonts.roboto(
                          letterSpacing: -0.24,
                          height: 1.33,
                          fontSize: 15,
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontWeight: FontWeight.w400),
                    ),
                    Spacer(flex: 1),
                    Text(
                      skiersLabel,
                      style: GoogleFonts.roboto(
                          letterSpacing: -0.24,
                          height: 1.33,
                          fontSize: 15,
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        showDetail
            ? AnimatedContainer(
                duration: Duration(milliseconds: 1000),
                child: InfoOrderCard(
                  cart: cart,
                  order: widget.order,
                  stringPromotions: stringPromotions,
                ))
            : Container(),
      ],
    ));
  }
}
