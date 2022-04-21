import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:station/blocs/connexion/connexion_bloc.dart';

import 'blocs/cart/cart_bloc.dart';
import 'blocs/config/config_bloc.dart';
import 'blocs/consumer/consumer_bloc.dart';
import 'blocs/datepicker/datepicker_bloc.dart';
import 'blocs/fast_cart/fast_cart_bloc.dart';
import 'blocs/favorite_station/favorite_station_bloc.dart';
import 'blocs/home/home_bloc.dart';
import 'blocs/network/network_bloc.dart';
import 'blocs/newsletter/newsletter_bloc.dart';
import 'blocs/notifications/notifications_bloc.dart';
import 'blocs/order/order_bloc.dart';
import 'blocs/orders_history/orders_history_bloc.dart';
import 'blocs/pass/pass_bloc.dart';
import 'blocs/payment/payment_bloc.dart';
import 'blocs/position/position_bloc.dart';
import 'blocs/stations/stations_bloc.dart';
import 'constants/colors.dart';
import 'constants/config.dart';
import 'nfc_qr_code/bloc/nfc_bloc.dart';
import 'repository/api_client.dart';
import 'repository/api_repository.dart';
import 'route_connexion/splashscreen/splashscreen.dart';

Future<void> main() async {
  final apiRepository = ApiRepository(apiClient: ApiClient());
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    // DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  final packageInfo = await PackageInfo.fromPlatform();
  await SentryFlutter.init(
      (options) => options
        ..dsn = MyConfig.SENTRY_DSN
        ..release = packageInfo.version
        ..debug = false
        ..sendDefaultPii = true
        ..environment = 'production',
      appRunner: () => runApp(EasyLocalization(
            supportedLocales: [Locale('en', 'US'), Locale('fr', 'FR')],
            path: 'assets/languages',
            // <-- change the path of the translation files
            fallbackLocale: Locale('en', 'US'),
            startLocale: Locale('fr', 'FR'),
            saveLocale: true,
            child: MyApp(
              apiRepository: apiRepository,
            ),
          )));
}

class MyApp extends StatefulWidget {
  final ApiRepository apiRepository;

  const MyApp({Key? key, required this.apiRepository}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ConsumerBloc(apiRepository: widget.apiRepository),
        ),
        BlocProvider(
          create: (context) =>
              StationsBloc(apiRepository: widget.apiRepository),
        ),
        BlocProvider(
          create: (context) => CartBloc(apiRepository: widget.apiRepository),
        ),
        BlocProvider(
          create: (context) => DatepickerBloc(),
        ),
        BlocProvider(
          create: (context) => PassBloc(apiRepository: widget.apiRepository),
        ),
        BlocProvider(
          create: (context) => OrderBloc(apiRepository: widget.apiRepository),
        ),
        BlocProvider(
          create: (context) =>
              NotificationsBloc(apiRepository: widget.apiRepository),
        ),
        BlocProvider(
          create: (context) => NfcBloc(),
        ),
        BlocProvider(
          create: (context) => HomeBloc(apiRepository: widget.apiRepository),
        ),
        BlocProvider(
          create: (context) => PaymentBloc(apiRepository: widget.apiRepository),
        ),
        BlocProvider(
          create: (context) =>
              FavoriteStationBloc(apiRepository: widget.apiRepository),
        ),
        BlocProvider(
          create: (context) =>
              OrdersHistoryBloc(apiRepository: widget.apiRepository),
        ),
        BlocProvider(
          create: (context) => ConfigBloc(apiRepository: widget.apiRepository),
        ),
        BlocProvider(
          create: (context) =>
              NewsletterBloc(apiRepository: widget.apiRepository),
        ),
        BlocProvider(
          create: (context) =>
              FastCartBloc(apiRepository: widget.apiRepository),
        ),
        BlocProvider(
          create: (context) =>
              ConnexionBloc(apiRepository: widget.apiRepository),
        ),
        BlocProvider(
          create: (context) => NetworkBloc()..add(ListenConnection()),
        ),
        BlocProvider(create: (context) => PositionBloc()),
      ],
      child: OverlaySupport(
        child: MaterialApp(
          title: 'Decathlon Pass',
          theme: ThemeData(
            scaffoldBackgroundColor: ColorsApp.BackgroundPrimary,
            primaryColor: ColorsApp.BackgroundPrimary,
          ),
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,

          // Returns a locale which will be used by the app
          localeResolutionCallback: (locale, supportedLocales) {
            // Check if the current device locale is supported
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale!.languageCode &&
                  supportedLocale.countryCode == locale.countryCode) {
                return supportedLocale;
              }
            }
            // If the locale of the device is not supported, use the first one
            // from the list (English, in this case).
            return supportedLocales.first;
          },
          // checkerboardOffscreenLayers: true,
          debugShowCheckedModeBanner: false,
          home: MyHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  void callback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
