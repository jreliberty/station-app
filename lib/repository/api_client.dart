import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/routes.dart';
import '../entities/advantage.dart';
import '../entities/api_exception.dart';
import '../entities/cart.dart';
import '../entities/config.dart';
import '../entities/contact.dart';
import '../entities/domain.dart';
import '../entities/offer.dart';
import '../entities/open_pass_response.dart';
import '../entities/order/order.dart';
import '../entities/orders_history.dart';
import '../entities/payment/card_payment.dart';
import '../entities/payment/payment_response.dart';
import '../entities/push_notification.dart';
import '../entities/station.dart';
import '../entities/token.dart';
import '../entities/user.dart';
import '../entities/validity.dart';
import '../entities/violation_error.dart';
import 'helpers/api_helper.dart';
import 'helpers/logger.dart';

class ApiClient {
  late ApiHelper apiHelper;
  Dio dio = Dio();
  late PersistCookieJar cj;

  http.Client client = http.Client();

  ApiClient() {
    apiHelper = ApiHelper();
  }

  Future<void> clearCookies() async {
    await cj.deleteAll();
  }

  Future<PaymentResponse> createPayment(
      {required CardPayment cardPayment}) async {
    try {
      var token = await apiHelper.getCachedToken();
      var headers = apiHelper.getHeaders(jwt: token.token);
      var body = apiHelper.getBodyPayment(cardPayment: cardPayment);
      await client.post(Uri.parse(Routes.PREPARE_PAYMENT),
          headers: headers,
          body: jsonEncode({"token": cardPayment.orderToken}));

      final response = await client.post(Uri.parse(Routes.CREATE_PAYMENT),
          headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        var jsonResult = jsonDecode(response.body);
        print(jsonResult);
        return PaymentResponse.fromJson(jsonResult);
      } else {
        Sentry.configureScope(
          (scope) => {
            scope.setExtra('statusCode', response.statusCode),
            scope.setExtra('response', response.body),
            scope.setExtra('jwt', token.token),
          },
        );

        await Sentry.captureMessage(
          'createPayment Error ',
          level: SentryLevel.error,
        );
        throw ApiException(
            errors: ViolationsError.fromJson(jsonDecode(response.body)));
      }
    } on SocketException catch (e, stackTrace) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw apiHelper.getApiException(
            code: 1000,
            message: 'No Internet',
            propertyPath: null,
            exception: e,
            stackTrace: stackTrace);
      }

      throw apiHelper.getApiException(
          code: 1003,
          message: 'Site not available',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on HttpException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** HttpException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1001,
          message: 'No Service Found',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on FormatException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** FormatException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1002,
          message: 'Invalid Response format',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on Exception catch (e) {
      ElibertyLogger.info('** Elib ** Exception ' + e.toString());

      rethrow;
    } on Error catch (e) {
      ElibertyLogger.info(
          '** Elib ** createPayment ' + e.toString() + e.stackTrace.toString());
      rethrow;
    }
  }

  Future<List<Station>> getSkiResortsList() async {
    try {
      var token = await apiHelper.getCachedToken();
      var headers = apiHelper.getHeaders(jwt: token.token);

      final response = await client.get(Uri.parse(Routes.SKI_RESORTS_LIST_DATA),
          headers: headers);

      if (response.statusCode == 200) {
        var jsonResult = jsonDecode(response.body);

        return apiHelper.parseListStations(jsonResult: jsonResult);
      } else {
        Sentry.configureScope(
          (scope) => {
            scope.setExtra('statusCode', response.statusCode),
            scope.setExtra('response', response.body),
            scope.setExtra('jwt', token.token),
          },
        );

        await Sentry.captureMessage(
          'getSkiResortsList Error ',
          level: SentryLevel.error,
        );

        throw ApiException(
            errors: ViolationsError.fromJson(jsonDecode(response.body)));
      }
    } on SocketException catch (e, stackTrace) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw apiHelper.getApiException(
            code: 1000,
            message: 'No Internet',
            propertyPath: null,
            exception: e,
            stackTrace: stackTrace);
      }

      throw apiHelper.getApiException(
          code: 1003,
          message: 'Site not available',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on HttpException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** HttpException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1001,
          message: 'No Service Found',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on FormatException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** FormatException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1002,
          message: 'Invalid Response format',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on Exception catch (e) {
      ElibertyLogger.info('** Elib ** Exception ' + e.toString());

      rethrow;
    } on Error catch (e) {
      ElibertyLogger.info('** Elib ** getSkiResortList ' +
          e.toString() +
          e.stackTrace.toString());
      rethrow;
    }
  }

  Future<List<Station>> getSkiResortsListWithDate(
      {required DateTime date}) async {
    try {
      var token = await apiHelper.getCachedToken();
      var headers = apiHelper.getHeaders(jwt: token.token);
      var formatDate = new DateFormat("yyyy-MM-dd");
      Map<String, dynamic> queryParams = {
        's': formatDate.format(date),
      };
      String queryString = Uri(queryParameters: queryParams).query;
      var requestUrl = Routes.SKI_RESORTS_LIST_DATA + '?' + queryString;
      final response =
          await client.get(Uri.parse(requestUrl), headers: headers);

      if (response.statusCode == 200) {
        var jsonResult = jsonDecode(response.body);
        return apiHelper.parseListStations(jsonResult: jsonResult);
      } else {
        Sentry.configureScope(
          (scope) => {
            scope.setExtra('statusCode', response.statusCode),
            scope.setExtra('response', response.body),
            scope.setExtra('jwt', token.token),
          },
        );

        await Sentry.captureMessage(
          'getSkiResortsList Error ',
          level: SentryLevel.error,
        );

        throw ApiException(
            errors: ViolationsError.fromJson(jsonDecode(response.body)));
      }
    } on SocketException catch (e, stackTrace) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw apiHelper.getApiException(
            code: 1000,
            message: 'No Internet',
            propertyPath: null,
            exception: e,
            stackTrace: stackTrace);
      }

      throw apiHelper.getApiException(
          code: 1003,
          message: 'Site not available',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on HttpException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** HttpException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1001,
          message: 'No Service Found',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on FormatException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** FormatException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1002,
          message: 'Invalid Response format',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on Exception catch (e) {
      ElibertyLogger.info('** Elib ** Exception ' + e.toString());

      rethrow;
    } on Error catch (e) {
      ElibertyLogger.info('** Elib ** getSkiResortList with Date ' +
          e.toString() +
          e.stackTrace.toString());
      rethrow;
    }
  }

  Future<List<Offer>> getListOffers() async {
    try {
      var token = await apiHelper.getCachedToken(init: true);
      var headers = apiHelper.getHeaders(jwt: token.token);

      final response = await client.get(Uri.parse(Routes.OFFERS_LIST_DATA_ASC),
          headers: headers);
      if (response.statusCode == 200) {
        var jsonResult = jsonDecode(response.body);

        return apiHelper.parseListOffers(jsonResult: jsonResult);
      } else {
        Sentry.configureScope(
          (scope) => {
            scope.setExtra('statusCode', response.statusCode),
            scope.setExtra('response', response.body),
            scope.setExtra('jwt', token.token),
          },
        );

        await Sentry.captureMessage(
          'getListOffers Error ',
          level: SentryLevel.error,
        );
        throw ApiException(
            errors: ViolationsError.fromJson(jsonDecode(response.body)));
      }
    } on SocketException catch (e, stackTrace) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw apiHelper.getApiException(
            code: 1000,
            message: 'No Internet',
            propertyPath: null,
            exception: e,
            stackTrace: stackTrace);
      }

      throw apiHelper.getApiException(
          code: 1003,
          message: 'Site not available',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on HttpException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** HttpException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1001,
          message: 'No Service Found',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on FormatException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** FormatException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1002,
          message: 'Invalid Response format',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on Exception catch (e) {
      ElibertyLogger.info('** Elib ** Exception ' + e.toString());

      rethrow;
    } on Error catch (e) {
      ElibertyLogger.info(
          '** Elib ** getListOffers ' + e.toString() + e.stackTrace.toString());
      rethrow;
    }
  }

  Future<List<Advantage>> getListAdvantages() async {
    try {
      var token = await apiHelper.getCachedToken(init: true);
      var headers = apiHelper.getHeaders(jwt: token.token);

      final response = await client
          .get(Uri.parse(Routes.ADVANTAGES_LIST_DATA_ASC), headers: headers);

      if (response.statusCode == 200) {
        var jsonResult = jsonDecode(response.body);

        return apiHelper.parseListAdvantages(jsonResult: jsonResult);
      } else {
        Sentry.configureScope(
          (scope) => {
            scope.setExtra('statusCode', response.statusCode),
            scope.setExtra('response', response.body),
            scope.setExtra('jwt', token.token),
          },
        );

        await Sentry.captureMessage(
          'getListAdvantages Error ',
          level: SentryLevel.error,
        );
        throw ApiException(
            errors: ViolationsError.fromJson(jsonDecode(response.body)));
      }
    } on SocketException catch (e, stackTrace) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw apiHelper.getApiException(
            code: 1000,
            message: 'No Internet',
            propertyPath: null,
            exception: e,
            stackTrace: stackTrace);
      }

      throw apiHelper.getApiException(
          code: 1003,
          message: 'Site not available',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on HttpException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** HttpException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1001,
          message: 'No Service Found',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on FormatException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** FormatException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1002,
          message: 'Invalid Response format',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on Exception catch (e) {
      ElibertyLogger.info('** Elib ** Exception ' + e.toString());

      rethrow;
    } on Error catch (e) {
      ElibertyLogger.info('** Elib ** getListAdvantages ' +
          e.toString() +
          e.stackTrace.toString());
      rethrow;
    }
  }

  Future<User> getUser() async {
    try {
      var token = await apiHelper.getCachedToken();
      var headers = apiHelper.getHeaders(jwt: token.token);

      final response =
          await client.get(Uri.parse(Routes.API_ME), headers: headers);

      if (response.statusCode == 200) {
        var jsonResult = jsonDecode(response.body);
        final responseContact = await client.get(
            Uri.parse(Routes.API_CONTACT +
                User.fromJson(json: jsonResult, jsonContacts: null).contactId +
                Routes.GET_CONTACTS),
            headers: headers);
        print('status response contact : ' +
            responseContact.statusCode.toString());
        print('status body contact : ' + responseContact.body.toString());
        return User.fromJson(
            json: jsonDecode(response.body),
            jsonContacts: jsonDecode(responseContact.body));
      } else {
        Sentry.configureScope(
          (scope) => {
            scope.setExtra('statusCode', response.statusCode),
            scope.setExtra('response', response.body),
            scope.setExtra('jwt', token.token),
          },
        );

        await Sentry.captureMessage(
          'getUser Error ',
          level: SentryLevel.error,
        );
        throw ApiException(
            errors: ViolationsError.fromJson(jsonDecode(response.body)));
      }
    } on SocketException catch (e, stackTrace) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw apiHelper.getApiException(
            code: 1000,
            message: 'No Internet',
            propertyPath: null,
            exception: e,
            stackTrace: stackTrace);
      }

      throw apiHelper.getApiException(
          code: 1003,
          message: 'Site not available',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on HttpException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** HttpException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1001,
          message: 'No Service Found',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on FormatException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** FormatException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1002,
          message: 'Invalid Response format',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on Exception catch (e) {
      ElibertyLogger.info('** Elib ** Exception ' + e.toString());

      rethrow;
    } on Error catch (e) {
      ElibertyLogger.info(
          '** Elib ** getUser ' + e.toString() + e.stackTrace.toString());
      rethrow;
    }
  }

  Future<User> createContact({
    required String body,
    required String bodyPhone,
    required String userId,
  }) async {
    try {
      var token = await apiHelper.getCachedToken();
      var headers = apiHelper.getHeaders(jwt: token.token);

      final response = await client.put(
          Uri.parse(Routes.API_MAIN_CONTACT_CREATE + userId),
          headers: headers,
          body: body);

      if (response.statusCode == 200) {
        var jsonResult = jsonDecode(response.body);
        var userCreated = User.fromJson(json: jsonResult, jsonContacts: null);

        print("keski se passeee");
        var user = await updateContactPersonalInfo(
            body: bodyPhone, contactId: userCreated.contactId);

        return user;
      } else {
        Sentry.configureScope(
          (scope) => {
            scope.setExtra('statusCode', response.statusCode),
            scope.setExtra('response', response.body),
            scope.setExtra('jwt', token.token),
          },
        );

        await Sentry.captureMessage(
          'createContact Error ',
          level: SentryLevel.error,
        );
        throw ApiException(
            errors: ViolationsError.fromJson(jsonDecode(response.body)));
      }
    } on SocketException catch (e, stackTrace) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw apiHelper.getApiException(
            code: 1000,
            message: 'No Internet',
            propertyPath: null,
            exception: e,
            stackTrace: stackTrace);
      }

      throw apiHelper.getApiException(
          code: 1003,
          message: 'Site not available',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on HttpException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** HttpException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1001,
          message: 'No Service Found',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on FormatException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** FormatException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1002,
          message: 'Invalid Response format',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on Exception catch (e) {
      ElibertyLogger.info('** Elib ** Exception ' + e.toString());

      rethrow;
    } on Error catch (e) {
      ElibertyLogger.info(
          '** Elib ** createContact ' + e.toString() + e.stackTrace.toString());
      rethrow;
    }
  }

  Future<User> updateContactPersonalInfo({
    required String body,
    required String contactId,
  }) async {
    try {
      var token = await apiHelper.getCachedToken();
      var headers = apiHelper.getHeaders(jwt: token.token);
      final response = await client.put(
          Uri.parse(Routes.API_CONTACT + contactId),
          headers: headers,
          body: body); //TO DO json CONTACT
      if (response.statusCode == 200) {
        final user = await getUser();

        print("2");
        return user;
      } else {
        Sentry.configureScope(
          (scope) => {
            scope.setExtra('statusCode', response.statusCode),
            scope.setExtra('response', response.body),
            scope.setExtra('jwt', token.token),
          },
        );

        await Sentry.captureMessage(
          'updateContactPersonalInfo Error ',
          level: SentryLevel.error,
        );
        throw ApiException(
            errors: ViolationsError.fromJson(jsonDecode(response.body)));
      }
    } on SocketException catch (e, stackTrace) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw apiHelper.getApiException(
            code: 1000,
            message: 'No Internet',
            propertyPath: null,
            exception: e,
            stackTrace: stackTrace);
      }

      throw apiHelper.getApiException(
          code: 1003,
          message: 'Site not available',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on HttpException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** HttpException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1001,
          message: 'No Service Found',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on FormatException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** FormatException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1002,
          message: 'Invalid Response format',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on Exception catch (e) {
      ElibertyLogger.info('** Elib ** Exception ' + e.toString());

      rethrow;
    } on Error catch (e) {
      ElibertyLogger.info('** Elib ** updateContactPersonalInfo ' +
          e.toString() +
          e.stackTrace.toString());
      rethrow;
    }
  }

  Future<User> createContactAdress({
    required String body,
  }) async {
    try {
      var token = await apiHelper.getCachedToken();
      var headers = apiHelper.getHeaders(jwt: token.token);
      final response = await client.post(Uri.parse(Routes.API_CREATE_ADRESS),
          body: body, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final user = await getUser();
        print("3");
        return user;
      } else {
        Sentry.configureScope(
          (scope) => {
            scope.setExtra('statusCode', response.statusCode),
            scope.setExtra('response', response.body),
            scope.setExtra('jwt', token.token),
          },
        );

        await Sentry.captureMessage(
          'createContactAdress Error ',
          level: SentryLevel.error,
        );
        throw ApiException(
            errors: ViolationsError.fromJson(jsonDecode(response.body)));
      }
    } on SocketException catch (e, stackTrace) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw apiHelper.getApiException(
            code: 1000,
            message: 'No Internet',
            propertyPath: null,
            exception: e,
            stackTrace: stackTrace);
      }

      throw apiHelper.getApiException(
          code: 1003,
          message: 'Site not available',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on HttpException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** HttpException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1001,
          message: 'No Service Found',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on FormatException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** FormatException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1002,
          message: 'Invalid Response format',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on Exception catch (e) {
      ElibertyLogger.info('** Elib ** Exception ' + e.toString());

      rethrow;
    } on Error catch (e) {
      ElibertyLogger.info('** Elib ** createContactAddress ' +
          e.toString() +
          e.stackTrace.toString());
      rethrow;
    }
  }

  Future<User> updateContactAdress({
    required String body,
    required String adressId,
  }) async {
    try {
      var token = await apiHelper.getCachedToken();
      var headers = apiHelper.getHeaders(jwt: token.token);
      final response = await client.put(
          Uri.parse(Routes.API_UPDATE_ADRESS + adressId),
          body: body,
          headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final user = await getUser();
        print("4");
        return user;
      } else {
        Sentry.configureScope(
          (scope) => {
            scope.setExtra('statusCode', response.statusCode),
            scope.setExtra('response', response.body),
            scope.setExtra('jwt', token.token),
          },
        );

        await Sentry.captureMessage(
          'updateContactAdress Error ',
          level: SentryLevel.error,
        );
        throw ApiException(
            errors: ViolationsError.fromJson(jsonDecode(response.body)));
      }
    } on SocketException catch (e, stackTrace) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw apiHelper.getApiException(
            code: 1000,
            message: 'No Internet',
            propertyPath: null,
            exception: e,
            stackTrace: stackTrace);
      }

      throw apiHelper.getApiException(
          code: 1003,
          message: 'Site not available',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on HttpException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** HttpException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1001,
          message: 'No Service Found',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on FormatException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** FormatException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1002,
          message: 'Invalid Response format',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on Exception catch (e) {
      ElibertyLogger.info('** Elib ** Exception ' + e.toString());

      rethrow;
    } on Error catch (e) {
      ElibertyLogger.info('** Elib ** updateContactAddress ' +
          e.toString() +
          e.stackTrace.toString());
      rethrow;
    }
  }

  Future<User> deleteContactAdress({
    required String adressId,
  }) async {
    try {
      var token = await apiHelper.getCachedToken();
      var headers = apiHelper.getHeaders(jwt: token.token);
      final response = await client.delete(
          Uri.parse(Routes.API_UPDATE_ADRESS + adressId),
          headers: headers);

      if (response.statusCode == 200 || response.statusCode == 204) {
        final user = await getUser();
        print("5");
        return user;
      } else {
        Sentry.configureScope(
          (scope) => {
            scope.setExtra('statusCode', response.statusCode),
            scope.setExtra('response', response.body),
            scope.setExtra('jwt', token.token),
          },
        );

        await Sentry.captureMessage(
          'deleteContactAdress Error ',
          level: SentryLevel.error,
        );
        throw ApiException(
            errors: ViolationsError.fromJson(jsonDecode(response.body)));
      }
    } on SocketException catch (e, stackTrace) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw apiHelper.getApiException(
            code: 1000,
            message: 'No Internet',
            propertyPath: null,
            exception: e,
            stackTrace: stackTrace);
      }

      throw apiHelper.getApiException(
          code: 1003,
          message: 'Site not available',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on HttpException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** HttpException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1001,
          message: 'No Service Found',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on FormatException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** FormatException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1002,
          message: 'Invalid Response format',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on Exception catch (e) {
      ElibertyLogger.info('** Elib ** Exception ' + e.toString());

      rethrow;
    } on Error catch (e) {
      ElibertyLogger.info('** Elib ** deleteContactAddress ' +
          e.toString() +
          e.stackTrace.toString());
      rethrow;
    }
  }

  Future<String> createSubcontact({
    required String body,
  }) async {
    try {
      var token = await apiHelper.getCachedToken();
      var headers = apiHelper.getHeaders(jwt: token.token);
      final response = await client.post(Uri.parse(Routes.API_CREATE_CONTACT),
          body: body, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var json = jsonDecode(response.body);
        if (json['id'] != null)
          return json['id'];
        else
          return '';
      } else {
        Sentry.configureScope(
          (scope) => {
            scope.setExtra('statusCode', response.statusCode),
            scope.setExtra('response', response.body),
            scope.setExtra('jwt', token.token),
          },
        );

        await Sentry.captureMessage(
          'createSubcontact Error ',
          level: SentryLevel.error,
        );
        throw ApiException(
            errors: ViolationsError.fromJson(jsonDecode(response.body)));
      }
    } on SocketException catch (e, stackTrace) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw apiHelper.getApiException(
            code: 1000,
            message: 'No Internet',
            propertyPath: null,
            exception: e,
            stackTrace: stackTrace);
      }

      throw apiHelper.getApiException(
          code: 1003,
          message: 'Site not available',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on HttpException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** HttpException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1001,
          message: 'No Service Found',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on FormatException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** FormatException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1002,
          message: 'Invalid Response format',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on Exception catch (e) {
      ElibertyLogger.info('** Elib ** Exception ' + e.toString());

      rethrow;
    } on Error catch (e) {
      ElibertyLogger.info('** Elib ** createSubcontact ' +
          e.toString() +
          e.stackTrace.toString());
      rethrow;
    }
  }

  Future<Response> getUrlOneId() async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      var tempPath = tempDir.path;
      var cj =
          PersistCookieJar(ignoreExpires: true, storage: FileStorage(tempPath));
      dio.interceptors.add(CookieManager(cj));
      final response = await dio.get(
        Routes.API_REDIRECT,
      );
      if (response.statusCode == 200) {
        return response;
      } else {
        Sentry.configureScope(
          (scope) => {
            scope.setExtra('statusCode', response.statusCode),
            scope.setExtra('response', response.data),
          },
        );

        await Sentry.captureMessage(
          'getUrlOneID Error ',
          level: SentryLevel.error,
        );
        throw ApiException(errors: ViolationsError.fromJson(response.data));
      }
    } on SocketException catch (e, stackTrace) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw apiHelper.getApiException(
            code: 1000,
            message: 'No Internet',
            propertyPath: null,
            exception: e,
            stackTrace: stackTrace);
      }

      throw apiHelper.getApiException(
          code: 1003,
          message: 'Website not available',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on HttpException catch (e, stackTrace) {
      throw apiHelper.getApiException(
          code: 1001,
          message: 'No Service Found',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on FormatException catch (e, stackTrace) {
      throw apiHelper.getApiException(
          code: 1002,
          message: 'Invalid Response format',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on Exception {
      rethrow;
    } on Error catch (e) {
      ElibertyLogger.info(
          '** Elib ** getUrlOneID ' + e.toString() + e.stackTrace.toString());
      rethrow;
    }
  }

  Future<Token> getJwt(Uri url) async {
    var prefs = await SharedPreferences.getInstance();
    try {
      var code = url.queryParameters['code'];
      var state = url.queryParameters['state'];
      Map<String, dynamic> body = {
        'code': code,
        'state': state,
        'redirect_uri': Routes.API_IDENTIFICATION
      };
      dio.options.contentType = Headers.formUrlEncodedContentType;
      final response = await dio.post(
        Routes.API_AUTH_URL,
        data: body,
      );
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200) {
        await prefs.setString('token', response.data['token']);
        await prefs.setString('refresh_token', response.data['refresh_token']);
        print("jusque làa ça passe");
        return Token.fromJson(response.data);
      } else {
        Sentry.configureScope(
          (scope) => {
            scope.setExtra('statusCode', response.statusCode),
            scope.setExtra('response', response.data),
          },
        );

        await Sentry.captureMessage(
          'getJwt Error ',
          level: SentryLevel.error,
        );
        throw ApiException(errors: ViolationsError.fromJson(response.data));
      }
    } on SocketException catch (e, stackTrace) {
      print("0");
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw apiHelper.getApiException(
            code: 1000,
            message: 'No Internet',
            propertyPath: null,
            exception: e,
            stackTrace: stackTrace);
      }

      throw apiHelper.getApiException(
          code: 1003,
          message: 'Website not available',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on HttpException catch (e, stackTrace) {
      print("1");
      throw apiHelper.getApiException(
          code: 1001,
          message: 'No Service Found',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on FormatException catch (e, stackTrace) {
      print("2");
      throw apiHelper.getApiException(
          code: 1002,
          message: 'Invalid Response format',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on Exception {
      print("3");
      rethrow;
    } on Error catch (e) {
      print("4");
      ElibertyLogger.info(
          '** Elib ** getJWT ' + e.toString() + e.stackTrace.toString());
      rethrow;
    }
  }

  Future<Token> refreshJwt() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      var token = await apiHelper.getCachedToken(init: true);
      Map<String, dynamic> queryParams = {
        'refresh_token': token.refreshToken,
      };
      String queryString = Uri(queryParameters: queryParams).query;
      var requestUrl = Routes.API_REFRESH_TOKEN + '?' + queryString;
      final response = await client.get(Uri.parse(requestUrl));
      if (response.statusCode == 200 || response.statusCode == 201) {
        await prefs.setString('token', jsonDecode(response.body)['token']);
        await prefs.setString(
            'refresh_token', jsonDecode(response.body)['refresh_token']);
        print("Saved !");
        return Token.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 400) {
        var json = jsonDecode(response.body);
        throw apiHelper.getApiException(
          code: response.statusCode,
          message: json['errors'][0],
          propertyPath: null,
        );
      } else {
        Sentry.configureScope(
          (scope) => {
            scope.setExtra('statusCode', response.statusCode),
            scope.setExtra('response', response.body),
            scope.setExtra('jwt', token.token),
          },
        );

        await Sentry.captureMessage(
          'Refresh Token Error',
          level: SentryLevel.error,
        );
        throw ApiException(
            errors: ViolationsError.fromJson(jsonDecode(response.body)));
      }
    } on SocketException catch (e, stackTrace) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw apiHelper.getApiException(
            code: 1000,
            message: 'No Internet',
            propertyPath: null,
            exception: e,
            stackTrace: stackTrace);
      }

      throw apiHelper.getApiException(
          code: 1003,
          message: 'Site not available',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on HttpException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** HttpException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1001,
          message: 'No Service Found',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on FormatException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** FormatException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1002,
          message: 'Invalid Response format',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on Exception catch (e) {
      ElibertyLogger.info('** Elib ** Exception ' + e.toString());

      rethrow;
    } on Error catch (e) {
      ElibertyLogger.info(
          '** Elib ** refreshJWT ' + e.toString() + e.stackTrace.toString());
      rethrow;
    }
  }

  Future<OpenPassResponse> findOpenPass({required String passNumber}) async {
    try {
      var token = await apiHelper.getCachedToken();
      var headers = apiHelper.getHeaders(jwt: token.token);
      Map<String, dynamic> queryParams = {
        'pass_number': passNumber,
      };
      String queryString = Uri(queryParameters: queryParams).query;
      var requestUrl = Routes.API_OPEN_PASS + '?' + queryString;
      final response =
          await client.get(Uri.parse(requestUrl), headers: headers);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final openPassResponse =
            OpenPassResponse.fromJson(jsonDecode(response.body));
        return openPassResponse;
      } else if (response.statusCode == 400) {
        var json = jsonDecode(response.body);
        throw apiHelper.getApiException(
          code: response.statusCode,
          message: json['errors'][0],
          propertyPath: null,
        );
      } else {
        Sentry.configureScope(
          (scope) => {
            scope.setExtra('statusCode', response.statusCode),
            scope.setExtra('response', response.body),
            scope.setExtra('jwt', token.token),
          },
        );

        await Sentry.captureMessage(
          'findOpenPass Error ',
          level: SentryLevel.error,
        );
        throw ApiException(
            errors: ViolationsError.fromJson(jsonDecode(response.body)));
      }
    } on SocketException catch (e, stackTrace) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw apiHelper.getApiException(
            code: 1000,
            message: 'No Internet',
            propertyPath: null,
            exception: e,
            stackTrace: stackTrace);
      }

      throw apiHelper.getApiException(
          code: 1003,
          message: 'Site not available',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on HttpException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** HttpException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1001,
          message: 'No Service Found',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on FormatException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** FormatException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1002,
          message: 'Invalid Response format',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on Exception catch (e) {
      ElibertyLogger.info('** Elib ** Exception ' + e.toString());

      rethrow;
    } on Error catch (e) {
      ElibertyLogger.info(
          '** Elib ** findOpenPass ' + e.toString() + e.stackTrace.toString());
      rethrow;
    }
  }

  Future<User> assignPass(
      {required String passId, required String contactId}) async {
    try {
      var token = await apiHelper.getCachedToken();
      var headers = apiHelper.getHeaders(jwt: token.token);
      final response = await client.post(
          Uri.parse(Routes.API_ASSIGN_PASS +
              contactId +
              Routes.API_ASSIGN_PASS_EXTRA +
              passId),
          headers: headers);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final user = await getUser();
        print("6");
        return user;
      } else {
        Sentry.configureScope(
          (scope) => {
            scope.setExtra('statusCode', response.statusCode),
            scope.setExtra('response', response.body),
            scope.setExtra('jwt', token.token),
          },
        );

        await Sentry.captureMessage(
          'assignPass Error ',
          level: SentryLevel.error,
        );
        throw ApiException(
            errors: ViolationsError.fromJson(jsonDecode(response.body)));
      }
    } on SocketException catch (e, stackTrace) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw apiHelper.getApiException(
            code: 1000,
            message: 'No Internet',
            propertyPath: null,
            exception: e,
            stackTrace: stackTrace);
      }

      throw apiHelper.getApiException(
          code: 1003,
          message: 'Site not available',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on HttpException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** HttpException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1001,
          message: 'No Service Found',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on FormatException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** FormatException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1002,
          message: 'Invalid Response format',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on Exception catch (e) {
      ElibertyLogger.info('** Elib ** Exception ' + e.toString());

      rethrow;
    } on Error catch (e) {
      ElibertyLogger.info(
          '** Elib ** assignPass ' + e.toString() + e.stackTrace.toString());
      rethrow;
    }
  }

  Future<Cart> getFirstSimulation(
      {required User user,
      required Station station,
      required Domain domain,
      required String startDate,
      required List<Contact> selectedContacts,
      required Validity selectedValidity}) async {
    try {
      var token = await apiHelper.getCachedToken();
      var headers = apiHelper.getHeaders(jwt: token.token);
      List<Contact> contacts = [];
      var firstThree = user.contacts.take(3);
      print(firstThree.length);
      for (var n in firstThree) {
        contacts.add(n);
      }
      var queryParams = apiHelper.getParamsFirstSimulation(
          contacts: contacts,
          domain: domain,
          station: station,
          startDate: startDate, selectedValidity: selectedValidity);
      String queryString = Uri(queryParameters: queryParams).query;
      var requestUrl = Routes.API_GET_SIMULATION + '?' + queryString;
      final response =
          await client.get(Uri.parse(requestUrl), headers: headers);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var cart = Cart.fromJsonFirstSimulation(
            json: jsonDecode(response.body),
            user: user,
            domain: domain,
            station: station,
            selectedContacts: selectedContacts,
            selectedValidity: selectedValidity);
        if (user.contacts.length > 3) {
          for (var i = 1; i <= user.contacts.length / 3; i++) {
            contacts.clear();
            var itemsList = user.contacts.skip(i * 3).take(3);
            for (var n in itemsList) {
              contacts.add(n);
            }
            var queryParams = apiHelper.getParamsFirstSimulation(
                contacts: contacts,
                domain: domain,
                station: station,
                startDate: startDate, selectedValidity: selectedValidity);
            String queryString = Uri(queryParameters: queryParams).query;
            var requestUrl = Routes.API_GET_SIMULATION + '?' + queryString;
            final responseExtra =
                await client.get(Uri.parse(requestUrl), headers: headers);
            if (responseExtra.statusCode == 200 ||
                responseExtra.statusCode == 201) {
              cart = Cart.fromJsonFirstSimulationExtra(
                  json: jsonDecode(responseExtra.body), cart: cart);
            }
          }
        }
        return cart;
      } else {
        Sentry.configureScope(
          (scope) => {
            scope.setExtra('statusCode', response.statusCode),
            scope.setExtra('response', response.body),
            scope.setExtra('jwt', token.token),
          },
        );

        await Sentry.captureMessage(
          'getFirstSimulation Error ',
          level: SentryLevel.error,
        );
        throw ApiException(
            errors: ViolationsError.fromJson(jsonDecode(response.body)));
      }
    } on SocketException catch (e, stackTrace) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw apiHelper.getApiException(
            code: 1000,
            message: 'No Internet',
            propertyPath: null,
            exception: e,
            stackTrace: stackTrace);
      }

      throw apiHelper.getApiException(
          code: 1003,
          message: 'Site not available',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on HttpException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** HttpException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1001,
          message: 'No Service Found',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on FormatException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** FormatException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1002,
          message: 'Invalid Response format',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on Exception catch (e) {
      ElibertyLogger.info('** Elib ** Exception ' + e.toString());

      rethrow;
    } on Error catch (e) {
      ElibertyLogger.info('** Elib ** getFirstSimulation ' +
          e.toString() +
          e.stackTrace.toString());
      rethrow;
    }
  }

  Future<Cart> getFirstSimulationWithPossiblePromo(
      {required User user,
      required Station station,
      required Domain domain,
      required String startDate,
      required List<Contact> selectedContacts,
      required Validity selectedValidity}) async {
    try {
      var token = await apiHelper.getCachedToken();
      var headers = apiHelper.getHeaders(jwt: token.token);
      var queryParams = apiHelper.getParamsFirstSimulationWithPossiblePromo(
          user: user,
          domain: domain,
          station: station,
          startDate: startDate,
          selectedContacts: selectedContacts,
          selectedValidity: selectedValidity);
      String queryString = Uri(queryParameters: queryParams).query;
      var requestUrl = Routes.API_GET_SIMULATION + '?' + queryString;
      final response =
          await client.get(Uri.parse(requestUrl), headers: headers);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final cart = Cart.fromJsonFirstSimulationWithPossiblePromo(
            json: jsonDecode(response.body),
            user: user,
            domain: domain,
            station: station,
            selectedContacts: selectedContacts,
            selectedValidity: selectedValidity);
        return cart;
      } else {
        Sentry.configureScope(
          (scope) => {
            scope.setExtra('statusCode', response.statusCode),
            scope.setExtra('response', response.body),
            scope.setExtra('jwt', token.token),
          },
        );

        await Sentry.captureMessage(
          'getFirstSimulation Error ',
          level: SentryLevel.error,
        );
        throw ApiException(
            errors: ViolationsError.fromJson(jsonDecode(response.body)));
      }
    } on SocketException catch (e, stackTrace) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw apiHelper.getApiException(
            code: 1000,
            message: 'No Internet',
            propertyPath: null,
            exception: e,
            stackTrace: stackTrace);
      }

      throw apiHelper.getApiException(
          code: 1003,
          message: 'Site not available',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on HttpException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** HttpException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1001,
          message: 'No Service Found',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on FormatException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** FormatException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1002,
          message: 'Invalid Response format',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on Exception catch (e) {
      ElibertyLogger.info('** Elib ** Exception ' + e.toString());

      rethrow;
    } on Error catch (e) {
      ElibertyLogger.info('** Elib ** getFirstSimulation ' +
          e.toString() +
          e.stackTrace.toString());
      rethrow;
    }
  }

  // Future<FastCart> getFirstSimulationFastCart(
  //     {required User user,
  //     required Station station,
  //     required Domain domain,
  //     required String startDate}) async {
  //   try {
  //     var token = await apiHelper.getCachedToken();
  //     var headers = apiHelper.getHeaders(jwt: token.token);
  //     var queryParams = apiHelper.getParamsFirstSimulationFastCart(
  //         user: user, domain: domain, station: station, startDate: startDate);
  //     String queryString = Uri(queryParameters: queryParams).query;
  //     var requestUrl = Routes.API_GET_SIMULATION + '?' + queryString;
  //     final response =
  //         await client.get(Uri.parse(requestUrl), headers: headers);
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       final cart = FastCart.fromJsonFirstSimulation(
  //           json: jsonDecode(response.body),
  //           user: user,
  //           domain: domain,
  //           station: station);
  //       return cart;
  //     } else {
  //       Sentry.configureScope(
  //         (scope) => {
  //           scope.setExtra('statusCode', response.statusCode),
  //           scope.setExtra('response', response.body),
  //           scope.setExtra('jwt', token.token),
  //         },
  //       );

  //       await Sentry.captureMessage(
  //         'getFirstSimulation Error ',
  //         level: SentryLevel.error,
  //       );
  //       throw ApiException(
  //           errors: ViolationsError.fromJson(jsonDecode(response.body)));
  //     }
  //   } on SocketException catch (e, stackTrace) {
  //     var connectivityResult = await (Connectivity().checkConnectivity());
  //     if (connectivityResult == ConnectivityResult.none) {
  //       throw apiHelper.getApiException(
  //           code: 1000,
  //           message: 'No Internet',
  //           propertyPath: null,
  //           exception: e,
  //           stackTrace: stackTrace);
  //     }

  //     throw apiHelper.getApiException(
  //         code: 1003,
  //         message: 'Site not available',
  //         propertyPath: null,
  //         exception: e,
  //         stackTrace: stackTrace);
  //   } on HttpException catch (e, stackTrace) {
  //     ElibertyLogger.info('** Elib ** HttpException ' + e.toString());

  //     throw apiHelper.getApiException(
  //         code: 1001,
  //         message: 'No Service Found',
  //         propertyPath: null,
  //         exception: e,
  //         stackTrace: stackTrace);
  //   } on FormatException catch (e, stackTrace) {
  //     ElibertyLogger.info('** Elib ** FormatException ' + e.toString());

  //     throw apiHelper.getApiException(
  //         code: 1002,
  //         message: 'Invalid Response format',
  //         propertyPath: null,
  //         exception: e,
  //         stackTrace: stackTrace);
  //   } on Exception catch (e) {
  //     ElibertyLogger.info('** Elib ** Exception ' + e.toString());

  //     rethrow;
  //   } on Error catch (e) {
  //     ElibertyLogger.info('** Elib ** getFirstSimulation ' +
  //         e.toString() +
  //         e.stackTrace.toString());
  //     rethrow;
  //   }
  // }

  Future<Order> saveSimulationToOrder({required Cart cart}) async {
    try {
      var token = await apiHelper.getCachedToken();
      var headers = apiHelper.getHeaders(jwt: token.token);
      var queryParams = apiHelper.getParamsOrder(cart: cart);
      String queryString = Uri(queryParameters: queryParams).query;
      var requestUrl = Routes.API_ORDER_SAVE + '?' + queryString;
      final response =
          await client.post(Uri.parse(requestUrl), headers: headers);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Order.fromJson(json: jsonDecode(response.body));
      } else {
        Sentry.configureScope(
          (scope) => {
            scope.setExtra('statusCode', response.statusCode),
            scope.setExtra('response', response.body),
            scope.setExtra('jwt', token.token),
          },
        );

        await Sentry.captureMessage(
          'saveSimulationToOrder Error ',
          level: SentryLevel.error,
        );
        throw ApiException(
            errors: ViolationsError.fromJson(jsonDecode(response.body)));
      }
    } on SocketException catch (e, stackTrace) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw apiHelper.getApiException(
            code: 1000,
            message: 'No Internet',
            propertyPath: null,
            exception: e,
            stackTrace: stackTrace);
      }

      throw apiHelper.getApiException(
          code: 1003,
          message: 'Site not available',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on HttpException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** HttpException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1001,
          message: 'No Service Found',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on FormatException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** FormatException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1002,
          message: 'Invalid Response format',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on Exception catch (e) {
      ElibertyLogger.info('** Elib ** Exception ' + e.toString());

      rethrow;
    } on Error catch (e) {
      ElibertyLogger.info('** Elib ** saveSimulationToOrder ' +
          e.toString() +
          e.stackTrace.toString());
      rethrow;
    }
  }

  Future<void> updateCacheNotifications(
      {required List<PushNotification> notifications}) async {
    await apiHelper.updateCacheNotifications(notifications: notifications);
  }

  Future<List<PushNotification>> initNotificationsFromCache() async {
    List<PushNotification> result = [];
    var notificationsString = await apiHelper.getCachedNotifications();
    if (notificationsString == '') return result;
    var notifications =
        jsonDecode(notificationsString)['notifications'] as List<dynamic>;
    notifications.forEach((element) {
      result.add(PushNotification.fromMap(element));
    });
    return result;
  }

  Future<void> updateFavoriteStation({required int contractorId}) async {
    await apiHelper.updateFavoriteStation(contractorId: contractorId);
  }

  Future<int> initFavoriteStationFromCache() async {
    var contractorId = await apiHelper.getCachedFavoriteStation();
    return contractorId;
  }

  Future<OrderHistory> initOrdersHistory() async {
    try {
      var token = await apiHelper.getCachedToken(init: true);
      var headers = apiHelper.getHeaders(jwt: token.token);

      final response = await client
          .get(Uri.parse(Routes.API_GET_ORDERS_HISTORY), headers: headers);

      if (response.statusCode == 200) {
        var jsonResult = jsonDecode(response.body);

        return OrderHistory.fromJson(json: jsonResult);
      } else if (response.statusCode == 500) {
        return OrderHistory(
            orders: [], listOrdersToCome: [], listOrdersPassed: []);
      } else {
        Sentry.configureScope(
          (scope) => {
            scope.setExtra('statusCode', response.statusCode),
            scope.setExtra('response', response.body),
            scope.setExtra('jwt', token.token),
          },
        );

        await Sentry.captureMessage(
          'initOrdersHistory Error ',
          level: SentryLevel.error,
        );
        throw ApiException(
            errors: ViolationsError.fromJson(jsonDecode(response.body)));
      }
    } on SocketException catch (e, stackTrace) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw apiHelper.getApiException(
            code: 1000,
            message: 'No Internet',
            propertyPath: null,
            exception: e,
            stackTrace: stackTrace);
      }

      throw apiHelper.getApiException(
          code: 1003,
          message: 'Site not available',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on HttpException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** HttpException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1001,
          message: 'No Service Found',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on FormatException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** FormatException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1002,
          message: 'Invalid Response format',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on Exception catch (e) {
      ElibertyLogger.info('** Elib ** Exception ' + e.toString());

      rethrow;
    } on Error catch (e) {
      ElibertyLogger.info('** Elib ** initOrdersHistory ' +
          e.toString() +
          e.stackTrace.toString());
      rethrow;
    }
  }

  Future<Config> initConfig() async {
    try {
      var token = await apiHelper.getCachedToken(init: true);
      var headers = apiHelper.getHeaders(jwt: token.token);

      final response =
          await client.get(Uri.parse(Routes.API_CONFIG), headers: headers);

      if (response.statusCode == 200) {
        var jsonResult = jsonDecode(response.body);

        return Config.fromJson(json: jsonResult);
      } else {
        Sentry.configureScope(
          (scope) => {
            scope.setExtra('statusCode', response.statusCode),
            scope.setExtra('response', response.body),
            scope.setExtra('jwt', token.token),
          },
        );

        await Sentry.captureMessage(
          'initConfig Error ',
          level: SentryLevel.error,
        );
        throw ApiException(
            errors: ViolationsError.fromJson(jsonDecode(response.body)));
      }
    } on SocketException catch (e, stackTrace) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw apiHelper.getApiException(
            code: 1000,
            message: 'No Internet',
            propertyPath: null,
            exception: e,
            stackTrace: stackTrace);
      }

      throw apiHelper.getApiException(
          code: 1003,
          message: 'Site not available',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on HttpException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** HttpException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1001,
          message: 'No Service Found',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on FormatException catch (e, stackTrace) {
      ElibertyLogger.info('** Elib ** FormatException ' + e.toString());

      throw apiHelper.getApiException(
          code: 1002,
          message: 'Invalid Response format',
          propertyPath: null,
          exception: e,
          stackTrace: stackTrace);
    } on Exception catch (e) {
      ElibertyLogger.info('** Elib ** Exception ' + e.toString());

      rethrow;
    } on Error catch (e) {
      ElibertyLogger.info(
          '** Elib ** initConfig ' + e.toString() + e.stackTrace.toString());
      rethrow;
    }
  }
}
