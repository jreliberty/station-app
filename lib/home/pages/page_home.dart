import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../blocs/stations/stations_bloc.dart';
import '../../blocs/consumer/consumer_bloc.dart';
import '../../blocs/fast_cart/fast_cart_bloc.dart';
import '../../blocs/home/home_bloc.dart';
import '../../blocs/network/network_bloc.dart';
import '../../blocs/orders_history/orders_history_bloc.dart';
import '../../core/errors/page_airplane_mode.dart';
import '../../core/errors/page_disconnected.dart';
import '../../core/utils/loading.dart';
import '../../core/utils/loading_scaffold.dart';
import '../../entities/advantage.dart';
import '../../entities/contact.dart';
import '../../entities/domain.dart';
import '../../entities/offer.dart';
import '../../entities/prices_info.dart';
import '../../entities/station.dart';
import '../../entities/user.dart';
import '../../entities/validity.dart';
import '../../route_order/domain/pages/page_domaines.dart';
import '../../route_order/map/functions/geolocate.dart';
import '../../route_order/map/pages/page_date_picker.dart';
import '../../route_order/map/pages/page_recherche_stations.dart';
import '../fast_order/widgets/fast_order_widget.dart';
import '../widgets/advantage_card.dart';
import '../widgets/empty_orders_widget.dart';
import '../widgets/offer_card.dart';

class PageHome extends StatefulWidget {
  final TabController parentController;
  PageHome({Key? key, required this.parentController}) : super(key: key);

  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  List<Advantage> listAdvantages = [];
  List<Offer> listOffers = [];
  List<Station> listStations = [];
  bool isSelectedStation = false;
  Station? selectedStation;
  DateTime? date;
  bool isSelectedDate = false;
  String stringDate = tr('orders.map.labels.when');
  bool isOrdersEmpty = true;

  @override
  void initState() {
    super.initState();
    if (BlocProvider.of<HomeBloc>(context).state is HomeLoadSuccess) {
      var listOffersAdvantages =
          (BlocProvider.of<HomeBloc>(context).state as HomeLoadSuccess)
              .listOffersAdvantages;
      listOffers = listOffersAdvantages['offers'];
      listAdvantages = listOffersAdvantages['advantages'];
    }
    init();
  }

  init() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.camera,
    ].request();
    print(statuses[Permission.location]);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrdersHistoryBloc, OrdersHistoryState>(
      listener: (context, stateOrderHistory) {
        print(stateOrderHistory);
        if (stateOrderHistory is OrdersHistoryLoadSuccess) {
          print(listStations);
          if (stateOrderHistory.orderHistory.orders.isEmpty)
            isOrdersEmpty = true;
          else {
            if (BlocProvider.of<ConsumerBloc>(context).state
                is ConsumerLoadSuccess) {
              DateTime dateFastOrder = DateTime.now();
              List<Contact> selectectedContacts = [];
              var order = stateOrderHistory.orderHistory.orders[0];
              Station stationFastOrder = listStations
                  .where(
                      (element) => element.contractorId == order.contractorId)
                  .first;
              //domainFastOrder = stationFastOrder.domains.where((element) => element.)    widget.order.orderItems[0].variant.productCategoryName
              Domain domainFastOrder = stationFastOrder.domains
                  .where((element) =>
                      element.shortname ==
                      order.orderItems[0].variant.productCategoryShortName)
                  .first;
              var formatter = new DateFormat('yyyy-MM-dd');
              User user = (BlocProvider.of<ConsumerBloc>(context).state
                      as ConsumerLoadSuccess)
                  .user;
              final now = DateTime.now();
              if (now.hour > 12)
                dateFastOrder = DateTime(now.year, now.month, now.day + 1);
              else
                dateFastOrder = DateTime.now();
              order.orderItems.forEach((element) {
                try {
                  selectectedContacts.add(user.contacts
                      .where((userElement) =>
                          userElement.elibertyId == element.skierId)
                      .first);
                } catch (e) {
                  print('WTF is this contact : ${element.skierId}');
                }
              });
              BlocProvider.of<FastCartBloc>(context).add(
                  GetFirstSimulationFastCartEvent(
                      user: user,
                      domain: domainFastOrder,
                      station: stationFastOrder,
                      startDate: formatter.format(dateFastOrder),
                      selectedContacts: selectectedContacts,selectedValidity: Validity(
                                  label: "1 Jour",
                                  shortName: "1DAY",
                                  pricesInfo: PricesInfo(
                                      startDate: "",
                                      consumerCategory: "",
                                      bestPrice: 0,
                                      basePrice: 0))));
              isOrdersEmpty = false;
            }
          }
        } else
          isOrdersEmpty = true;
        setState(() {});
      },
      child: BlocBuilder<NetworkBloc, NetworkState>(
        builder: (context, state) {
          if (state is NetworkFailure) {
            print('On est pas connectés');
            if (state.isAirplaneModeOn) return PageAirplaneMode();
          }
          return Scaffold(
              body: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
            if (state is HomeLoadSuccess) {
              listOffers = state.listOffersAdvantages['offers'];
              listAdvantages = state.listOffersAdvantages['advantages'];
            }
            if (state is HomeLoadInProgress) {
              return LoadingScaffold();
            } else if (state is HomeLoadFailure)
              return PageDisconnected(function: () {
                BlocProvider.of<HomeBloc>(context).add(InitHomeEvent());
              });
            return BlocBuilder<StationsBloc, StationsState>(
              builder: (context, stateStations) {
                if (stateStations is StationsLoadSuccess) {
                  listStations = stateStations.listStations;
                  isSelectedStation = stateStations.isSelectedStation;
                  selectedStation = stateStations.selectedStation;
                  date = stateStations.date;
                  if (date != null) {
                    final now = DateTime.now();
                    final today = DateTime(now.year, now.month, now.day);
                    final tomorrow = DateTime(now.year, now.month, now.day + 1);
                    final aDate = DateTime(date!.year, date!.month, date!.day);
                    if (aDate == today) {
                      stringDate = tr('common.today');
                    } else if (aDate == tomorrow) {
                      stringDate = tr('common.tomorrow');
                    } else
                      stringDate = formatDate.format(aDate);
                    isSelectedDate = true;
                  }
                }

                return Stack(
                  children: [
                    NotificationListener<OverscrollIndicatorNotification>(
                        onNotification:
                            (OverscrollIndicatorNotification overScroll) {
                          overScroll.disallowIndicator();
                          return false;
                        },
                        child: ListView(
                          padding: EdgeInsets.all(0),
                          children: [
                            BlocBuilder<FastCartBloc, FastCartState>(
                              builder: (context, state) {
                                if (state is FastCartLoadSuccess) {
                                  isOrdersEmpty = false;
                                } else if (state is FastCartLoadInProgress)
                                  isOrdersEmpty = false;
                                else
                                  isOrdersEmpty = true;
                                return Container(
                                  width: double.infinity,
                                  decoration: isOrdersEmpty
                                      ? BoxDecoration(
                                          image: DecorationImage(
                                              alignment: Alignment.topCenter,
                                              image: AssetImage(
                                                  "assets/home.png")),
                                        )
                                      : BoxDecoration(
                                          gradient: LinearGradient(
                                          end: Alignment.topRight,
                                          begin: Alignment.bottomLeft,
                                          colors: [
                                            Color.fromRGBO(0, 125, 188, 1),
                                            Color.fromRGBO(1, 106, 175, 1),
                                            Color.fromRGBO(1, 84, 160, 1),
                                          ],
                                        )),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15, top: 50),
                                        child: Container(
                                          height: 48,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            color: Colors.white,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                  child: InkWell(
                                                onTap: () async {
                                                  Position? position;
                                                  try {
                                                    if (Platform.isAndroid)
                                                      position =
                                                          await determinePositionAndroid();
                                                    else
                                                      position =
                                                          await determinePositionIos();
                                                  } catch (e) {
                                                    print(e);
                                                  }
                                                  var station =
                                                      await showCupertinoModalPopup(
                                                          context: context,
                                                          builder: (context) =>
                                                              PageRechercheStations(
                                                                position:
                                                                    position,
                                                              ));
                                                  if (station != null) {
                                                    BlocProvider.of<
                                                                StationsBloc>(
                                                            context)
                                                        .add(SelectStationEvent(
                                                            selectedStation:
                                                                station,
                                                            date: date,
                                                            listStations:
                                                                listStations));
                                                    await Future.delayed(
                                                        Duration(
                                                            milliseconds: 200));

                                                    if (date == null) {
                                                      var tempDate =
                                                          await showCupertinoModalPopup(
                                                        context: context,
                                                        builder: (context) =>
                                                            PageDatePicker(
                                                          date: date,
                                                        ),
                                                      );

                                                      if (tempDate != null) {
                                                        BlocProvider.of<
                                                                    StationsBloc>(
                                                                context)
                                                            .add(
                                                                ResetStationEvent(
                                                          date: tempDate,
                                                          selectedStation:
                                                              station,
                                                        ));
                                                        // BlocProvider.of<StationsBloc>(
                                                        //         context)
                                                        //     .add(SelectStationEvent(
                                                        //         selectedStation:
                                                        //             station,
                                                        //         date: tempDate,
                                                        //         listStations:
                                                        //             listStations));
                                                        date = tempDate;
                                                        final now =
                                                            DateTime.now();
                                                        final today = DateTime(
                                                            now.year,
                                                            now.month,
                                                            now.day);
                                                        final tomorrow =
                                                            DateTime(
                                                                now.year,
                                                                now.month,
                                                                now.day + 1);
                                                        final aDate = DateTime(
                                                            date!.year,
                                                            date!.month,
                                                            date!.day);
                                                        if (aDate == today) {
                                                          stringDate = tr(
                                                              'common.today');
                                                        } else if (aDate ==
                                                            tomorrow) {
                                                          stringDate = tr(
                                                              'common.tomorrow');
                                                        } else
                                                          stringDate =
                                                              formatDate.format(
                                                                  aDate);
                                                        isSelectedDate = true;
                                                        setState(() {});
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    PageDomaines(
                                                                      station:
                                                                          selectedStation!,
                                                                      startDate:
                                                                          aDate,
                                                                    )));
                                                      }
                                                    } else {
                                                      isSelectedDate = true;
                                                      setState(() {});
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  PageDomaines(
                                                                    station:
                                                                        selectedStation!,
                                                                    startDate:
                                                                        date,
                                                                  )));
                                                    }
                                                  }
                                                },
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 19,
                                                              top: 13,
                                                              bottom: 13,
                                                              right: 11),
                                                      child: Icon(
                                                        FlutterRemix
                                                            .map_pin_line,
                                                        color: Color.fromRGBO(
                                                            0, 16, 24, 1),
                                                        size: 24,
                                                      ),
                                                    ),
                                                    Text(
                                                      !isSelectedStation
                                                          ? tr(
                                                              'orders.map.labels.where')
                                                          : (selectedStation!
                                                                      .name
                                                                      .length >
                                                                  7)
                                                              ? selectedStation!
                                                                      .name
                                                                      .substring(
                                                                          0,
                                                                          8) +
                                                                  '...'
                                                              : selectedStation!
                                                                  .name,
                                                      style: GoogleFonts.roboto(
                                                          fontSize: 16,
                                                          //color: Color(#687787),
                                                          color:
                                                              isSelectedStation
                                                                  ? Color
                                                                      .fromRGBO(
                                                                          0,
                                                                          16,
                                                                          24,
                                                                          1)
                                                                  : Color
                                                                      .fromRGBO(
                                                                          137,
                                                                          150,
                                                                          162,
                                                                          1),
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8,
                                                    bottom: 8,
                                                    right: 18),
                                                child: VerticalDivider(
                                                  color: Color.fromRGBO(
                                                      137, 150, 162, 1),
                                                  thickness: 1,
                                                ),
                                              ),
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () async {
                                                    var tempDate =
                                                        await showCupertinoModalPopup(
                                                      context: context,
                                                      builder: (context) =>
                                                          PageDatePicker(
                                                        date: date,
                                                      ),
                                                    );

                                                    if (tempDate != null) {
                                                      widget.parentController
                                                          .animateTo(1);
                                                      BlocProvider.of<
                                                                  StationsBloc>(
                                                              context)
                                                          .add(
                                                              ResetStationEvent(
                                                        date: tempDate,
                                                        selectedStation:
                                                            selectedStation!,
                                                      ));
                                                      date = tempDate;
                                                      final now =
                                                          DateTime.now();
                                                      final today = DateTime(
                                                          now.year,
                                                          now.month,
                                                          now.day);
                                                      final tomorrow = DateTime(
                                                          now.year,
                                                          now.month,
                                                          now.day + 1);
                                                      final aDate = DateTime(
                                                          date!.year,
                                                          date!.month,
                                                          date!.day);
                                                      if (aDate == today) {
                                                        stringDate =
                                                            tr('common.today');
                                                      } else if (aDate ==
                                                          tomorrow) {
                                                        stringDate = tr(
                                                            'common.tomorrow');
                                                      } else
                                                        stringDate = formatDate
                                                            .format(aDate);
                                                      isSelectedDate = true;
                                                    }
                                                  },
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 13,
                                                                bottom: 13,
                                                                right: 11),
                                                        child: Icon(
                                                          FlutterRemix
                                                              .calendar_line,
                                                          size: 24,
                                                          color: Color.fromRGBO(
                                                              0, 16, 24, 1),
                                                        ),
                                                      ),
                                                      Text(
                                                        stringDate,
                                                        style:
                                                            GoogleFonts.roboto(
                                                                fontSize: 16,
                                                                //color: Color(#687787),
                                                                color: isSelectedDate
                                                                    ? Color
                                                                        .fromRGBO(
                                                                            0,
                                                                            16,
                                                                            24,
                                                                            1)
                                                                    : Color
                                                                        .fromRGBO(
                                                                            137,
                                                                            150,
                                                                            162,
                                                                            1),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      (state is FastCartLoadSuccess)
                                          ? FastOrderWidget(
                                              cart: state.cart,
                                            )
                                          : (state is FastCartLoadInProgress)
                                              ? Container(
                                                  child: Center(
                                                      child:
                                                          CircularProgressIndicator()),
                                                  height: 100,
                                                )
                                              : EmptyOrderWidget(
                                                  controller:
                                                      widget.parentController),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(32),
                                              topRight: Radius.circular(32),
                                            ),
                                          ),
                                          width: double.infinity,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Padding(
                                              //   padding: const EdgeInsets.only(
                                              //     top: 23,
                                              //     left: 24,
                                              //   ),
                                              //   child: Text(
                                              //     'Bons plans',
                                              //     style: GoogleFonts.roboto(
                                              //         height: 1.2,
                                              //         fontSize: 20,
                                              //         color: Color.fromRGBO(
                                              //             0, 16, 24, 1),
                                              //         fontWeight:
                                              //             FontWeight.w700),
                                              //   ),
                                              // ),
                                              // Container(
                                              //   height: 430,
                                              //   child: ListView.builder(
                                              //     shrinkWrap: true,
                                              //     padding: EdgeInsets.only(
                                              //         top: 0,
                                              //         right: 24,
                                              //         left: 24),
                                              //     scrollDirection:
                                              //         Axis.horizontal,
                                              //     itemCount: listOffers.length,
                                              //     itemBuilder:
                                              //         (context, index) {
                                              //       return OfferCard(
                                              //         offer: listOffers[index],
                                              //         listStations:
                                              //             listStations,
                                              //       );
                                              //     },
                                              //   ),
                                              // ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    // top: 48,
                                                    top: 23,
                                                    left: 24,
                                                    bottom: 16),
                                                child: Text(
                                                  'Avantages du Pass',
                                                  style: GoogleFonts.roboto(
                                                      height: 1.2,
                                                      fontSize: 20,
                                                      color: Color.fromRGBO(
                                                          0, 16, 24, 1),
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                              CarouselSlider(
                                                options: CarouselOptions(
                                                  autoPlayInterval:
                                                      Duration(seconds: 4),
                                                  autoPlay: true,
                                                  height: 520.0,
                                                ),
                                                items: listAdvantages.map((i) {
                                                  return Builder(
                                                    builder:
                                                        (BuildContext context) {
                                                      return AdvantageCard(
                                                        advantage: i,
                                                      );
                                                    },
                                                  );
                                                }).toList(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        )),
                    (state is HomeLoadInProgress) ? Loading() : Container(),
                  ],
                );
              },
            );
          }));
        },
      ),
    );
  }

  var formatDate = new DateFormat("dd/MM/yyyy");
}
