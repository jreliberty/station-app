import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../entities/violation_error.dart';
import '../../repository/api_repository.dart';

part 'newsletter_event.dart';
part 'newsletter_state.dart';

class NewsletterBloc extends Bloc<NewsletterEvent, NewsletterState> {
  final ApiRepository apiRepository;
  NewsletterBloc({required this.apiRepository}) : super(NewsletterInitial());

  @override
  Stream<NewsletterState> mapEventToState(NewsletterEvent event) async* {
    if (event is InitNewsletterEvent) {
      yield NewsletterLoadInProgress();
      yield NewsletterLoadSuccess(isSubscribed: true);
    } else if (event is SubscribeNewsletterEvent) {
      yield NewsletterLoadInProgress();
      yield NewsletterLoadSuccess(isSubscribed: true);
    } else if (event is UnsubscribeNewsletterEvent) {
      yield NewsletterLoadInProgress();
      yield NewsletterLoadSuccess(isSubscribed: false);
    }
  }
}
