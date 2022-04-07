part of 'position_bloc.dart';

abstract class PositionEvent extends Equatable {
  const PositionEvent();

  @override
  List<Object> get props => [];
}

class InitPositionEvent extends PositionEvent {}

