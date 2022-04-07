import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../entities/violation_error.dart';
import '../../repository/api_repository.dart';

part 'favorite_station_event.dart';
part 'favorite_station_state.dart';

class FavoriteStationBloc
    extends Bloc<FavoriteStationEvent, FavoriteStationState> {
  final ApiRepository apiRepository;
  FavoriteStationBloc({required this.apiRepository})
      : super(FavoriteStationInitial());

  @override
  Stream<FavoriteStationState> mapEventToState(
      FavoriteStationEvent event) async* {
    if (event is InitFavoriteStationEvent) {
      yield FavoriteStationLoadInProgress();
      var contractorId = await apiRepository.initFavoriteStationFromCache();
      yield FavoriteStationLoadSuccess(contractorId: contractorId);
    } else if (event is UpdateFavoriteStationEvent) {
      yield FavoriteStationLoadInProgress();
      await apiRepository.updateFavoriteStation(
          contractorId: event.contractorId);
      yield FavoriteStationLoadSuccess(contractorId: event.contractorId);
    }
  }
}
