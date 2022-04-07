import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../entities/api_exception.dart';
import '../../entities/token.dart';
import '../../entities/violation_error.dart';
import '../../repository/api_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final ApiRepository apiRepository;
  LoginBloc({required this.apiRepository}) : super((LoginInitial())) {
    on<LoginEvent>((event, emit) async {
      if (event is GetUrlForLoginEvent) {
        emit(GettingUrlInProgress());

        try {
          final response = await apiRepository.getUrlOneId();

          emit(GettingUrlDone(url: response.data['url']));
        } on ApiException catch (ex) {
          emit(GettingUrlFailure(violationError: ex.errors!.list!.first));
        } catch (error) {
          emit(GettingUrlFailure(
              violationError:
                  ViolationError(code: 1001, message: '', propertyPath: '')));
        }
      }
      if (event is GetJwtTokenEvent) {
        emit(GettingJwtInProgress());

        try {
          final token = await apiRepository.getJwt(event.uri);
          print('ça marche askip');
          print('2');
          emit(GettingJwtDone(token: token));
        } on ApiException catch (ex) {
          emit(GettingJwtFailure(violationError: ex.errors!.list!.first));
        } catch (error) {
          emit(GettingJwtFailure(
              violationError:
                  ViolationError(code: 1001, message: '', propertyPath: '')));
        }
      }
      if (event is RefreshJwtTokenEvent) {
        emit(GettingJwtInProgress());
        try {
          final token = await apiRepository.refreshJwt();
          print('3');
          emit(GettingJwtDone(token: token));
        } on ApiException catch (ex) {
          emit(GettingJwtFailure(violationError: ex.errors!.list!.first));
        } catch (error) {
          emit(GettingJwtFailure(
              violationError:
                  ViolationError(code: 1001, message: '', propertyPath: '')));
        }
      }
      if (event is ClearCookiesEvent) {
        emit(LoginInitial());
        try {} on ApiException catch (ex) {
          emit(GettingJwtFailure(violationError: ex.errors!.list!.first));
        } catch (error) {
          emit(GettingJwtFailure(
              violationError:
                  ViolationError(code: 1001, message: '', propertyPath: '')));
        }
      }
      if (event is JwtNotExpiredEvent) {
        emit(GettingJwtInProgress());
        await Future.delayed(Duration(milliseconds: 200));
        emit(GettingJwtDone(token: event.token));
      }
    });
  }
}
