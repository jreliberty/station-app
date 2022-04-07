part of 'datepicker_bloc.dart';

abstract class DatepickerEvent extends Equatable {
  const DatepickerEvent();

  @override
  List<Object> get props => [];
}

class DatepickerRequestedEvent extends DatepickerEvent{}
class DatepickerNotRequestedEvent extends DatepickerEvent{}