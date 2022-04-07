import 'package:equatable/equatable.dart';

class Config extends Equatable {
  final bool activeSales;
  final String appEnv;
  final String dalenysApiKey;
  final String dalenysApiKeyId;
  final String mercureJwtSecret;
  final String priceOrder;

  final DateTime updatedAt;

  Config({
    required this.activeSales,
    required this.priceOrder,
    required this.updatedAt,
    required this.appEnv,
    required this.dalenysApiKey,
    required this.dalenysApiKeyId,
    required this.mercureJwtSecret,
  });

  @override
  List<Object?> get props => [activeSales, priceOrder, updatedAt];

  factory Config.fromJson({required Map<String, dynamic> json}) {
    var configuration = json['configuration'] as Map<String, dynamic>;
    var updatedAt = DateTime(
      int.parse(json['updated_at'].substring(0, 4)),
      int.parse(json['updated_at'].substring(8, 10)),
      int.parse(json['updated_at'].substring(5, 7)),
    );
    return Config(
      activeSales: configuration['active_sales'],
      priceOrder: configuration['price_order'],
      updatedAt: updatedAt,
      appEnv: configuration['app_env'],
      dalenysApiKey: configuration['dalenys_api_key'],
      dalenysApiKeyId: configuration['dalenys_api_key_id'],
      mercureJwtSecret: configuration['mercure_jwt_secret'],
    );
  }
}
