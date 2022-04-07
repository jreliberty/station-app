import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../entities/api_exception.dart';
import '../../entities/order/order.dart';
import '../../entities/orders_history.dart';
import '../../entities/violation_error.dart';
import '../../repository/api_repository.dart';

part 'orders_history_event.dart';
part 'orders_history_state.dart';

class OrdersHistoryBloc extends Bloc<OrdersHistoryEvent, OrdersHistoryState> {
  final ApiRepository apiRepository;
  OrdersHistoryBloc({required this.apiRepository})
      : super(OrdersHistoryInitial());
  @override
  Stream<OrdersHistoryState> mapEventToState(OrdersHistoryEvent event) async* {
    if (event is InitOrdersHistoryEvent) {
      yield OrdersHistoryLoadInProgress();
      try {
        var orderHistory = await apiRepository.initOrdersHistory();
        yield OrdersHistoryLoadSuccess(orderHistory: orderHistory);
      } on ApiException catch (ex) {
        print('ApiException : ' + ex.errors.toString());
        yield OrdersHistoryLoadFailure(violationError: ex.errors!.list!.first);
      } catch (error) {
        print('error : ' + error.toString());
        yield OrdersHistoryLoadFailure(
            violationError:
                ViolationError(code: 1001, message: '', propertyPath: ''));
      }
    } else if (event is UpdateOrdersHistoryEvent) {
      yield OrdersHistoryLoadInProgress();
      var orderHistory = event.orderHistory;
      orderHistory.orders.add(event.order);
      orderHistory.listOrdersToCome.add(event.order);
      orderHistory.orders.sort((a, b) => b.skiDate.compareTo(a.skiDate));
      orderHistory.listOrdersPassed.sort((a, b) => b.skiDate.compareTo(a.skiDate));
      orderHistory.listOrdersToCome.sort((a, b) => b.skiDate.compareTo(a.skiDate));
      yield OrdersHistoryLoadSuccess(orderHistory: orderHistory);
    }
  }
}
