import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/rxdart.dart';

import '../../../blocs/consumer/consumer_bloc.dart';
import '../../../blocs/stations/stations_bloc.dart';
import '../../../constants/colors.dart';
import '../../../core/functions/functions.dart';
import '../../../entities/contact.dart';
import '../../../entities/station.dart';
import '../../../entities/station_tile_data.dart';
import '../widgets/station_tile_fast_order.dart';

class PageRechercheStationsFastOrder extends StatefulWidget {
  final Position? position;
  final DateTime startDate;
  final List<Contact> selectedContacts;
  PageRechercheStationsFastOrder(
      {Key? key,
      required this.position,
      required this.startDate,
      required this.selectedContacts})
      : super(key: key);

  @override
  _PageRechercheStationsFastOrderState createState() =>
      _PageRechercheStationsFastOrderState();
}

BehaviorSubject _bhvsRecherche = BehaviorSubject.seeded('');

class _PageRechercheStationsFastOrderState
    extends State<PageRechercheStationsFastOrder> {
  Stream get rechercheChange$ => _bhvsRecherche.stream;
  TextEditingController rechercheController = TextEditingController();
  String name = '';

  void initState() {
    super.initState();
    _bhvsRecherche.value = '';
    if (BlocProvider.of<ConsumerBloc>(context).state is ConsumerLoadSuccess) {
      var user =
          (BlocProvider.of<ConsumerBloc>(context).state as ConsumerLoadSuccess)
              .user;
      name = user.firstName;
    }
  }

  late List<Station> listStations;
  List<StationTileData> listStationsData = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StationsBloc, StationsState>(
      builder: (context, state) {
        if (state is StationsLoadSuccess) {
          listStations = state.listStations;
          listStationsData.clear();
          listStations.forEach((element) {
            double? distance;
            if (widget.position != null)
              distance = calculateDistance(
                widget.position!.latitude,
                widget.position!.longitude,
                element.latitude,
                element.longitude,
              );
            listStationsData
                .add(StationTileData(station: element, distance: distance));
          });
          if (widget.position == null)
            listStationsData.sort((a, b) =>
                a.station.name.toString().compareTo(b.station.name.toString()));
          else
            listStationsData.sort((a, b) => a.distance!.compareTo(b.distance!));
          return Material(
            type: MaterialType.transparency,
            child: Column(
              children: [
                Container(
                  height: 44,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16),
                          topLeft: Radius.circular(16),
                        ),
                        color: Colors.white,
                      ),
                      child:
                          NotificationListener<OverscrollIndicatorNotification>(
                        onNotification:
                            (OverscrollIndicatorNotification overScroll) {
                          overScroll.disallowIndicator();
                          return false;
                        },
                        child: ListView(
                          padding: const EdgeInsets.all(0),
                          children: [
                            Container(
                              height: 55,
                              width: MediaQuery.of(context).size.width,
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Color.fromRGBO(
                                                239, 241, 243, 1),
                                          ),
                                          child: IconButton(
                                            icon: Icon(Icons.clear),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      tr("orders.map.search.title",
                                          args: [name]),
                                      style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          //color: Color(#687787),
                                          color: ColorsApp.ContentPrimary,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              height: 0,
                              thickness: 1,
                              color: ColorsApp.ContentDivider,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                      height: 44,
                                      child: TextField(
                                        controller: rechercheController,
                                        style: GoogleFonts.roboto(
                                            letterSpacing: -0.32,
                                            fontSize: 16,
                                            //color: Color(#687787),
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400),
                                        decoration: InputDecoration(
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.never,
                                          labelText: tr(
                                              "orders.map.search.buttons.button1.label"),
                                          suffixIcon: IconButton(
                                            icon: Icon(CupertinoIcons.search),
                                            onPressed: () {},
                                          ),
                                          labelStyle: GoogleFonts.roboto(
                                              letterSpacing: -0.32,
                                              fontSize: 16,
                                              //color: Color(#687787),
                                              color: Color.fromRGBO(
                                                  104, 119, 135, 1),
                                              fontWeight: FontWeight.w400),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Color.fromRGBO(
                                                    130, 150, 162, 1)),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                        onChanged: (String value) =>
                                            _bhvsRecherche.value = value,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 24,
                                        ),
                                        Text(
                                          tr("orders.map.search.subtitle"),
                                          style: GoogleFonts.roboto(
                                              fontSize: 16,
                                              //color: Color(#687787),
                                              color: ColorsApp.ContentPrimary,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        StreamBuilder(
                                            stream: _bhvsRecherche.stream,
                                            builder: (context, snapshot) {
                                              List<StationTileData> listToShow =
                                                  [];
                                              if (listStations.isNotEmpty)
                                                listStationsData
                                                    .forEach((stationData) {
                                                  if (stationData.station.name
                                                      .toLowerCase()
                                                      .contains(_bhvsRecherche
                                                          .value
                                                          .toString()
                                                          .toLowerCase()))
                                                    listToShow.add(stationData);
                                                });

                                              if (listToShow.isNotEmpty)
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 16),
                                                  child: ListView.builder(
                                                    physics: ScrollPhysics(),
                                                    shrinkWrap: true,
                                                    padding: EdgeInsets.only(
                                                        top: 0, right: 0),
                                                    itemCount:
                                                        listToShow.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return StationTileFastOrder(
                                                        stationData:
                                                            listToShow[index],
                                                        selectedContacts: widget
                                                            .selectedContacts,
                                                        startDate:
                                                            widget.startDate,
                                                      );
                                                    },
                                                  ),
                                                );
                                              else
                                                return Container();
                                            }),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else
          return Container();
      },
    );
  }
}
