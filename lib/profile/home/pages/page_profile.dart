import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map_launcher/map_launcher.dart';
import '../../../constants/colors.dart';

import '../../../blocs/consumer/consumer_bloc.dart';
import '../../../blocs/fast_cart/fast_cart_bloc.dart';
import '../../../blocs/orders_history/orders_history_bloc.dart';
import '../../../blocs/stations/stations_bloc.dart';
import '../../../core/errors/page_disconnected.dart';
import '../../../core/utils/loading_scaffold.dart';
import '../../../entities/domain.dart';
import '../../../entities/order/order.dart';
import '../../../entities/station.dart';
import '../../../repository/helpers/api_helper.dart';
import '../../../route_connexion/splashscreen/splashscreen.dart';
import '../../address/pages/page_adress.dart';
import '../../contact/pages/page_contact.dart';
import '../../orders/pages/page_orders.dart';
import '../../pass/pages/page_tab_pass.dart';
import '../../personal_info/pages/page_personal_info.dart';
import '../widgets/avatar_view.dart';
import '../widgets/item_tile.dart';
import '../widgets/item_tile_browser.dart';
import '../widgets/item_tile_pass.dart';

class PageProfile extends StatefulWidget {
  PageProfile({Key? key}) : super(key: key);

  @override
  _PageProfileState createState() => _PageProfileState();
}

List<Order> listOrdersToCome = [];
late Order ordertoShow;
Station? stationtoShow;
Domain? domainToShow;
List<Station> stations = [];
String dateSkiLabel = '';
String skiersLabel = '';

class _PageProfileState extends State<PageProfile> {
  @override
  void initState() {
    super.initState();
    if (BlocProvider.of<StationsBloc>(context).state is StationsLoadSuccess)
      stations =
          (BlocProvider.of<StationsBloc>(context).state as StationsLoadSuccess)
              .listStations;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConsumerBloc, ConsumerState>(
      builder: (context, state) {
        if (state is ConsumerLoadSuccess)
          return BlocBuilder<OrdersHistoryBloc, OrdersHistoryState>(
            builder: (context, stateOrder) {
              if (stateOrder is OrdersHistoryLoadSuccess) {
                dateSkiLabel = '';
                skiersLabel = '';
                listOrdersToCome = stateOrder.orderHistory.listOrdersToCome;
                if (listOrdersToCome.isNotEmpty) {
                  ordertoShow = listOrdersToCome[listOrdersToCome.length - 1];
                  if (stations.isNotEmpty) {
                    stationtoShow = (stations
                        .where((element) =>
                            element.contractorId == ordertoShow.contractorId)
                        .first);
                  }
                  if (stationtoShow != null) if (stationtoShow!
                      .domains.isNotEmpty) {
                    domainToShow = stationtoShow!.domains
                        .where((element) =>
                            element.shortname ==
                            ordertoShow
                                .orderItems[0].variant.productCategoryShortName)
                        .first;
                  }
                  final now = DateTime.now();
                  final today = DateTime(now.year, now.month, now.day);
                  final tomorrow = DateTime(now.year, now.month, now.day + 1);
                  final aDate = DateTime(ordertoShow.skiDate.year,
                      ordertoShow.skiDate.month, ordertoShow.skiDate.day);
                  if (aDate == today) {
                    dateSkiLabel =
                        'Aujourd\'hui - Le ${DateFormat('dd/MM/yyyy', 'fr').format(aDate)}';
                  } else if (aDate == tomorrow) {
                    dateSkiLabel =
                        'Demain - Le ${DateFormat('dd/MM/yyyy', 'fr').format(aDate)}';
                  } else
                    dateSkiLabel =
                        'Le ${DateFormat('dd/MM/yyyy', 'fr').format(aDate)}';
                  ordertoShow.orderItems.forEach((element) {
                    try {
                      skiersLabel += state.user.contacts
                              .where((userElement) =>
                                  userElement.elibertyId == element.skierId)
                              .first
                              .firstName +
                          ', ';
                    } catch (e) {
                      print('WTF is this contact : ${element.skierId}');
                    }
                  });
                  if ((skiersLabel.length > 1))
                    skiersLabel =
                        skiersLabel.substring(0, skiersLabel.length - 2);
                }
              }
              return Scaffold(
                backgroundColor: Color.fromRGBO(247, 248, 249, 1),
                body: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overScroll) {
                    overScroll.disallowIndicator();
                    return false;
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            child: AvatarView(
                          consumer: state.user,
                        )),
                        Text(
                          'Salut ${state.user.firstName} !',
                          style: GoogleFonts.roboto(
                              height: 1.2,
                              fontSize: 20,
                              color: ColorsApp.ContentPrimary,
                              fontWeight: FontWeight.w700),
                        ),
                        (stationtoShow != null &&
                                domainToShow != null &&
                                listOrdersToCome.isNotEmpty)
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    (listOrdersToCome.length > 1)
                                        ? 'Tu as ${listOrdersToCome.length} évènements à venir ! 😜'
                                        : 'Tu as ${listOrdersToCome.length} évènement à venir ! 😜',
                                    style: GoogleFonts.roboto(
                                        height: 1.43,
                                        fontSize: 14,
                                        color: ColorsApp.ContentTertiary,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 24.0,
                                      left: 12.0,
                                      right: 12.0,
                                    ),
                                    child: Container(
                                      height: 196,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(9),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromRGBO(
                                                  0, 83, 125, 0.1),
                                              blurRadius: 6,
                                              offset: Offset(0,
                                                  6), // changes position of shadow
                                            ),
                                          ],
                                          color: ColorsApp
                                              .BackgroundBrandSecondary),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: Image.network(
                                                      domainToShow!.pictureUrl,
                                                      fit: BoxFit.cover,
                                                      height: 100.0,
                                                      width: 100.0,
                                                    )),
                                                SizedBox(width: 16),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      stationtoShow!.name,
                                                      style: GoogleFonts.roboto(
                                                          height: 1.2,
                                                          fontSize: 18,
                                                          color: Color.fromRGBO(
                                                              0, 16, 24, 1),
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      domainToShow!.label,
                                                      style: GoogleFonts.roboto(
                                                          height: 1.5,
                                                          fontSize: 16,
                                                          color: Color.fromRGBO(
                                                              0, 16, 24, 1),
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      dateSkiLabel,
                                                      style: GoogleFonts.roboto(
                                                          height: 1.33,
                                                          fontSize: 14,
                                                          color: Color.fromRGBO(
                                                              0, 16, 24, 1),
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      skiersLabel,
                                                      style: GoogleFonts.roboto(
                                                          height: 1.33,
                                                          fontSize: 14,
                                                          color: Color.fromRGBO(
                                                              0, 16, 24, 1),
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 16,
                                                left: 16,
                                                right: 16,
                                                top: 0),
                                            child: Container(
                                              width: double.infinity,
                                              height: 48,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: Color.fromRGBO(
                                                        0, 125, 188, 1)),
                                                onPressed: () async {
                                                  final availableMaps =
                                                      await MapLauncher
                                                          .installedMaps;

                                                  await availableMaps.first
                                                      .showMarker(
                                                    coords: Coords(
                                                        stationtoShow!.latitude,
                                                        stationtoShow!
                                                            .longitude),
                                                    title: '',
                                                  );
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.navigation,
                                                      color: ColorsApp.ContentPrimaryReversed,
                                                    ),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 10),
                                                        child: Text(
                                                          'Comment y aller ?',
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  fontSize: 16,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          1),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        SizedBox(height: 32),
                        ItemTile(
                          icon: FlutterRemix.shopping_cart_line,
                          label: 'Mes commandes',
                          page: PageOrders(),
                        ),
                        SizedBox(height: 32),
                        ItemTile(
                          icon: FlutterRemix.user_line,
                          label: 'Informations personnelles',
                          page: PagePersonalInfo(),
                        ),
                        ItemTile(
                          icon: FlutterRemix.home_2_line,
                          label: 'Mon adresse',
                          page: PageAdress(),
                        ),
                        // ItemTile(
                        //   icon: CupertinoIcons.creditcard,
                        //   label: 'Mes CB enregistrées',
                        //   page: PageCards(),
                        // ),
                        (state.user.contacts.isNotEmpty)
                            ? ItemTilePass(
                                icon: FlutterRemix.bank_card_2_line,
                                label: 'Mes Decathlon Pass',
                                page: PageTabPass(
                                  initialIndex: 1,
                                ),
                                user: state.user,
                              )
                            : ItemTilePass(
                                icon: FlutterRemix.bank_card_2_line,
                                label: 'Mes Decathlon Pass',
                                page: PageTabPass(
                                  initialIndex: 0,
                                ),
                                user: state.user,
                              ),
                        SizedBox(height: 32),
                        // ItemTile(
                        //   icon: CupertinoIcons.smiley,
                        //   label: 'Personnalisation',
                        //   page: PagePersonalInfo(),
                        // ),
                        // ItemTile(
                        //   icon: CupertinoIcons.heart,
                        //   label: 'Ma station favorite',
                        //   page: PageMaintenance(), //PagePersonalInfo(),
                        // ),
                        // ItemTile(
                        //   icon: FlutterRemix.mail_send_line,
                        //   label: 'Newsletter',
                        //   page: PageNewsletter(),
                        // ),
                        ItemTileBrowser(
                          icon: FlutterRemix.lock_line,
                          label: 'Confidentialité',
                          url:
                              'https://static.decathlonpass.com/docs/policy.html',
                        ),
                        ItemTileBrowser(
                          icon: FlutterRemix.file_text_line,
                          label: 'CGU',
                          url: 'https://static.decathlonpass.com/docs/cgu.html',
                        ),
                        ItemTileBrowser(
                          icon: FlutterRemix.global_line,
                          label: 'Mentions légales',
                          url:
                              'https://static.decathlonpass.com/docs/terms.html',
                        ),
                        SizedBox(height: 32),
                        ItemTile(
                          icon: FlutterRemix.mail_line,
                          label: 'Contact',
                          page: PageContact(), //PagePersonalInfo(),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 70.0, right: 70),
                          child: Container(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      side: BorderSide(
                                          color:
                                              Color.fromRGBO(217, 221, 225, 1),
                                          width: 2)),
                                  elevation: 0,
                                  primary: ColorsApp.BackgroundPrimary),
                              onPressed: () async {
                                bool? _disconnect = await showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return new AlertDialog(
                                      title: Text(
                                        "Attention !",
                                      ),
                                      content: Text(
                                        "Êtes-vous sûr de vouloir vous déconnecter ?",
                                      ),
                                      actions: <Widget>[
                                        new TextButton(
                                          child: const Text('Oui'),
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                          },
                                        ),
                                        new TextButton(
                                          child: const Text('Non'),
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                                if (_disconnect != null && _disconnect) {
                                  ApiHelper apiHelper = ApiHelper();

                                  await apiHelper.resetCachedJWT();
                                  BlocProvider.of<FastCartBloc>(context)
                                      .add(EmptyFastCartEvent());

                                  final cookieManager = CookieManager();
                                  await cookieManager.deleteAllCookies();
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              SplashScreen()));
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    FlutterRemix.door_closed_line,
                                    color: Color.fromRGBO(0, 104, 157, 1),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Text(
                                        tr('profile.home.buttons.button2.label'),
                                        style: GoogleFonts.roboto(
                                            letterSpacing: 0.32,
                                            height: 1,
                                            fontSize: 16,
                                            color:
                                                Color.fromRGBO(0, 104, 157, 1),
                                            fontWeight: FontWeight.w700),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 32,
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        else if (state is ConsumerLoadFailure)
          return PageDisconnected(function: () {
            BlocProvider.of<ConsumerBloc>(context).add(InitConsumerEvent());
          });
        else
          return LoadingScaffold();
      },
    );
  }
}
