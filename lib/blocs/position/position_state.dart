part of 'position_bloc.dart';

abstract class PositionState extends Equatable {
  const PositionState();

  @override
  List<Object> get props => [];
}

class PositionInitial extends PositionState {}

class PositionLoadSuccess extends PositionState {
  final Position? position;

  PositionLoadSuccess({required this.position});
}
