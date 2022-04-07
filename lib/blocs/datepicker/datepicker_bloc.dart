import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'datepicker_event.dart';
part 'datepicker_state.dart';

class DatepickerBloc extends Bloc<DatepickerEvent, DatepickerState> {
  DatepickerBloc() : super(DatepickerInitial()) {
    on<DatepickerEvent>((event, emit) {
      if (event is DatepickerRequestedEvent) {
        emit(DatepickerInitial());
        emit(DatepickerRequested());
      } else if (event is DatepickerNotRequestedEvent) {
        emit(DatepickerInitial());
        emit(DatepickerNotRequested());
      }
    });
  }
}
