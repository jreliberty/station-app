import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../entities/api_exception.dart';
import '../../entities/cart.dart';
import '../../entities/order/order.dart';
import '../../entities/violation_error.dart';
import '../../repository/api_repository.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final ApiRepository apiRepository;
  OrderBloc({required this.apiRepository}) : super(OrderInitial());

  Stream<OrderState> mapEventToState(OrderEvent event) async* {
    if (event is SaveSimulationToOrder) {
      yield OrderLoadInProgress();
       try {
        var order = await apiRepository.saveSimulationToOrder(cart: event.cart);
      yield OrderLoadSuccess(order: order);} on ApiException catch (ex) {
        print('ApiException : ' + ex.errors.toString());
        yield OrderLoadFailure(violationError: ex.errors!.list!.first);
      } catch (error) {
        print('error : ' + error.toString());
        yield OrderLoadFailure(
            violationError:
                ViolationError(code: 1001, message: '', propertyPath: ''));
      }
    }
  }
}
