import 'package:dio/dio.dart';

import '../entities/advantage.dart';
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
import 'api_client.dart';

class ApiRepository {
  final ApiClient apiClient;

  ApiRepository({required this.apiClient});

  Future<void> clearCookies() async {
    await apiClient.clearCookies();
  }

  Future<PaymentResponse> createPayment(
      {required CardPayment cardPayment}) async {
    return apiClient.createPayment(cardPayment: cardPayment);
  }

  Future<List<Station>> getSkiResortsList() async {
    return apiClient.getSkiResortsList();
  }

  Future<List<Station>> getSkiResortsListWithDate(
      {required DateTime date}) async {
    return apiClient.getSkiResortsListWithDate(date: date);
  }

  Future<List<Offer>> getListOffers() async {
    return apiClient.getListOffers();
  }

  Future<List<Advantage>> getListAdvantages() async {
    return apiClient.getListAdvantages();
  }

  Future<User> getUser() async {
    return apiClient.getUser();
  }

  Future<User> createContact({
    required String body,
    required String bodyPhone,
    required String userId,
  }) async {
    return apiClient.createContact(
      body: body,
      bodyPhone: bodyPhone,
      userId: userId,
    );
  }

  Future<User> updateContactPersonalInfo(
      {required String body, required String contactId}) async {
    return apiClient.updateContactPersonalInfo(
      body: body,
      contactId: contactId,
    );
  }

  Future<User> createContactAdress({
    required String body,
  }) async {
    return apiClient.createContactAdress(
      body: body,
    );
  }

  Future<User> updateContactAdress({
    required String body,
    required String adressId,
  }) async {
    return apiClient.updateContactAdress(
      body: body,
      adressId: adressId,
    );
  }

  Future<User> deleteContactAdress({
    required String adressId,
  }) async {
    return apiClient.deleteContactAdress(
      adressId: adressId,
    );
  }

  Future<OpenPassResponse> findOpenPass({required String passNumber}) {
    return apiClient.findOpenPass(passNumber: passNumber);
  }

  Future<User> assignPass({required String passId, required String contactId}) {
    return apiClient.assignPass(contactId: contactId, passId: passId);
  }

  Future<Response> getUrlOneId() {
    return apiClient.getUrlOneId();
  }

  Future<Token> getJwt(Uri url) {
    return apiClient.getJwt(url);
  }

  Future<Token> refreshJwt() {
    return apiClient.refreshJwt();
  }

  Future<Cart> getFirstSimulation(
      {required User user,
      required Station station,
      required Domain domain,
      required String startDate,
      required List<Contact> selectedContacts,
      required Validity selectedValidity}) {
    return apiClient.getFirstSimulation(
        user: user,
        station: station,
        domain: domain,
        startDate: startDate,
        selectedContacts: selectedContacts,
        selectedValidity: selectedValidity);
  }

  Future<Cart> getFirstSimulationWithPossiblePromo(
      {required User user,
      required Station station,
      required Domain domain,
      required String startDate,
      required List<Contact> selectedContacts,
      required Validity selectedValidity}) {
    return apiClient.getFirstSimulationWithPossiblePromo(
        user: user,
        station: station,
        domain: domain,
        startDate: startDate,
        selectedContacts: selectedContacts,
        selectedValidity: selectedValidity);
  }

  // Future<FastCart> getFirstSimulationFastCart(
  //     {required User user,
  //     required Station station,
  //     required Domain domain,
  //     required String startDate}) {
  //   return apiClient.getFirstSimulationFastCart(
  //       user: user, station: station, domain: domain, startDate: startDate);
  // }

  Future<Order> saveSimulationToOrder({required Cart cart}) {
    return apiClient.saveSimulationToOrder(cart: cart);
  }

  Future<String> createSubcontact({required String body}) {
    return apiClient.createSubcontact(body: body);
  }

  Future<void> updateCacheNotifications(
      {required List<PushNotification> notifications}) async {
    await apiClient.updateCacheNotifications(notifications: notifications);
  }

  Future<List<PushNotification>> initNotificationsFromCache() {
    return apiClient.initNotificationsFromCache();
  }

  Future<void> updateFavoriteStation({required int contractorId}) async {
    await apiClient.updateFavoriteStation(contractorId: contractorId);
  }

  Future<int> initFavoriteStationFromCache() {
    return apiClient.initFavoriteStationFromCache();
  }

  Future<OrderHistory> initOrdersHistory() {
    return apiClient.initOrdersHistory();
  }

  Future<Config> initConfig() {
    return apiClient.initConfig();
  }
}
