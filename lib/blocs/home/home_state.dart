part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoadInProgress extends HomeState {}

class HomeLoadSuccess extends HomeState {
  final Map<String, dynamic> listOffersAdvantages;

  HomeLoadSuccess({required this.listOffersAdvantages});
}

class HomeLoadFailure extends HomeState {
  final ViolationError violationError;

  const HomeLoadFailure({required this.violationError});

  @override
  List<Object> get props => [violationError];
}
