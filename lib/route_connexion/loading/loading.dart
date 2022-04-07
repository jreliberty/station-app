import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../blocs/config/config_bloc.dart';
import '../../blocs/consumer/consumer_bloc.dart';
import '../../blocs/favorite_station/favorite_station_bloc.dart';
import '../../blocs/home/home_bloc.dart';
import '../../blocs/login/login_bloc.dart';
import '../../blocs/newsletter/newsletter_bloc.dart';
import '../../blocs/notifications/notifications_bloc.dart';
import '../../blocs/orders_history/orders_history_bloc.dart';
import '../../blocs/position/position_bloc.dart';
import '../../blocs/stations/stations_bloc.dart';
import '../../bottom_tab_bar/pages/page_bottom_tab_bar.dart';
import '../../route_init/page_init_tab_bar.dart';
import '../login/pages/page_login.dart';
import '../splashscreen/bot_clipper.dart';
import '../splashscreen/top_clipper.dart';

class LoadingConnection extends StatefulWidget {
  LoadingConnection({Key? key}) : super(key: key);

  @override
  _LoadingConnectionState createState() => _LoadingConnectionState();
}

class _LoadingConnectionState extends State<LoadingConnection> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) async {
            print(state);
            if (state is GettingJwtDone) {
              Future.delayed(Duration(milliseconds: 1000), () {
                var ordersHistoryBloc =
                    BlocProvider.of<OrdersHistoryBloc>(context);
                BlocProvider.of<ConsumerBloc>(context).add(InitConsumerEvent());
                BlocProvider.of<StationsBloc>(context).add(
                    InitStationsEvent(ordersHistoryBloc: ordersHistoryBloc));
                BlocProvider.of<HomeBloc>(context).add(InitHomeEvent());
                BlocProvider.of<FavoriteStationBloc>(context)
                    .add(InitFavoriteStationEvent());
                BlocProvider.of<NotificationsBloc>(context)
                    .add(InitNotificationsEvent());
                BlocProvider.of<ConfigBloc>(context).add(InitConfigEvent());
                BlocProvider.of<NewsletterBloc>(context)
                    .add(InitNewsletterEvent());
                BlocProvider.of<PositionBloc>(context).add(InitPositionEvent());
              });
            }
            if (state is GettingJwtFailure) {
              BlocProvider.of<LoginBloc>(context).add(GetUrlForLoginEvent());
              showCupertinoModalPopup(
                  context: context, builder: (context) => PageLogin());
            }
          },
        ),
        BlocListener<ConsumerBloc, ConsumerState>(
          listener: (context, state) async {
            if (state is ConsumerLoadSuccess) {
              bool goToInit = true;
              var prefs = await SharedPreferences.getInstance();
              var checker = state.user.checkData();
              if (prefs.getString('init') != null || checker) {
                goToInit = false;
              }
              if (goToInit) {
                BlocProvider.of<ConsumerBloc>(context)
                    .add(ListenConsumerEvent(state.user.id));
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => PageInitTabBar()),
                    (Route<dynamic> route) => false);
              } else
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => PageBottomTabBar(
                          initialIndex: 0,
                        )));
            }
          },
        ),
      ],
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, stateLogin) {
          return BlocBuilder<ConsumerBloc, ConsumerState>(
            builder: (context, stateConsumer) {
              // if (stateConsumer is ConsumerLoadInProgress ||
              //     stateLogin is GettingJwtInProgress)
              return Scaffold(
                  body: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/splashscreen/skieur.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  ClipPath(
                    clipper: TopClipper(),
                    child: Container(
                        child: Image.asset(
                      "assets/splashscreen/fond.png",
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    )),
                  ),
                  ClipPath(
                    clipper: BotClipper(),
                    child: Container(
                      color: Color.fromRGBO(1, 43, 73, 1),
                    ),
                  ),
                  Center(
                      child: Container(
                          child: Image.asset(
                    "assets/splashscreen/logo.png",
                    height: 130,
                    width: 270,
                  ))),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator()),
                          SizedBox(width: 10),
                          Text(
                            tr("common.loading"),
                            style: GoogleFonts.roboto(
                                height: 1.2,
                                fontSize: 15,
                                color: Colors.white.withOpacity(0.5),
                                fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ));
              // else
              //   return Container();
            },
          );
        },
      ),
    );
  }
}
