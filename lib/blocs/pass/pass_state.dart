part of 'pass_bloc.dart';

abstract class PassState extends Equatable {
  const PassState();

  @override
  List<Object> get props => [];
}

class PassInitial extends PassState {}

class FindOpenPassInProgress extends PassState {}

class FindOpenPassSuccess extends PassState {
  final OpenPassResponse openPassResponse;

  FindOpenPassSuccess({required this.openPassResponse});
}

class FinOpenPassLoadFailure extends PassState {
  final ViolationError violationError;

  const FinOpenPassLoadFailure({required this.violationError});

  @override
  List<Object> get props => [violationError];
}


