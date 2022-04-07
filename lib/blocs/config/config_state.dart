part of 'config_bloc.dart';

abstract class ConfigState extends Equatable {
  const ConfigState();

  @override
  List<Object> get props => [];
}

class ConfigInitial extends ConfigState {}

class ConfigLoadInProgress extends ConfigState {}

class ConfigLoadSuccess extends ConfigState {
  final Config config;

  ConfigLoadSuccess({required this.config});
}

class ConfigLoadFailure extends ConfigState {
  final ViolationError violationError;

  const ConfigLoadFailure({required this.violationError});

  @override
  List<Object> get props => [violationError];
}
