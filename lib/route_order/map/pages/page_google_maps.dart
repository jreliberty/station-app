import 'dart:async';
import 'dart:io';

import 'package:animated_widgets/animated_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../blocs/datepicker/datepicker_bloc.dart';
import '../../../blocs/network/network_bloc.dart';
import '../../../blocs/orders_history/orders_history_bloc.dart';
import '../../../blocs/position/position_bloc.dart';
import '../../../blocs/stations/stations_bloc.dart';
import '../../../constants/colors.dart';
import '../../../core/errors/page_airplane_mode.dart';
import '../../../core/errors/page_disconnected.dart';
import '../../../core/functions/functions.dart';
import '../../../entities/station.dart';
import '../../domain/pages/page_domaines.dart';
import '../functions/geolocate.dart';
import '../functions/icon_generator.dart';
import '../widgets/station_card.dart';
import 'loading_scaffold_maps.dart';
import 'page_date_picker.dart';
import 'page_recherche_stations.dart';

const double ZOOM = 12;

class PageGoogleMaps extends StatefulWidget {
  PageGoogleMaps({Key? key}) : super(key: key);

  @override
  _PageGoogleMapsState createState() => _PageGoogleMapsState();
}

DateTime? date;
bool isSelectedDate = false;
String stringDate = tr('orders.map.labels.when');

class _PageGoogleMapsState extends State<PageGoogleMaps> {
  void initState() {
    init();
    super.initState();
  }

  init() async {
    Position? position;
    try {
      if (Platform.isAndroid)
        position = await determinePositionAndroid();
      else
        position = await determinePositionIos();
    } catch (e) {
      print(e);
    }
    bool isSelectedStation = false;
    Station? selectedStation;
    if (BlocProvider.of<StationsBloc>(context).state is StationsLoadSuccess) {
      isSelectedStation =
          (BlocProvider.of<StationsBloc>(context).state as StationsLoadSuccess)
              .isSelectedStation;
      selectedStation =
          (BlocProvider.of<StationsBloc>(context).state as StationsLoadSuccess)
              .selectedStation;
    }
    await Future.delayed(Duration(milliseconds: 500));
    if (isSelectedStation && selectedStation != null)
      _goToThisPosition(
          LatLng(selectedStation.latitude, selectedStation.longitude));
    else if (position != null)
      _goToThisPosition(LatLng(position.latitude, position.longitude));
    setState(() {});
  }

  Set<Marker> _markers = {};

  Completer<GoogleMapController> _controller = Completer();

  Future<void> _goToThisPosition(LatLng _newPosition) async {
    CameraPosition _newCam = CameraPosition(
      target: _newPosition,
      zoom: ZOOM,
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_newCam));
  }

  Future<void> _onMapCreated(List<Station> listStations) async {
    listStations.forEach((element) async {
      var price = getHigherPriceStation(element);
      // element.domains.sort((a, b) => a.validities[0].pricesInfo.bestPrice!
      //     .compareTo(b.validities[0].pricesInfo.bestPrice!));
      BitmapDescriptor bitmapDescriptor = await createCustomMarkerBitmap((element
              .activeSales)
          ? '${element.name} - ${((price[0] / 100) % 1) == 0 ? (price[0] / 100).truncate() : (price[0] / 100).toStringAsFixed(2).replaceAll('.', ',')} €'
          : '${element.name}');
      BitmapDescriptor bitmapDescriptorSelected =
          await createCustomMarkerBitmapSelected((element.activeSales)
              ? '${element.name} - ${((price[0] / 100) % 1) == 0 ? (price[0] / 100).truncate() : (price[0] / 100).toStringAsFixed(2).replaceAll('.', ',')} €'
              : '${element.name}');
      var infoSelected =
          (BlocProvider.of<StationsBloc>(context).state as StationsLoadSuccess);
      if (element.active)
        _markers.add(Marker(
          onTap: () {
            _goToThisPosition(LatLng(element.latitude, element.longitude));
            var info = (BlocProvider.of<StationsBloc>(context).state
                as StationsLoadSuccess);

            if (info.isSelectedStation &&
                (info.selectedStation!.name == element.name))
              BlocProvider.of<StationsBloc>(context).add(DeselectStationEvent(
                  selectedStation: element,
                  date: date,
                  listStations: listStations));
            else
              BlocProvider.of<StationsBloc>(context).add(SelectStationEvent(
                  selectedStation: element,
                  date: date,
                  listStations: listStations));
          },
          markerId: MarkerId('${element.id}'),
          position: LatLng(element.latitude, element.longitude),
          icon: (infoSelected.isSelectedStation &&
                  (infoSelected.selectedStation!.name == element.name))
              ? bitmapDescriptorSelected
              : bitmapDescriptor,
          anchor: Offset(0.5, 1),
        ));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StationsBloc, StationsState>(
      listener: (context, state) {
        if (state is StationsLoadSuccess) {
          if (state.isReset) {
            print('hey');
            if (state.selectedStation!.contractorId != 0) {
              var selectedStationAfterReset = state.listStations
                  .where((element) =>
                      element.contractorId ==
                      state.selectedStation!.contractorId)
                  .first;
              BlocProvider.of<StationsBloc>(context).add(SelectStationEvent(
                  selectedStation: selectedStationAfterReset,
                  date: date,
                  listStations: state.listStations));
            }
            _onMapCreated(state.listStations);
          } else
            _onMapCreated(state.listStations);
        }
        // TODO: implement listener
      },
      child: BlocBuilder<NetworkBloc, NetworkState>(
        builder: (context, stateNetwork) {
          if (stateNetwork is NetworkFailure) {
            print('On est pas connectés');
            if (stateNetwork.isAirplaneModeOn) return PageAirplaneMode();
          }
          return BlocBuilder<StationsBloc, StationsState>(
            builder: (context, state) {
              if (state is StationsLoadSuccess) {
                // if (state.isReset) {
                //   print('hey');
                //   if (state.selectedStation!.contractorId != 0) {
                //     var selectedStationAfterReset = state.listStations
                //         .where((element) =>
                //             element.contractorId ==
                //             state.selectedStation!.contractorId)
                //         .first;
                //     BlocProvider.of<StationsBloc>(context).add(
                //         SelectStationEvent(
                //             selectedStation: selectedStationAfterReset,
                //             date: date,
                //             listStations: state.listStations));
                //   }
                //   _onMapCreated(state.listStations);
                // }

                return Scaffold(
                  body: body(state.listStations, state.isSelectedStation,
                      state.selectedStation, state.date),
                );
              } else if (state is StationsLoadInProgress) {
                return LoadingScaffoldMaps();
              } else
                return PageDisconnected(function: () {
                  var ordersHistoryBloc =
                      BlocProvider.of<OrdersHistoryBloc>(context);
                  BlocProvider.of<StationsBloc>(context).add(
                      InitStationsEvent(ordersHistoryBloc: ordersHistoryBloc));
                });
            },
          );
        },
      ),
    );
  }

  Widget body(List<Station> listStations, bool isSelectedStation,
      Station? selectedStation, DateTime? selectedDate) {
    if (selectedDate != null) {
      date = selectedDate;
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
    } else {
      isSelectedDate = false;
      date = null;
    }
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              myLocationButtonEnabled: false,
              onTap: (_) {
                BlocProvider.of<StationsBloc>(context).add(DeselectStationEvent(
                    selectedStation: selectedStation!,
                    date: date,
                    listStations: listStations));
              },
              mapType: MapType.terrain,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);

                _onMapCreated(listStations);
                if (isSelectedStation) {
                  if (selectedStation != null)
                    _goToThisPosition(LatLng(
                        selectedStation.latitude, selectedStation.longitude));
                }
              },
              markers: _markers,
              initialCameraPosition: CameraPosition(
                target: isSelectedStation
                    ? LatLng(
                        selectedStation!.latitude, selectedStation.longitude)
                    : LatLng(
                        listStations
                            .where((element) =>
                                element.name.toLowerCase().contains(''))
                            .first
                            .latitude,
                        listStations
                            .where((element) =>
                                element.name.toLowerCase().contains(''))
                            .first
                            .longitude),
                zoom: ZOOM,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30, right: 84, left: 84),
              child: Container(
                height: 56,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          ColorsApp.BackgroundPrimary,
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28.0),
                        ))),
                    onPressed: () async {
                      Position? position;
                      try {
                        if (Platform.isAndroid)
                          position = await determinePositionAndroid();
                        else
                          position = await determinePositionIos();
                      } catch (e) {
                        print(e);
                      }
                      if (position != null) {
                        _goToThisPosition(
                            LatLng(position.latitude, position.longitude));
                      }
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 18, bottom: 18, right: 11),
                          child: Icon(
                            FlutterRemix.navigation_line,
                            size: 20,
                            color: Color.fromRGBO(0, 125, 188, 1),
                          ),
                        ),
                        Text(
                          tr('orders.map.buttons.button1.label'),
                          style: GoogleFonts.roboto(
                              fontSize: 16,
                              //color: Color(#687787),
                              color: Color.fromRGBO(0, 104, 157, 1),
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    )),
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: TranslationAnimatedWidget(
                enabled: isSelectedStation, //will forward/reverse the animation
                curve: Curves.easeIn,
                duration: Duration(milliseconds: 500),
                values: [
                  Offset(0, 300),
                  Offset(0, -50),
                  Offset(0, 0),
                ],
                child: StationCard(station: selectedStation, date: date),
              )),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 50),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.white,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: InkWell(
                    onTap: () async {
                      /*showMaterialModalBottomSheet(
                        enableDrag: false,
                        context: context,
                        builder: (context) => PageRechercheStations(),
                      );*/
                      Position? position;
                      // try {
                      //   if (Platform.isAndroid)
                      //     position = await determinePositionAndroid();
                      //   else
                      //     position = await determinePositionIos();
                      // } catch (e) {
                      //   print(e);
                      // }
                      if (BlocProvider.of<PositionBloc>(context).state
                          is PositionLoadSuccess)
                        position = (BlocProvider.of<PositionBloc>(context).state
                                as PositionLoadSuccess)
                            .position;
                      var station = await showCupertinoModalPopup(
                          context: context,
                          builder: (context) => PageRechercheStations(
                                position: position,
                              ));

                      _goToThisPosition(
                          LatLng(station.latitude, station.longitude));

                      BlocProvider.of<StationsBloc>(context).add(
                          SelectStationEvent(
                              selectedStation: station,
                              date: date,
                              listStations: listStations));
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 19, top: 13, bottom: 13, right: 11),
                          child: Icon(
                            FlutterRemix.map_pin_line,
                            color: ColorsApp.ContentPrimary,
                            size: 24,
                          ),
                        ),
                        Text(
                          !isSelectedStation
                              ? tr('orders.map.labels.where')
                              : (selectedStation!.name.length > 7)
                                  ? selectedStation.name.substring(0, 8) + '...'
                                  : selectedStation.name,
                          style: GoogleFonts.roboto(
                              fontSize: 16,
                              //color: Color(#687787),
                              color: isSelectedStation
                                  ? ColorsApp.ContentPrimary
                                  : Color.fromRGBO(137, 150, 162, 1),
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  )),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 8, bottom: 8, right: 18),
                    child: VerticalDivider(
                      color: Color.fromRGBO(137, 150, 162, 1),
                      thickness: 1,
                    ),
                  ),
                  Expanded(
                      child: InkWell(
                    onTap: () async {
                      var tempDate = await showCupertinoModalPopup(
                        context: context,
                        builder: (context) => PageDatePicker(
                          date: date,
                        ),
                      );
                      if (tempDate != null) {
                        BlocProvider.of<StationsBloc>(context)
                            .add(ResetStationEvent(
                          date: tempDate,
                          selectedStation: selectedStation!,
                        ));
                        date = tempDate;
                        final now = DateTime.now();
                        final today = DateTime(now.year, now.month, now.day);
                        final tomorrow =
                            DateTime(now.year, now.month, now.day + 1);
                        final aDate =
                            DateTime(date!.year, date!.month, date!.day);
                        if (aDate == today) {
                          stringDate = tr('common.today');
                        } else if (aDate == tomorrow) {
                          stringDate = tr('common.tomorrow');
                        } else
                          stringDate = formatDate.format(aDate);
                        isSelectedDate = true;
                        setState(() {});
                      }
                    },
                    child: BlocListener<DatepickerBloc, DatepickerState>(
                      listener: (context, state) async {
                        if (state is DatepickerRequested) {
                          var tempDate = await showCupertinoModalPopup(
                            context: context,
                            builder: (context) => PageDatePicker(
                              date: date,
                            ),
                          );
                          if (tempDate != null) {
                            BlocProvider.of<StationsBloc>(context)
                                .add(ResetStationEvent(
                              date: tempDate,
                              selectedStation: selectedStation!,
                            ));
                            date = tempDate;
                            final now = DateTime.now();
                            final today =
                                DateTime(now.year, now.month, now.day);
                            final tomorrow =
                                DateTime(now.year, now.month, now.day + 1);
                            final aDate =
                                DateTime(date!.year, date!.month, date!.day);
                            if (aDate == today) {
                              stringDate = tr('common.today');
                            } else if (aDate == tomorrow) {
                              stringDate = tr('common.tomorrow');
                            } else
                              stringDate = formatDate.format(aDate);
                            isSelectedDate = true;
                            setState(() {});
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        PageDomaines(
                                          station: selectedStation,
                                          startDate: aDate,
                                        )));
                          }
                        } else if (state is DatepickerNotRequested) {
                          if (date != null) {
                            BlocProvider.of<StationsBloc>(context).add(
                                SelectStationEvent(
                                    selectedStation: selectedStation!,
                                    date: date,
                                    listStations: listStations));
                            isSelectedDate = true;
                            setState(() {});
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        PageDomaines(
                                          station: selectedStation,
                                          startDate: date,
                                        )));
                          }
                        }
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 13, bottom: 13, right: 11),
                            child: Icon(
                              FlutterRemix.calendar_line,
                              size: 24,
                              color: ColorsApp.ContentPrimary,
                            ),
                          ),
                          Text(
                            stringDate,
                            style: GoogleFonts.roboto(
                                fontSize: 16,
                                //color: Color(#687787),
                                color: isSelectedDate
                                    ? ColorsApp.ContentPrimary
                                    : Color.fromRGBO(137, 150, 162, 1),
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  var formatDate = new DateFormat("dd/MM/yyyy");
}
