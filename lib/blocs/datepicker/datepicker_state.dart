part of 'datepicker_bloc.dart';

abstract class DatepickerState extends Equatable {
  const DatepickerState();

  @override
  List<Object> get props => [];
}

class DatepickerInitial extends DatepickerState {}

class DatepickerRequested extends DatepickerState {}

class DatepickerNotRequested extends DatepickerState {}
