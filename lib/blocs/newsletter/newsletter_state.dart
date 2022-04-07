part of 'newsletter_bloc.dart';

abstract class NewsletterState extends Equatable {
  const NewsletterState();

  @override
  List<Object> get props => [];
}

class NewsletterInitial extends NewsletterState {}

class NewsletterLoadInProgress extends NewsletterState {}

class NewsletterLoadSuccess extends NewsletterState {
  final bool isSubscribed;

  NewsletterLoadSuccess({required this.isSubscribed});
}

class NewsletterLoadFailure extends NewsletterState {
  final ViolationError violationError;

  const NewsletterLoadFailure({required this.violationError});

  @override
  List<Object> get props => [violationError];
}
