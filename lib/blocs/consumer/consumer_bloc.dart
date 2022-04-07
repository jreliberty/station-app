import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:corsac_jwt/corsac_jwt.dart';
import 'package:equatable/equatable.dart';
import 'package:mercure_client/mercure_client.dart';

import '../../constants/config.dart';
import '../../entities/api_exception.dart';
import '../../entities/user.dart';
import '../../entities/violation_error.dart';
import '../../repository/api_repository.dart';

part 'consumer_event.dart';
part 'consumer_state.dart';

class ConsumerBloc extends Bloc<ConsumerEvent, ConsumerState> {
  final ApiRepository apiRepository;
  ConsumerBloc({required this.apiRepository}) : super(ConsumerInitial());

  late StreamSubscription _subscription;

  @override
  Stream<ConsumerState> mapEventToState(ConsumerEvent event) async* {
    if (event is ListenConsumerEvent) {
    } else if (event is InitConsumerEvent) {
      yield ConsumerLoadInProgress();
      try {
        var consumer = await apiRepository.getUser();
        print("1");
        var builder = JWTBuilder();
        var signer = JWTHmacSha256Signer(MyConfig.TOKEN_MERCURE);
        var signedToken = builder.getSignedToken(signer);

        // final mercure = Mercure(
        //   url: MyConfig.HUB_URL, // your mercure hub url
        //   topics: [
        //     MyConfig.TOPIC_USER + consumer.id,
        //   ], // your mercure topic
        //   token: signedToken.toString(), // Bearer authorization
        // );
        // _subscription = mercure.listen((event) async* {
        //   _subscription.cancel();
        //   var consumer = await apiRepository.getUser();
        //   yield ConsumerLoadSuccess(user: consumer);
        //   print('event');
        // });
        yield ConsumerLoadSuccess(user: consumer);
      } on ApiException catch (ex) {
        print('ApiException : ' + ex.errors.toString());
        yield ConsumerLoadFailure(violationError: ex.errors!.list!.first);
      } catch (error) {
        print('error : ' + error.toString());
        yield ConsumerLoadFailure(
            violationError:
                ViolationError(code: 1001, message: '', propertyPath: ''));
      }
    } else if (event is CreateContactEvent) {
      yield ConsumerLoadInProgress();
      try {
        var consumer = await apiRepository.createContact(
          body: event.body,
          bodyPhone: event.bodyPhone,
          userId: event.userId,
        );
        yield ConsumerLoadSuccess(user: consumer);
      } on ApiException catch (ex) {
        print('ApiException : ' + ex.errors.toString());
        yield ConsumerLoadFailure(violationError: ex.errors!.list!.first);
      } catch (error) {
        print('error : ' + error.toString());
        yield ConsumerLoadFailure(
            violationError:
                ViolationError(code: 1001, message: '', propertyPath: ''));
      }
    } else if (event is UpdateContactPersonalInfoEvent) {
      yield ConsumerLoadInProgress();
      print("keski se passe");
      try {
        var consumer = await apiRepository.updateContactPersonalInfo(
          body: event.body,
          contactId: event.contactId,
        );
        yield ConsumerLoadSuccess(user: consumer);
      } on ApiException catch (ex) {
        print('ApiException : ' + ex.errors.toString());
        yield ConsumerLoadFailure(violationError: ex.errors!.list!.first);
      } catch (error) {
        print('error : ' + error.toString());
        yield ConsumerLoadFailure(
            violationError:
                ViolationError(code: 1001, message: '', propertyPath: ''));
      }
    } else if (event is CreateContactAdressEvent) {
      yield ConsumerLoadInProgress();
      try {
        var consumer = await apiRepository.createContactAdress(
          body: event.body,
        );
        yield ConsumerLoadSuccess(user: consumer);
      } on ApiException catch (ex) {
        print('ApiException : ' + ex.errors.toString());
        yield ConsumerLoadFailure(violationError: ex.errors!.list!.first);
      } catch (error) {
        print('error : ' + error.toString());
        yield ConsumerLoadFailure(
            violationError:
                ViolationError(code: 1001, message: '', propertyPath: ''));
      }
    } else if (event is UpdateContactAdressEvent) {
      yield ConsumerLoadInProgress();
      try {
        var consumer = await apiRepository.updateContactAdress(
          body: event.body,
          adressId: event.adressId,
        );
        yield ConsumerLoadSuccess(user: consumer);
      } on ApiException catch (ex) {
        print('ApiException : ' + ex.errors.toString());
        yield ConsumerLoadFailure(violationError: ex.errors!.list!.first);
      } catch (error) {
        print('error : ' + error.toString());
        yield ConsumerLoadFailure(
            violationError:
                ViolationError(code: 1001, message: '', propertyPath: ''));
      }
    } else if (event is DeleteContactAdressEvent) {
      yield ConsumerLoadInProgress();
      try {
        var consumer = await apiRepository.deleteContactAdress(
          adressId: event.adressId,
        );
        yield ConsumerLoadSuccess(user: consumer);
      } on ApiException catch (ex) {
        print('ApiException : ' + ex.errors.toString());
        yield ConsumerLoadFailure(violationError: ex.errors!.list!.first);
      } catch (error) {
        print('error : ' + error.toString());
        yield ConsumerLoadFailure(
            violationError:
                ViolationError(code: 1001, message: '', propertyPath: ''));
      }
    } else if (event is AssignPassEvent) {
      yield ConsumerLoadInProgress();
      try {
        var consumer = await apiRepository.assignPass(
            contactId: event.contactId, passId: event.passId);
        yield ConsumerLoadSuccess(user: consumer);
      } on ApiException catch (ex) {
        print('ApiException : ' + ex.errors.toString());
        yield ConsumerLoadFailure(violationError: ex.errors!.list!.first);
      } catch (error) {
        print('error : ' + error.toString());
        yield ConsumerLoadFailure(
            violationError:
                ViolationError(code: 1001, message: '', propertyPath: ''));
      }
    } else if (event is CreateSubcontactEvent) {
      yield ConsumerLoadInProgress();
      try {
        var contactId = await apiRepository.createSubcontact(body: event.body);
        //await Future.delayed(Duration(milliseconds: 500));
        var consumer = await apiRepository.assignPass(
            contactId: contactId, passId: event.passId);
        yield ConsumerLoadSuccess(user: consumer);
      } on ApiException catch (ex) {
        print('ApiException : ' + ex.errors.toString());
        yield ConsumerLoadFailure(violationError: ex.errors!.list!.first);
      } catch (error) {
        print('error : ' + error.toString());
        yield ConsumerLoadFailure(
            violationError:
                ViolationError(code: 1001, message: '', propertyPath: ''));
      }
    } else if (event is UpdateSubcontactEvent) {
      yield ConsumerLoadInProgress();

      print("keski se passee");
      try {
        await apiRepository.updateContactPersonalInfo(
          body: event.body,
          contactId: event.contactId,
        );
        //await Future.delayed(Duration(milliseconds: 500));
        var user = await apiRepository.assignPass(
            contactId: event.contactId, passId: event.passId);
        yield ConsumerLoadSuccess(user: user);
      } on ApiException catch (ex) {
        print('ApiException : ' + ex.errors.toString());
        yield ConsumerLoadFailure(violationError: ex.errors!.list!.first);
      } catch (error) {
        print('error : ' + error.toString());
        yield ConsumerLoadFailure(
            violationError:
                ViolationError(code: 1001, message: '', propertyPath: ''));
      }
    }
  }
}
