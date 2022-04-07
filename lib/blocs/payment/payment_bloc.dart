import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:corsac_jwt/corsac_jwt.dart';
import 'package:equatable/equatable.dart';
import 'package:mercure_client/mercure_client.dart';

import '../../constants/config.dart';
import '../../entities/api_exception.dart';
import '../../entities/payment/card_payment.dart';
import '../../entities/payment/payment_response.dart';
import '../../entities/violation_error.dart';
import '../../repository/api_repository.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final ApiRepository apiRepository;
  PaymentBloc({required this.apiRepository}) : super(PaymentInitial());

  late StreamSubscription _subscription;

  @override
  Stream<PaymentState> mapEventToState(PaymentEvent event) async* {
    if (event is CreatePaymentEvent) {
      yield PaymentLoadInProgress();
      try {
        var builder = JWTBuilder();
        var signer = JWTHmacSha256Signer(MyConfig.TOKEN_MERCURE);
        var signedToken = builder.getSignedToken(signer);

        final mercure = Mercure(
          url: MyConfig.HUB_URL, // your mercure hub url
          topics: [
            MyConfig.TOPIC_ORDER + event.cardPayment.orderToken,
          ], // your mercure topic
          token: signedToken.toString(), // Bearer authorization
        );
        _subscription = mercure.listen((eventOrder) async* {
          _subscription.cancel();
          print(eventOrder.data);
          print('event');
        });
        var paymentResponse =
            await apiRepository.createPayment(cardPayment: event.cardPayment);
        yield PaymentLoadSuccess(paymentResponse: paymentResponse);
      } on ApiException catch (ex) {
        print(ex.errors);
        yield PaymentLoadFailure(violationError: ex.errors!.list!.first);
      } catch (error) {
        print(error);
        yield PaymentLoadFailure(
            violationError:
                ViolationError(code: 1001, message: '', propertyPath: ''));
      }
    }
  }
}
