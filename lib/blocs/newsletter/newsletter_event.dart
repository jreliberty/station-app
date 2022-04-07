part of 'newsletter_bloc.dart';

abstract class NewsletterEvent extends Equatable {
  const NewsletterEvent();

  @override
  List<Object> get props => [];
}

class InitNewsletterEvent extends NewsletterEvent {}

class SubscribeNewsletterEvent extends NewsletterEvent {}

class UnsubscribeNewsletterEvent extends NewsletterEvent {}
