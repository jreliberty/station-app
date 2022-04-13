import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../entities/advantage.dart';
import '../../entities/api_exception.dart';
import '../../entities/cart.dart';
import '../../entities/contact.dart';
import '../../entities/domain.dart';
import '../../entities/offer.dart';
import '../../entities/order/order.dart';
import '../../entities/payment/card_payment.dart';
import '../../entities/push_notification.dart';
import '../../entities/station.dart';
import '../../entities/token.dart';
import '../../entities/user.dart';
import '../../entities/validity.dart';
import '../../entities/violation_error.dart';
import '../api_client.dart';

class ApiHelper {
  Map<String, String>? getHeaders({String? jwt}) {
    var headers = <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.acceptHeader: 'application/ld+json',
    };

    if (jwt != null) {
      headers[HttpHeaders.authorizationHeader] = 'Bearer ' + jwt;
    }

    return headers;
  }

  Map<String, dynamic> getBodyPayment({required CardPayment cardPayment}) {
    print({
      "card_brand": cardPayment.selectedBrand,
      "card_code": cardPayment.cardCode,
      "card_type": cardPayment.cardType,
      "card_validity_date": cardPayment.cardValidityDate,
      "card_token": cardPayment.cardToken,
      "order_token": cardPayment.orderToken,
      "card_fullname": cardPayment.cardFullname,
    });
    return {
      "card_brand": cardPayment.selectedBrand,
      "card_code": cardPayment.cardCode,
      "card_type": cardPayment.cardType,
      "card_validity_date": cardPayment.cardValidityDate,
      "card_token": cardPayment.cardToken,
      "order_token": cardPayment.orderToken,
      "card_fullname": cardPayment.cardFullname,
    };
  }

  Map<String, dynamic> getParamsFirstSimulation(
      {required List<Contact> contacts,
      required Station station,
      required Domain domain,
      required String startDate,
      required Validity selectedValidity}) {
    var params = <String, dynamic>{};
    contacts.forEach((element) {
      params['sk[${element.index}][age]'] = element.age.toString();
    });
    params['ctid'] = station.contractorId.toString();
    params['s'] = startDate;
    params['pc'] = domain.shortname;
    params['vc'] = selectedValidity.shortName;
    return params;
  }

  Map<String, dynamic> getParamsFirstSimulationWithPossiblePromo(
      {required User user,
      required Station station,
      required Domain domain,
      required String startDate,
      required List<Contact> selectedContacts,
      required Validity selectedValidity}) {
    var params = <String, dynamic>{};
    selectedContacts.forEach((element) {
      params['sk[${element.index}][age]'] = element.age.toString();
    });
    params['ctid'] = station.contractorId.toString();
    params['s'] = startDate;
    params['pc'] = domain.shortname;
    params['vc'] = selectedValidity.shortName;
    return params;
  }

  Map<String, dynamic> getParamsFirstSimulationFastCart(
      {required User user,
      required Station station,
      required Domain domain,
      required String startDate,
      required Validity selectedValidity}) {
    var params = <String, dynamic>{};
    user.contacts.forEach((element) {
      params['sk[${element.index}][age]'] = element.age.toString();
    });
    params['ctid'] = station.contractorId.toString();
    params['s'] = startDate;
    params['pc'] = domain.shortname;
    params['vc'] = selectedValidity.shortName;
    return params;
  }

  // Map<String, dynamic> getParamsSecondSimulation({required Cart cart}) {
  //   var params = <String, dynamic>{};
  //   cart.selectedContacts.forEach((element) {
  //     params['sk[${element.index}][age]'] = element.age.toString();
  //   });
  //   if (cart.selectedInsurances.isNotEmpty)
  //     cart.selectedInsurances.forEach((element) {
  //       params['sk[${element.index}][opts][${cart.insurance.slug}]'] = 1;
  //     });
  //   params['ctid'] = cart.station;
  //   params['s'] = cart.startDate;
  //   params['pc'] = cart.domain;
  //   params['vc'] = cart.validity;
  //   return params;
  // }

  Map<String, dynamic> getParamsOrder({required Cart cart}) {
    print(cart.selectedValidity);
    var params = <String, dynamic>{};
    cart.selectedContacts.forEach((element) {
      print(element.elibertyId);
      print(element.numPass);
      params['sk[${element.index}][age]'] = element.age.toString();
      params['sk[${element.index}][contact]'] = element.elibertyId.toString();
      params['sk[${element.index}][pass_number]'] = element.numPass;
    });
    if (cart.selectedInsurances.isNotEmpty)
      cart.selectedInsurances.forEach((element) {
        params['sk[${element.index}][opts][${cart.insurance.slug}]'] = '1';
      });

    var formatter = new DateFormat('yyy-MM-dd');
    params['ctid'] = cart.station.contractorId.toString();
    params['s'] = formatter.format(cart.startDate);
    params['pc'] = cart.domain.shortname;
    params['vc'] = cart.selectedValidity!.shortName;
    print(params);
    return params;
  }

  List<Station> parseListStations({required Map<String, dynamic> jsonResult}) {
    final result = <Station>[];

    for (var stationJson in jsonResult['hydra:member'] as List<dynamic>) {
      bool activeStation = stationJson["active"] ?? false;
      if (activeStation) {
        var station = Station.fromJson(stationJson);
        result.add(station);
      }
    }

    return result;
  }

  List<Offer> parseListOffers({required Map<String, dynamic> jsonResult}) {
    final result = <Offer>[];

    for (var offerJson in jsonResult['hydra:member'] as List<dynamic>) {
      var offer = Offer.fromJson(offerJson);
      result.add(offer);
    }

    return result;
  }

  List<Advantage> parseListAdvantages(
      {required Map<String, dynamic> jsonResult}) {
    final result = <Advantage>[];

    for (var advantageJson in jsonResult['hydra:member'] as List<dynamic>) {
      var advantage = Advantage.fromJson(advantageJson);
      result.add(advantage);
    }

    return result;
  }

  ApiException getApiException(
      {int? code,
      String? message,
      propertyPath,
      Exception? exception,
      StackTrace? stackTrace}) {
    var list = <ViolationError>[];
    list.add(ViolationError(
        code: code, message: message, propertyPath: propertyPath));

    return ApiException(errors: ViolationsError(list: list));
  }

  Future<Token> getCachedToken({bool init = false}) async {
    ApiClient apiClient = ApiClient();
    String jwt = '';
    String refreshToken = '';
    late Token token;
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('token') != null) {
      jwt = prefs.getString('token')!;
    }
    if (prefs.getString('refresh_token') != null) {
      refreshToken = prefs.getString('refresh_token')!;
    }
    if (init == false &&
        jwt != '' &&
        JwtDecoder.isExpired(jwt) &&
        refreshToken != '') {
      token = await apiClient.refreshJwt();
    } else if (init == false &&
        jwt != '' &&
        JwtDecoder.decode(jwt)['eliberty_user_id'] == null) {
      token = await apiClient.refreshJwt();
    } else
      token = Token(token: jwt, refreshToken: refreshToken);
    return token;
  }

  Future<void> resetCachedJWT() async {
    var prefs = await SharedPreferences.getInstance();

    await prefs.remove('token');
    await prefs.remove('refresh_token');
    await prefs.remove('init');
  }

  Future<String> getCachedNotifications() async {
    String notifications;
    var prefs = await SharedPreferences.getInstance();

    if (prefs.getString('notifications') != null) {
      notifications = prefs.getString('notifications')!;
    } else {
      notifications = '';
    }

    return notifications;
  }

  Future<void> updateCacheNotifications(
      {required List<PushNotification> notifications}) async {
    var prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> mapNotifs = {};
    List<Map<String, dynamic>> listNotifs = [];
    notifications.forEach((element) {
      listNotifs.add(element.toJson());
    });
    mapNotifs['notifications'] = listNotifs;
    await prefs.setString('notifications', jsonEncode(mapNotifs));
  }

  Future<int> getCachedFavoriteStation() async {
    int contractorId;
    var prefs = await SharedPreferences.getInstance();

    if (prefs.getString('favoriteStation') != null) {
      contractorId = int.parse(prefs.getString('favoriteStation')!);
    } else {
      contractorId = 0;
    }

    return contractorId;
  }

  Future<void> updateFavoriteStation({required int contractorId}) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('favoriteStation', contractorId.toString());
  }

  List<Order> parseListOrders({required Map<String, dynamic> jsonResult}) {
    final result = <Order>[];

    for (var orderJson in jsonResult['data'] as List<dynamic>) {
      var order = Order.fromJson(json: orderJson);
      result.add(order);
    }
    print(result);
    return result;
  }
}
