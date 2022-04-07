class MyConfig {
  static const PRODUCTION_ON = true;
  static const DOMAIN = "sodapp.ninja";
  // static const DOMAIN = "decathlonpass.com";
  static const HOST = PRODUCTION_ON
      ? 'user.' + DOMAIN
      : 'user.preproduction.' + DOMAIN; // Preproduction
  static const HOST_MIDDLEWARE = PRODUCTION_ON
      ? 'middleware.' + DOMAIN
      : 'middleware.preproduction.' + DOMAIN; // Preproduction
  static const BASE_URL = 'https://' + HOST;
  static const BASE_URL_MIDDLEWARE = 'https://' + HOST_MIDDLEWARE;
  static const BASE_URL_MEDIA = 'https://static.decathlonpass.com/';

  static const TOKEN_MERCURE = PRODUCTION_ON
      ? 'NyY54UCoCyAh17MH4uc8OIpkGlY99nWkfHdj4pMYVjErqaVEtPZkKiSeJHtS8hga'
      : 'NyY54UCoCyAh17MH4uc8OIpkGlY99nWkfHdj4pMYVjErqaVEtPZkKiSeJHtS8hga';
  static const HUB_URL = PRODUCTION_ON
      ? 'https://mercure.preproduction.decathlonpass.com/.well-known/mercure'
      : 'https://mercure.preproduction.decathlonpass.com/.well-known/mercure';
  static const TOPIC_CONTACT = 'https://sodapp.ninja/contacts/';
  static const TOPIC_USER = 'https://sodapp.ninja/users/';
  static const TOPIC_ORDER = 'https://sodapp.ninja/orders/';

  static const SENTRY_DSN =
      'https://785fa373863b4e2f84c7d5ded9b3645a@o58489.ingest.sentry.io/6103005';

  static const PAYMENT_FORM_URL = BASE_URL_MIDDLEWARE + "/payment/form";
}
