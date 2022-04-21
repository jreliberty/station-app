import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:station/entities/token.dart';

import '../../entities/api_exception.dart';
import '../../entities/credentials.dart';
import '../../entities/violation_error.dart';
import '../../repository/api_repository.dart';

part 'connexion_event.dart';
part 'connexion_state.dart';

class ConnexionBloc extends Bloc<ConnexionEvent, ConnexionState> {
  final ApiRepository apiRepository;
  ConnexionBloc({required this.apiRepository}) : super(ConnexionInitial()) {
    on<ConnexionEvent>((event, emit) async {
      if (event is GetJWTEvent) {
        emit(GettingJwtInProgress());
        try {
          final token = await apiRepository.getJwt(
              email: event.email, password: event.password);
          print('ça marche askip');
          // await Future.delayed(Duration(seconds: 1));
          emit(GettingJwtDone(token: token));
        } on ApiException catch (ex) {
          emit(GettingJwtFailure(violationError: ex.errors!.list!.first));
        } catch (error) {
          emit(GettingJwtFailure(
              violationError:
                  ViolationError(code: 1001, message: '', propertyPath: '')));
        }
      }
      if (event is GetCredentialsEvent) {
        emit(GettingCredentialsInProgress());
        var prefs = await SharedPreferences.getInstance();
        String email = '';
        String password = '';
        if (prefs.getString('email') != null) {
          email = prefs.getString('email')!;
        }
        if (prefs.getString('password') != null) {
          password = prefs.getString('password')!;
        }
        if (email != '' && password != '') {
          emit(GettingCredentialsDone(
              credentials: Credentials(email: email, password: password)));
        } else {
          emit(ConnexionInitial());
        }
      }
      // TODO: implement event handler
    });
  }
}
