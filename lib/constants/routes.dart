import 'config.dart';

class Routes {
  static const API_ME = MyConfig.BASE_URL + '/api/me';
  static const API_CONFIG =
      MyConfig.BASE_URL_MIDDLEWARE + '/api/app_config/latest';
  static const CREATE_PAYMENT =
      MyConfig.BASE_URL_MIDDLEWARE + '/api/payment/process';
  static const PREPARE_PAYMENT =
      MyConfig.BASE_URL_MIDDLEWARE + '/api/payment/prepare';
  static const SKI_RESORTS_LIST_DATA =
      MyConfig.BASE_URL_MIDDLEWARE + '/api/all_ski_resorts';
  static const OFFERS_LIST_DATA_ASC =
      MyConfig.BASE_URL_MIDDLEWARE + '/api/offers?active=1&order[rank]=asc';
  static const OFFERS_LIST_DATA_DESC =
      MyConfig.BASE_URL_MIDDLEWARE + '/api/offers?active=1&order[rank]=desc';
  static const ADVANTAGES_LIST_DATA_ASC =
      MyConfig.BASE_URL_MIDDLEWARE + '/api/advantages?active=1&order[rank]=asc';
  static const ADVANTAGES_LIST_DATA_DESC = MyConfig.BASE_URL_MIDDLEWARE +
      '/api/advantages?active=1&order[rank]=desc';
  static const GET_CONTACTS = '/subcontacts';
  static const API_MAIN_CONTACT_CREATE = MyConfig.BASE_URL + '/api/users/';
  static const API_CONTACT = MyConfig.BASE_URL + '/api/contacts/';
  static const API_CREATE_CONTACT = MyConfig.BASE_URL + '/api/contacts';
  static const API_CREATE_ADRESS = MyConfig.BASE_URL + '/api/addresses';
  static const API_UPDATE_ADRESS = MyConfig.BASE_URL + '/api/addresses/';
  static const API_DELETE_ADRESS = MyConfig.BASE_URL + '/api/addresses/';
  static const API_OPEN_PASS = MyConfig.BASE_URL + '/api/open_pass';
  static const API_ASSIGN_PASS = MyConfig.BASE_URL + '/api/contacts/';
  static const API_ASSIGN_PASS_EXTRA = '/setpass/';
  static const API_GET_SIMULATION =
      MyConfig.BASE_URL_MIDDLEWARE + '/api/order_simulation';
  static const API_ORDER_SAVE =
      MyConfig.BASE_URL_MIDDLEWARE + '/api/order_save';
  static const API_CREATE_PAYMENT =
      MyConfig.BASE_URL_MIDDLEWARE + '/api/payment/process';
  static const API_GET_ORDERS_HISTORY =
      MyConfig.BASE_URL_MIDDLEWARE + '/api/orders';
  static const API_IDENTIFICATION = MyConfig.BASE_URL + '/identification';
  static const API_IDENTIFICATION_TO_CONTAIN =
      MyConfig.HOST + '/identification';
  static const API_AUTH_URL = MyConfig.BASE_URL + '/api/auth-from-code';
  static const API_REDIRECT =
      MyConfig.BASE_URL + '/auth_url?redirect_uri=' + API_IDENTIFICATION;
  static const API_REFRESH_TOKEN = MyConfig.BASE_URL + "/api/token/refresh";
}
