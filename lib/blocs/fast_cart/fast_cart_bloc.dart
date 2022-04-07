import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:station/entities/validity.dart';

import '../../entities/api_exception.dart';
import '../../entities/cart.dart';
import '../../entities/contact.dart';
import '../../entities/domain.dart';
import '../../entities/station.dart';
import '../../entities/user.dart';
import '../../entities/violation_error.dart';
import '../../repository/api_repository.dart';

part 'fast_cart_event.dart';
part 'fast_cart_state.dart';

class FastCartBloc extends Bloc<FastCartEvent, FastCartState> {
  final ApiRepository apiRepository;
  FastCartBloc({required this.apiRepository}) : super(FastCartInitial());

  @override
  Stream<FastCartState> mapEventToState(FastCartEvent event) async* {
    if (event is GetFirstSimulationFastCartEvent) {
      yield FastCartLoadInProgress();
      try {
        var cart = await apiRepository.getFirstSimulation(
            user: event.user,
            station: event.station,
            domain: event.domain,
            startDate: event.startDate,
            selectedContacts: event.selectedContacts, selectedValidity: event.selectedValidity);
        List<Contact> selectedContacts = [];
        if (event.selectedContacts.isNotEmpty)
          event.selectedContacts.forEach((element) {
            selectedContacts.add(cart.contacts
                .where((elementContacts) => element.id == elementContacts.id)
                .first);
          });
        cart.setSelectedContacts(event.selectedContacts);
        yield FastCartLoadSuccess(cart: cart);
      } on ApiException catch (ex) {
        yield FastCartLoadFailure(violationError: ex.errors!.list!.first);
      } catch (error) {
        yield FastCartLoadFailure(
            violationError:
                ViolationError(code: 1001, message: '', propertyPath: ''));
      }
    }

    if (event is GetFirstSimulationFastCartEventWithPossiblePromoEvent) {
      yield FastCartLoadInProgress();
      try {
        var cart = await apiRepository.getFirstSimulationWithPossiblePromo(
            user: event.user,
            station: event.station,
            domain: event.domain,
            startDate: event.startDate,
            selectedContacts: event.selectedContacts,selectedValidity: event.selectedValidity);
            List<Contact> selectedContacts = [];
        if (event.selectedContacts.isNotEmpty)
          event.selectedContacts.forEach((element) {
            selectedContacts.add(cart.contacts
                .where((elementContacts) => element.id == elementContacts.id)
                .first);
          });
        cart.setSelectedContacts(event.selectedContacts);
        yield FastCartLoadSuccess(cart: cart);
      } on ApiException catch (ex) {
        yield FastCartLoadFailure(violationError: ex.errors!.list!.first);
      } catch (error) {
        yield FastCartLoadFailure(
            violationError:
                ViolationError(code: 1001, message: '', propertyPath: ''));
      }
    }

    if (event is SetFastCartEvent) {
      yield FastCartLoadInProgress();
      yield FastCartLoadSuccess(cart: event.cart);
    }

    if (event is EmptyFastCartEvent) {
      yield FastCartInitial();
    }
  }
}
