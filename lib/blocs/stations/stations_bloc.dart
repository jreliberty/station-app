import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../entities/api_exception.dart';
import '../../entities/station.dart';
import '../../entities/violation_error.dart';
import '../../repository/api_repository.dart';
import '../orders_history/orders_history_bloc.dart';

part 'stations_event.dart';
part 'stations_state.dart';

class StationsBloc extends Bloc<StationsEvent, StationsState> {
  final ApiRepository apiRepository;
  StationsBloc({required this.apiRepository}) : super(StationsInitial());

  @override
  Stream<StationsState> mapEventToState(StationsEvent event) async* {
    if (event is InitStationsEvent) {
      yield StationsLoadInProgress();
      try {
        var listStations = await apiRepository.getSkiResortsList();
        var ordersHistoryBloc = event.ordersHistoryBloc;
        ordersHistoryBloc.add(InitOrdersHistoryEvent());
        yield StationsLoadSuccess(
            null,
            false,
            Station(
                latitude: 0,
                longitude: 0,
                id: 0,
                contractorId: 0,
                name: 'name',
                shortName: 'shortName',
                active: true,
                domains: [],
                consumerCategories: [],
                weatherData: null,
                activeSales: true,
                submerchantId: ''),
            listStations: listStations,
            isReset: false);
      } on ApiException catch (ex) {
        print('ApiException : ' + ex.errors.toString());
        yield StationsLoadFailure(violationError: ex.errors!.list!.first);
      } catch (error) {
        print('error : ' + error.toString());
        yield StationsLoadFailure(
            violationError:
                ViolationError(code: 1001, message: '', propertyPath: ''));
      }
    } else if (event is SelectStationEvent) {
      yield StationsLoadInProgress();
      if (event.selectedStation.name == 'name')
        yield StationsLoadSuccess(event.date, false, event.selectedStation,
            listStations: event.listStations, isReset: false);
      yield StationsLoadSuccess(event.date, true, event.selectedStation,
          listStations: event.listStations, isReset: false);
    } else if (event is DeselectStationEvent) {
      yield StationsLoadInProgress();
      yield StationsLoadSuccess(event.date, false, event.selectedStation,
          listStations: event.listStations, isReset: false);
    } else if (event is ResetStationEvent) {
      yield StationsLoadInProgress();
      try {
        var listStationsWithDate =
            await apiRepository.getSkiResortsListWithDate(date: event.date);
        bool isSelectedStation = true;
        if (event.selectedStation == null)
          isSelectedStation = false;
        else if (event.selectedStation != null) {
          if (event.selectedStation!.name == 'name') isSelectedStation = false;
        }
        Station? selectedStation;
        if (isSelectedStation && event.selectedStation != null) {
          selectedStation = listStationsWithDate
              .where((element) =>
                  element.contractorId == event.selectedStation!.contractorId)
              .first;
        } else
          selectedStation = event.selectedStation;

        yield StationsLoadSuccess(
            event.date, isSelectedStation, selectedStation,
            listStations: listStationsWithDate, isReset: true);
      } on ApiException catch (ex) {
        print('ApiException : ' + ex.errors.toString());
        yield StationsLoadFailure(violationError: ex.errors!.list!.first);
      } catch (error) {
        print('error : ' + error.toString());
        yield StationsLoadFailure(
            violationError:
                ViolationError(code: 1001, message: '', propertyPath: ''));
      }
    }
  }
}
