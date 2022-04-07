part of 'consumer_bloc.dart';

abstract class ConsumerState extends Equatable {
  const ConsumerState();

  @override
  List<Object> get props => [];
}

class ConsumerInitial extends ConsumerState {}

class ConsumerLoadInProgress extends ConsumerState {}

class ConsumerLoadSuccess extends ConsumerState {
  final User user;

  const ConsumerLoadSuccess({required this.user});
}

class ConsumerLoadFailure extends ConsumerState {
  final ViolationError violationError;

  const ConsumerLoadFailure({required this.violationError});
}


