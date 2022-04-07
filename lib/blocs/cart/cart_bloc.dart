import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../entities/api_exception.dart';
import '../../entities/cart.dart';
import '../../entities/contact.dart';
import '../../entities/domain.dart';
import '../../entities/station.dart';
import '../../entities/user.dart';
import '../../entities/violation_error.dart';
import '../../repository/api_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final ApiRepository apiRepository;
  CartBloc({required this.apiRepository}) : super(CartInitial());

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if (event is GetFirstSimulationEvent) {
      yield CartLoadInProgress();
      try {
        var cart = await apiRepository.getFirstSimulation(
            user: event.user,
            station: event.station,
            domain: event.domain,
            startDate: event.startDate,
            selectedContacts: event.selectedContacts);
        List<Contact> selectedContacts = [];
        if (event.selectedContacts.isNotEmpty)
          event.selectedContacts.forEach((element) {
            selectedContacts.add(cart.contacts
                .where((elementContacts) => element.id == elementContacts.id)
                .first);
          });
        cart.setSelectedContacts(event.selectedContacts);
        yield CartLoadSuccess(cart: cart);
      } on ApiException catch (ex) {
        yield CartLoadFailure(violationError: ex.errors!.list!.first);
      } catch (error) {
        yield CartLoadFailure(
            violationError:
                ViolationError(code: 1001, message: '', propertyPath: ''));
      }
    }
    if (event is GetFirstSimulationEventWithPossiblePromoEvent) {
      yield CartLoadInProgress();
      try {
        var cart = await apiRepository.getFirstSimulationWithPossiblePromo(
            user: event.user,
            station: event.station,
            domain: event.domain,
            startDate: event.startDate,
            selectedContacts: event.selectedContacts);
            List<Contact> selectedContacts = [];
        if (event.selectedContacts.isNotEmpty)
          event.selectedContacts.forEach((element) {
            selectedContacts.add(cart.contacts
                .where((elementContacts) => element.id == elementContacts.id)
                .first);
          });
        cart.setSelectedContacts(event.selectedContacts);
        yield CartLoadSuccess(cart: cart);
      } on ApiException catch (ex) {
        yield CartLoadFailure(violationError: ex.errors!.list!.first);
      } catch (error) {
        yield CartLoadFailure(
            violationError:
                ViolationError(code: 1001, message: '', propertyPath: ''));
      }
    }

    if (event is SetCartEvent) {
      yield CartLoadInProgress();
      yield CartLoadSuccess(cart: event.cart);
    }
  }
}
