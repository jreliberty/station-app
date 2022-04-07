import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../entities/api_exception.dart';
import '../../entities/violation_error.dart';
import '../../repository/api_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ApiRepository apiRepository;
  HomeBloc({required this.apiRepository}) : super(HomeInitial());

  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is InitHomeEvent) {
      yield HomeLoadInProgress();
      try {
        var listOffers = await apiRepository.getListOffers();
        var listAdvantages = await apiRepository.getListAdvantages();
        var listOffersAdvantages = {
          "offers": listOffers,
          "advantages": listAdvantages
        };
        yield HomeLoadSuccess(listOffersAdvantages: listOffersAdvantages);
      } on ApiException catch (ex) {
        print(ex.errors);
        yield HomeLoadFailure(violationError: ex.errors!.list!.first);
      } catch (error) {
        print(error);
        yield HomeLoadFailure(
            violationError:
                ViolationError(code: 1001, message: '', propertyPath: ''));
      }
    }
  }
}
