class Payment {
  final int id;
  final String? state;
  final int? amount;
  final String? currency;
  final String? authorizationId;
  final String? transactionId;
  final String? cashdeskReference;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Payment({
    required this.id,
    required this.state,
    required this.amount,
    required this.currency,
    required this.authorizationId,
    required this.transactionId,
    required this.cashdeskReference,
    required this.completedAt,
    required this.cancelledAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    DateTime? createdAt;
    if (json['created_at'] != null)
      createdAt = DateTime(
        int.parse(json['created_at'].substring(0, 4)),
        int.parse(json['created_at'].substring(5, 7)),
        int.parse(json['created_at'].substring(8, 10)),
      );

    DateTime? completedAt;
    if (json['completed_at'] != null)
      completedAt = DateTime(
        int.parse(json['completed_at'].substring(0, 4)),
        int.parse(json['completed_at'].substring(5, 7)),
        int.parse(json['completed_at'].substring(8, 10)),
      );
    DateTime? cancelledAt;
    if (json['cancelled_at'] != null)
      cancelledAt = DateTime(
        int.parse(json['cancelled_at'].substring(0, 4)),
        int.parse(json['cancelled_at'].substring(5, 7)),
        int.parse(json['cancelled_at'].substring(8, 10)),
      );
    DateTime? updatedAt;
    if (json['updated_at'] != null)
      updatedAt = DateTime(
        int.parse(json['updated_at'].substring(0, 4)),
        int.parse(json['updated_at'].substring(5, 7)),
        int.parse(json['updated_at'].substring(8, 10)),
      );
    return Payment(
        id: json['id'] ?? 0,
        state: json['state'],
        amount: json['amount'],
        currency: json['currency'],
        authorizationId: json['authorization_id'],
        transactionId: json['transaction_id'],
        cashdeskReference: json['cashdesk_reference'],
        completedAt: completedAt,
        cancelledAt: cancelledAt,
        createdAt: createdAt,
        updatedAt: updatedAt);
  }
}
