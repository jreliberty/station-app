part of 'pass_bloc.dart';

abstract class PassEvent extends Equatable {
  const PassEvent();

  @override
  List<Object> get props => [];
}

class FindOpenPassEvent extends PassEvent {
  final String passNumber;

  FindOpenPassEvent({required this.passNumber});
}

