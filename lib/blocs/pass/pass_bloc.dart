import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../entities/api_exception.dart';
import '../../entities/open_pass_response.dart';
import '../../entities/violation_error.dart';
import '../../repository/api_repository.dart';

part 'pass_event.dart';
part 'pass_state.dart';

class PassBloc extends Bloc<PassEvent, PassState> {
  final ApiRepository apiRepository;
  PassBloc({required this.apiRepository}) : super(PassInitial());

  Stream<PassState> mapEventToState(PassEvent event) async* {
    if (event is FindOpenPassEvent) {
      yield FindOpenPassInProgress();
      try {
        var openPassResponse =
            await apiRepository.findOpenPass(passNumber: event.passNumber);
        yield FindOpenPassSuccess(openPassResponse: openPassResponse);
      } on ApiException catch (ex) {
        yield FinOpenPassLoadFailure(violationError: ex.errors!.list!.first);
      } catch (error) {
        yield FinOpenPassLoadFailure(
            violationError:
                ViolationError(code: 1001, message: '', propertyPath: ''));
      }
    }
  }
}
