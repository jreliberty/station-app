import 'package:equatable/equatable.dart';

import 'order_item.dart';
import 'payment.dart';
import 'promotion.dart';

class Order extends Equatable {
  final int id;
  final int contactId;
  final Payment payment;
  final String token;
  final String voucherNumber;
  final String state;
  final bool confirmed;
  final int total;
  final int itemsTotal;
  final int adjustmentsTotal;
  final int publicTotal;
  final String currency;
  final DateTime createdAt;
  final DateTime skiDate;
  final List<OrderItem> orderItems;
  final int contractorId;
  final List<Promotion> promotions;

  Order({
    required this.id,
    required this.contactId,
    required this.payment,
    required this.token,
    required this.voucherNumber,
    required this.state,
    required this.confirmed,
    required this.total,
    required this.itemsTotal,
    required this.adjustmentsTotal,
    required this.publicTotal,
    required this.currency,
    required this.createdAt,
    required this.skiDate,
    required this.orderItems,
    required this.contractorId,
    required this.promotions,
  });

  @override
  List<Object?> get props => [id, skiDate, promotions];

  factory Order.fromJson({required Map<String, dynamic> json}) {
    var id = json["id"] ?? 0;
    var contactId = json["contact"] ?? 0;
    var contractorId = json["contractor"] ?? 0;
    var payment = Payment.fromJson(json["payment"]);
    var token = json["token"] ?? '';
    var voucherNumber = json["voucher_number"] ?? '';
    var state = json["state"] ?? '';
    var confirmed = json["idconfirmed"] ?? false;
    var total = json["total"] ?? 0;
    var itemsTotal = json["items_total"] ?? 0;
    var adjustmentsTotal = json["adjustments_total"] ?? 0;
    var publicTotal = json["public_total"] ?? 0;
    var currency = json["currency"] ?? '';
    var createdAt = DateTime(
      int.parse(json['created_at'].substring(0, 4)),
      int.parse(json['created_at'].substring(5, 7)),
      int.parse(json['created_at'].substring(8, 10)),
    );

    List<OrderItem> orderItems = [];
    var items = json["orderitems"] as List<dynamic>;
    if (items.isNotEmpty) {
      items.forEach((element) {
        orderItems.add(OrderItem.fromJson(json: element));
      });
    }
    List<Promotion> promotions = [];
    var promotionItems = json["promotions"] as List<dynamic>;
    if (promotionItems.isNotEmpty) {
      promotionItems.forEach((element) {
        promotions.add(Promotion.fromJson(json: element));
      });
    }
    DateTime skiDate = orderItems[0].startDate;

    return Order(
      id: id,
      contactId: contactId,
      contractorId: contractorId,
      payment: payment,
      token: token,
      voucherNumber: voucherNumber,
      state: state,
      confirmed: confirmed,
      total: total,
      itemsTotal: itemsTotal,
      adjustmentsTotal: adjustmentsTotal,
      publicTotal: publicTotal,
      currency: currency,
      createdAt: createdAt,
      skiDate: skiDate,
      orderItems: orderItems,
      promotions: promotions,
    );
  }
}
