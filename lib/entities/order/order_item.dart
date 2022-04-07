import 'package:equatable/equatable.dart';

import 'adjustment.dart';
import 'variant.dart';

class OrderItem extends Equatable {
  final int id;
  final int unitPrice;
  final int maxPublicPrice;
  final int total;
  final int skierId;
  final int skierIndex;
  final String cardNumber;
  final DateTime startDate;
  final bool visible;
  final bool locked;
  final Variant variant;
  final List<OrderItem> orderItemChildren;
  final List<Adjustment> adjustments;

  OrderItem(
      {required this.id,
      required this.variant,
      required this.unitPrice,
      required this.maxPublicPrice,
      required this.total,
      required this.skierId,
      required this.skierIndex,
      required this.cardNumber,
      required this.startDate,
      required this.visible,
      required this.locked,
      required this.orderItemChildren,
      required this.adjustments});

  @override
  List<Object?> get props => [id];

  factory OrderItem.fromJson({required Map<String, dynamic> json}) {
    var id = json['id'] ?? 0;
    var unitPrice = json['unit_price'] ?? 0;
    var maxPublicPrice = json['max_public_price'] ?? 0;
    var total = json['total'] ?? 0;
    var skierId = json['skier'] ?? 0;
    var skierIndex = json['skier_index'] ?? 0;
    var cardNumber = json['card_number'] ?? '';
    var startDate = DateTime(
      int.parse(json['start_date'].substring(0, 4)),
      int.parse(json['start_date'].substring(5, 7)),
      int.parse(json['start_date'].substring(8, 10)),
    );
    var visible = json['visible'] ?? true;
    var locked = json['locked'] ?? false;
    List<OrderItem> orderItemChildren = [];
    var items = json['orderitemchildren'] as List<dynamic>;
    if (items.isNotEmpty) {
      items.forEach((element) {
        orderItemChildren.add(OrderItem.fromJson(json: element));
      });
    }
    var variant = Variant.fromJson(json: json['variant']);
    List<Adjustment> adjustments = [];
    if(json['adjustments'] != null)
    {var itemsAdjustments = json['adjustments'] as List<dynamic>;
    if (itemsAdjustments.isNotEmpty) {
      itemsAdjustments.forEach((element) {
        adjustments.add(Adjustment.fromJson(json: element));
      });
    }}
    print(adjustments);

    return OrderItem(
        id: id,
        unitPrice: unitPrice,
        maxPublicPrice: maxPublicPrice,
        total: total,
        skierId: skierId,
        skierIndex: skierIndex,
        cardNumber: cardNumber,
        startDate: startDate,
        visible: visible,
        locked: locked,
        variant: variant,
        orderItemChildren: orderItemChildren,
        adjustments: adjustments);
  }
}
