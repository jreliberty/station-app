import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../entities/api_exception.dart';
import '../../entities/config.dart';
import '../../entities/violation_error.dart';
import '../../repository/api_repository.dart';

part 'config_event.dart';
part 'config_state.dart';

class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
  final ApiRepository apiRepository;
  ConfigBloc({required this.apiRepository}) : super(ConfigInitial());

  @override
  Stream<ConfigState> mapEventToState(ConfigEvent event) async* {
    if (event is InitConfigEvent) {
      yield ConfigLoadInProgress();
      try {
        var config = await apiRepository.initConfig();
        yield ConfigLoadSuccess(config: config);
      } on ApiException catch (ex) {
        yield ConfigLoadFailure(violationError: ex.errors!.list!.first);
      } catch (error) {
        yield ConfigLoadFailure(
            violationError:
                ViolationError(code: 1001, message: '', propertyPath: ''));
      }
    }
  }
}
