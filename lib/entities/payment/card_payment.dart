import 'package:equatable/equatable.dart';

class CardPayment extends Equatable {
  final String cardCode;
  final String cardValidityDate;
  final String cardType;
  final String selectedBrand;
  final String cardFullname;
  final String cardToken;
  final String orderToken;
  final int orderId;

  CardPayment({
    required this.cardCode,
    required this.cardValidityDate,
    required this.cardType,
    required this.selectedBrand,
    required this.cardFullname,
    required this.cardToken,
    required this.orderToken,
    required this.orderId,
  });

  @override
  List<Object?> get props => [
        cardCode,
        cardValidityDate,
        cardType,
        selectedBrand,
        cardToken,
        cardFullname,
        orderToken
      ];

  factory CardPayment.fromString(
      {required String data,
      required String orderToken,
      required int orderId}) {
    var infos = data.split(',');

    return CardPayment(
      cardCode: infos[0],
      cardValidityDate: infos[1],
      cardType: infos[2],
      selectedBrand: infos[3],
      cardFullname: infos[4],
      cardToken: infos[5],
      orderToken: orderToken,
      orderId: orderId,
    );
  }
}
